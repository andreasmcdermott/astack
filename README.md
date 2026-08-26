# agent-skills

My portable agent skills. One source of truth in `skills/`, published to every
harness on the machine so there is only ever one copy to edit.

## Layout

    skills/<name>/SKILL.md

Each `SKILL.md` opens with YAML frontmatter holding `name` and `description`,
then the instruction body. The `name` must match its directory. Supporting files
sit beside `SKILL.md` in the same directory.

## Install

    ./install.sh

This publishes every directory under `skills/` to three roots:

    ~/.agents/skills    link    harness-agnostic root, read by Codex and other agents
    ~/.claude/skills    link    Claude Code
    ~/.bb/skills        copy    bb

A root whose parent directory is missing gets skipped, so the same script runs on
a machine that has only some of these installed.

## Why bb gets a copy

bb's user-skill scanner ignores symlinked directories. A symlink at
`~/.bb/skills/<name>` resolves fine from the shell but never shows up in
`bb skill list` under the `bb-user` scope. So bb gets a real copy, refreshed on
every run, with a `.agent-skills-source` marker naming where it came from.

The marker is what makes overwriting safe. `install.sh` refreshes a copy only
when the marker points back at this repo. A directory without a matching marker
is treated as yours, and the script skips it and says so rather than destroying
work. Pass `-f` to take it over.

The practical consequence: after editing a skill, symlinked roots update
themselves, but bb does not until you re-run `./install.sh`.

## Flags

    ./install.sh -n                   Show what would change, touch nothing.
    ./install.sh -f                   Take over unmanaged paths.
    ./install.sh -t /some/dir         Publish to another root, symlinked.
    ./install.sh -t copy:/some/dir    Publish to another root, copied.

`-f` moves the displaced directory to `~/.agent-skills-backups/<root>/<name>.<timestamp>`.
Backups deliberately land outside the skill roots. A directory named `<name>.bak`
left inside a root would be scanned as a second skill declaring the same `name`,
and harnesses drop both halves of a name collision. Override the location with
`AGENT_SKILLS_BACKUP_DIR`.

## Adding a skill

1. Create `skills/<name>/SKILL.md` with `name` and `description` frontmatter.
2. Run `./install.sh`.
3. Commit.

## Skills

- `recall` reconstructs the live state of work being resumed from another
  thread or session.
- `interrogate` runs an independent, defect-first review panel and judges the
  findings.
- `blast-radius` traces hidden contracts outside a diff and proves its key
  safety assumption.
- `how` explains runtime flow, data ownership, boundaries, and failure paths.
- `why` recovers design rationale from code history and other available records.
- `teach` combines how and why into a layered mental model.
- `unslop` cuts AI tells from writing.

These skills are adapted from
[pstack](https://github.com/cursor/plugins/tree/main/pstack) at revision
`bdf7aa355337897f167153e05069aca505dae17c`. The workflow skills replace
Cursor-specific transcript paths, model IDs, and `Task` calls with portable
capability discovery and optional bb-native coordination. This repository is a
fork, not a subscription, so upstream changes do not arrive automatically. See
[`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md) for attribution and license
terms.
