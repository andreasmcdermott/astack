#!/usr/bin/env bash
# Publish every skill in ./skills to each agent harness skill root.
#
# Roots are symlinked where the harness follows symlinks, and copied where it
# does not. bb's user-skill scanner ignores symlinked directories, so ~/.bb/skills
# gets a synced copy instead.
set -eo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$REPO_DIR/skills"
MARKER=".agent-skills-source"
# Backups never live inside a skill root. A directory named <name>.bak there
# would be scanned as a second skill declaring the same name, and harnesses
# drop both halves of a name collision.
BACKUP_ROOT="${AGENT_SKILLS_BACKUP_DIR:-$HOME/.agent-skills-backups}"

# mode:path
DEFAULT_TARGETS="link:$HOME/.agents/skills
link:$HOME/.claude/skills
copy:$HOME/.bb/skills"

force=0
dry_run=0
explicit_targets=""

usage() {
  cat <<USAGE
usage: install.sh [options]

  -t, --target [MODE:]DIR  Publish to DIR. MODE is link (default) or copy. Repeatable.
  -f, --force              Replace unmanaged paths, backing them up under
                           $BACKUP_ROOT.
  -n, --dry-run            Print what would change without touching the disk.
  -h, --help               Show this message.

Default targets, skipped when the parent directory is absent:
$DEFAULT_TARGETS
USAGE
}

while [ $# -gt 0 ]; do
  case "$1" in
    -t|--target)
      case "$2" in
        link:*|copy:*) explicit_targets="$explicit_targets$2"$'\n' ;;
        *)             explicit_targets="$explicit_targets"link:"$2"$'\n' ;;
      esac
      shift 2 ;;
    -f|--force)   force=1; shift ;;
    -n|--dry-run) dry_run=1; shift ;;
    -h|--help)    usage; exit 0 ;;
    *) echo "install.sh: unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
done

if [ -n "$explicit_targets" ]; then
  targets="$explicit_targets"; require_parent=0
else
  targets="$DEFAULT_TARGETS"; require_parent=1
fi

run() { if [ "$dry_run" -eq 1 ]; then echo "      would: $*"; else "$@"; fi; }

# A copy we made carries a marker naming its source. Anything else is the
# user's own file and we leave it alone unless --force says otherwise.
is_managed_copy() {
  [ -f "$1/$MARKER" ] && [ "$(cat "$1/$MARKER")" = "$2" ]
}

backup_path() {
  local root="$1" name="$2" slug
  slug="$(printf '%s' "${root#$HOME/}" | tr '/' '_')"
  printf '%s/%s/%s.%s' "$BACKUP_ROOT" "$slug" "$name" "$(date +%Y%m%d%H%M%S)"
}

copy_matches_source() {
  is_managed_copy "$1" "$2" || return 1
  diff -r -q -x "$MARKER" "$2" "$1" >/dev/null 2>&1
}

publish_copy() {
  local src="$1" dest="$2"
  run rm -rf "$dest"
  run cp -R "$src" "$dest"
  if [ "$dry_run" -eq 1 ]; then
    echo "      would: write $dest/$MARKER"
  else
    printf '%s\n' "$src" > "$dest/$MARKER"
  fi
}

[ -d "$SRC_DIR" ] || { echo "install.sh: no skills directory at $SRC_DIR" >&2; exit 1; }

published=0
skipped=0

while IFS= read -r entry; do
  [ -n "$entry" ] || continue
  mode="${entry%%:*}"
  root="${entry#*:}"

  if [ "$require_parent" -eq 1 ] && [ ! -d "$(dirname "$root")" ]; then
    echo "skip $root (harness not installed)"
    continue
  fi

  echo "$root [$mode]"
  run mkdir -p "$root"

  for src in "$SRC_DIR"/*/; do
    [ -d "$src" ] || continue
    src="${src%/}"
    name="$(basename "$src")"
    dest="$root/$name"

    if [ "$mode" = copy ]; then
      if [ -L "$dest" ]; then
        echo "  convert  $name (symlink to copy)"
        run rm "$dest"
      elif [ -d "$dest" ]; then
        if copy_matches_source "$dest" "$src"; then
          echo "  ok       $name"
          published=$((published + 1)); continue
        elif is_managed_copy "$dest" "$src"; then
          echo "  update   $name"
        elif [ "$force" -eq 1 ]; then
          backup="$(backup_path "$root" "$name")"
          echo "  replace  $name (backup at $backup)"
          run mkdir -p "$(dirname "$backup")"
          run mv "$dest" "$backup"
        else
          echo "  SKIP     $name is an unmanaged copy. Use --force to replace it."
          skipped=$((skipped + 1)); continue
        fi
      elif [ -e "$dest" ]; then
        echo "  SKIP     $name exists and is not a directory."
        skipped=$((skipped + 1)); continue
      else
        echo "  copy     $name"
      fi
      publish_copy "$src" "$dest"
      published=$((published + 1))
      continue
    fi

    if [ -L "$dest" ]; then
      current="$(readlink "$dest")"
      if [ "$current" = "$src" ]; then
        echo "  ok       $name"
        published=$((published + 1)); continue
      fi
      echo "  relink   $name (was $current)"
      run rm "$dest"
    elif [ -e "$dest" ]; then
      if [ "$force" -eq 1 ]; then
        backup="$(backup_path "$root" "$name")"
        echo "  replace  $name (backup at $backup)"
        run mkdir -p "$(dirname "$backup")"
        run mv "$dest" "$backup"
      else
        echo "  SKIP     $name is a real path, not a symlink. Use --force to replace it."
        skipped=$((skipped + 1)); continue
      fi
    else
      echo "  link     $name"
    fi

    run ln -s "$src" "$dest"
    published=$((published + 1))
  done
done <<< "$targets"

echo
echo "$published published, $skipped skipped."
[ "$skipped" -eq 0 ]
