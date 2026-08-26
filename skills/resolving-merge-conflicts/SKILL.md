---
name: resolving-merge-conflicts
description: Resolve active Git merge, rebase, cherry-pick, or revert conflicts by recovering both sides' original intent and preserving compatible behavior. Use automatically when an in-progress Git operation has conflicts or when the user asks to resolve merge conflicts. Respect repository branch rules and avoid destructive reset or abort operations.
---

# Resolve merge conflicts

Resolve intent, not just conflict markers. A syntactically clean file can still
discard behavior from one side or combine two incompatible assumptions.

## Establish the operation

Inspect Git status, the active operation, conflicted paths, current branch, and
applicable repository instructions. Preserve repository-specific branch naming
and workflow rules supplied by the environment. Do not reset, abort, switch
branches, or discard work as a shortcut.

For each conflict, identify the base and both sides. Read the commits, PRs,
tasks, tests, and adjacent changes that explain why each side changed. Treat
these records as primary evidence; do not infer intent from the conflict hunk
alone.

## Resolve each hunk

State the behavior each side intended. Then choose the smallest resolution that:

- preserves both intents when they are compatible
- follows the newer deliberate decision when one side supersedes the other
- maintains surrounding contracts, types, imports, tests, and generated output
- introduces no behavior that neither side requested

Search for semantic conflicts outside marker-bearing files, such as renamed
callers, duplicated migrations, changed schemas, or tests that encode opposite
assumptions. Remove every conflict marker and inspect the complete resolved
file, not only the edited lines.

## Verify and continue

Run focused checks for the resolved paths, then the closest broader checks.
Stage only the resolved files relevant to the operation. Continue the merge,
rebase, cherry-pick, or revert non-interactively when it is safe to do so. If a
new conflict appears, repeat the intent analysis rather than applying the prior
resolution mechanically.

Report the intents preserved, any intent deliberately superseded, verification
results, and whether the Git operation completed. If continuation requires a
new product decision or authority, stop with the exact unresolved choice.

## Completion criterion

Resolution is complete when Git reports no unmerged paths, each hunk and likely
semantic conflict has been checked against both sides' intent, relevant tests or
checks pass, and the requested Git operation has completed or is paused only on
a clearly named external decision.
