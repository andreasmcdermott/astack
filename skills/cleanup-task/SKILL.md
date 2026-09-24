---
name: cleanup-task
description: Safely finish and clean up a completed bb task or story. Use when the user invokes /cleanup-task or asks to wrap up, finish, retire, or clean up the current task/story, including its bb threads, terminals, Git branches, and managed worktrees.
---

# Cleanup task

Finish the current bb task without losing work. Treat branch deletion and bb's
managed-worktree retirement as destructive: inspect first, show one exact
cleanup preview, and obtain confirmation before changing Git state or archiving.

## Scope

Start with `bb status` and `bb thread show --self --json`. The current thread is
the cleanup root. Include its recursively assigned child threads and hidden
source forks because archiving the root cascades to them. Use `bb thread list
--project <project-id> --include-hidden --json` to discover the tree and collect
each distinct environment.

Also identify live threads outside this tree that share one of those
environments. Do not detach or delete that environment's branch, and do not
claim its worktree will be removed, while an unrelated live thread still uses
it. Explain the shared-environment hold in the preview.

If the current environment is a personal, unmanaged, non-Git, or primary
project checkout, never remove its directory or default branch. It may still be
appropriate to archive the task threads.

## Audit every affected environment

Use bb's read-only surfaces before raw Git where possible:

- `bb environment show <environment-id> --json`
- `bb environment status <environment-id> --json`, adding
  `--merge-base-branch <base>` when a reliable base branch is known
- `bb environment pull-request show <environment-id> --json`
- `bb thread list --project <project-id> --include-hidden --json`

For a Git environment, verify the exact path, current branch, base/default
branch, worktree state, upstream, and pull-request state. Use read-only Git
checks when bb's response is insufficient: `git status --porcelain=v1
--untracked-files=all`, `git rev-parse`, `git rev-list --left-right --count`,
`git merge-base --is-ancestor`, `git worktree list --porcelain`, and
`git ls-remote --heads`.

Do not clean an environment when any of these is true:

- tracked, staged, unstaged, or untracked work remains;
- an agent, terminal, or queued operation is still actively using it;
- commits exist only on the local branch or their preservation cannot be
  verified;
- a pull request is open, closed-unmerged, or has unknown state and the branch
  is not already contained in the chosen base;
- the candidate is the default/protected branch, the primary checkout, or a
  branch checked out by an unrelated worktree;
- the branch, base, remote, environment, or thread scope is ambiguous.

A merged pull request is sufficient preservation evidence even after a squash
or rebase merge. Without a merged PR, require the branch tip to be an ancestor
of the chosen local or remote base. Merely having pushed a feature branch is not
proof that a completed task is merged; retain it unless the user explicitly
chooses a discard workflow.

Do not reinterpret `/cleanup-task` as permission to discard unmerged work. If
the audit finds unpreserved work, stop with a compact blocker report. Offer a
separate, explicit discard confirmation naming the commits/files only if the
user says that work should be thrown away.

## Preview and confirmation

Present one concise preview grouped by environment. Name:

- threads that will be archived;
- terminals that bb will close;
- managed worktree paths bb will retire after its archive grace window;
- exact local branches to delete and the evidence that makes each safe;
- exact remote branches that still exist and would be deleted;
- anything retained, with the reason.

Ask for confirmation of those exact targets. Remote branch deletion must be
visible in this confirmation; do not silently infer consent from a generic
cleanup request when the preview was not shown.

## Permission handling

Git mutations commonly write through a worktree's `.git` file into repository
metadata outside the provider's workspace sandbox. Once the user confirms the
exact preview, treat that confirmation as authorization for the listed Git
mutations and use the execution tool's permission-escalation mechanism on the
first attempt. Do not intentionally make a sandboxed attempt merely to discover
the expected permission denial.

Use a narrow, command-specific escalation request and explain the exact branch
or remote ref being changed. Do not request full-access mode or a broad shell
allowlist. If a mutation unexpectedly returns a sandbox/permission denial,
immediately retry that same already-confirmed command with escalation; do not
stop and ask the user to invoke `/cleanup-task` or tell the agent to retry.

A user-facing approval may still be required when the thread uses a mode that
requires manual approval. That approval is the security boundary and should be
presented directly; it is not a cleanup failure. Never evade it through a
terminal, helper daemon, alternate Git plumbing command, or indirect script.

## Execute

Re-run the critical cleanliness, activity, and preservation checks immediately
after confirmation. If anything changed, stop and show a refreshed preview.

For each confirmed, cleanup-eligible managed worktree branch:

1. Validate the candidate with `git check-ref-format --branch <branch>` and
   ensure it is neither the selected base nor the default branch.
2. Detach that worktree at its current `HEAD` with `git switch --detach`. This
   releases the local branch without rewriting files. Submit this Git mutation
   with narrow escalation on its first attempt when the execution tool supports
   it.
3. Delete the local branch with `git branch -d <branch>` when Git accepts the
   safe deletion. Submit it with narrow escalation on its first attempt. Because
   the worktree was detached at the branch tip, normal completed branches should
   not require force deletion, including most squash/rebase-merged PRs.
4. If safe deletion fails for a Git reason rather than a permission denial,
   switch the worktree back to the original branch and retain it. Do not replace
   `-d` with `-D` automatically. Force deletion is a separate discard action
   that requires fresh, explicit confirmation and a one-off approval; it must
   never receive standing permission.
5. Delete a confirmed remote branch with `git push <remote> --delete <branch>`
   only after merged-PR evidence is still current. A missing remote branch is
   already clean, not an error. Submit the confirmed remote deletion with
   narrow escalation on its first attempt if required by the environment.

Do not run `rm -rf`, manually delete a bb-managed worktree, or edit Git worktree
metadata. bb owns that lifecycle.

After all branch operations succeed, send a brief commentary message stating
that the final archive will close this thread. Then run exactly one bb lifecycle
operation as the last action:

- normally `bb thread archive <cleanup-root-thread-id> --json`, which archives
  the root plus its assigned children and hidden source forks; or
- `bb environment archive-threads <environment-id> --json` only when the user
  explicitly chose an entire shared environment as the cleanup scope.

Archiving closes thread terminals. When no live thread remains in a managed
environment, bb marks it retiring, keeps a short undo grace window, and then
removes the managed worktree. The Git branch cleanup above is separate because
bb deliberately preserves branch refs when retiring a worktree.

Do not perform more work after the archive call. If the call returns before the
provider stops, report only the archived thread IDs and which branches were
removed or retained.
