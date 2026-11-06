---
name: cleanup-task
description: Safely finish and clean up a completed bb task or story. Use when the user invokes /cleanup-task or asks to wrap up, finish, retire, or clean up the current task/story, including its bb threads, terminals, Git branches, and managed worktrees.
---

# Cleanup task

Finish the current bb task without losing work. Inspect first and show the exact
cleanup targets. Proceed without confirmation only for the verified, merged
session cleanup defined below. Ask for confirmation when cleanup affects other
branches, worktrees, or chats outside that verified task scope, or adds actions
beyond it.

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
- an associated pull request is open, closed-unmerged, has unknown state, or
  was merged into a branch other than `main`;
- the candidate is the default/protected branch, the primary checkout, or a
  branch checked out by an unrelated worktree;
- the branch, base, remote, environment, or thread scope is ambiguous.

Verify preservation against the correct repository's current remote `main`.
Use fresh remote/API evidence, refreshing relevant Git refs when needed for
ancestry checks. Stale local refs or a missing remote feature branch do not
prove a merge.

A PR reported as merged into `main` proves preservation of its merged head,
including squash or rebase merges, only after verifying that its resulting
merge commit remains in current remote `main`. Match the local branch tip and,
if it still exists, the current remote feature branch tip to that head. Any
different tip must independently be proven to be an ancestor of current remote `main`.
A previously merged PR does not authorize deleting commits added afterward.
Without an associated PR, require the local tip and any existing remote feature
branch tip to be ancestors of current remote `main`. If any associated PR is
unmerged or any merge evidence is missing, ambiguous, or contradictory, decline
cleanup and report the blocker.

Do not reinterpret `/cleanup-task` as permission to discard unmerged work. If
the audit finds unpreserved work, stop with a compact blocker report. Offer a
separate, explicit discard confirmation naming the commits/files only if the
user says that work should be thrown away.

## Confirmation-free session cleanup

Invoking cleanup authorizes proceeding without another confirmation only when
all audit checks pass and the complete effect is exactly:

- delete the current session's local feature branch;
- retire the current session's bb-managed worktree;
- archive the current chat thread and its expected skill-created descendants.

Classify every child thread and hidden source fork before archiving. A descendant
is expected when bb's tree and the task history or originating skill invocation
show it was created by a skill workflow for this task, such as a reviewer or
implementation worker, and it has not been repurposed for independent work.
A parent link or matching title alone is insufficient evidence.

Reviewers created by `/ship-story` for this Story are expected descendants,
including reviewers from every review round and their hidden source forks.
Verify their origin from bb's tree and the recorded reviewer launches or review
packets, and check that they have not taken on independent work. Their number,
review round, or model does not add a confirmation requirement.

If every descendant is expected and passes the activity and preservation audits
above, include them in the preview and proceed without confirmation. Unexpected
or unverified descendants require the confirmation path below.

Verify that no live thread outside the cleanup tree shares the environment and
that no other worktree uses the branch. Detaching this worktree and closing the
cleanup tree's idle terminals as part of archiving are implementation steps
within this scope. Expected descendants do not waive any audit or authorize
removing additional branches or retiring additional worktrees without confirmation.

Leave the remote branch intact if it still exists. Its existence alone does
not require confirmation or expand cleanup to remote deletion. Removing a
remote branch requires an explicit, confirmed preview.

Show a concise statement of the branch, worktree, all chats to archive, why
each descendant is expected, and current merge evidence, then proceed. Do not
ask for confirmation or pause for a reply when these conditions hold. Recheck
them immediately before execution. If scope expands, use the confirmation path
below; if preservation fails, decline.

## Preview and confirmation for other scopes

Present one concise preview grouped by environment. Name:

- threads that will be archived;
- terminals that bb will close;
- managed worktree paths bb will retire after its archive grace window;
- exact local branches to delete and the evidence that makes each safe;
- exact remote branches that still exist and would be deleted;
- anything retained, with the reason.

If the eligible cleanup differs from the exact session cleanup above, ask for
confirmation of those targets before any mutation or archive. This includes
additional branches or worktrees, unexpected or unverified child threads or
hidden source forks, shared-environment cleanup, and remote branch deletion.
Expected skill-created descendants in the session cleanup scope above do not
require confirmation merely because they are child threads or hidden forks.
Do not ask the user to confirm ordinary cleanup of unmerged or unpreserved work; decline it as described above.
Include remote deletion only when explicitly requested, and name it in the
confirmation. Otherwise retain remote branches.

## Permission handling

Git mutations commonly write through a worktree's `.git` file into repository
metadata outside the provider's workspace sandbox. The verified session cleanup
above is already authorized by the cleanup request. Other scopes become
authorized when the user confirms the exact preview. Use that authorization
for the listed Git mutations and the execution tool's permission-escalation
mechanism on the first attempt. Do not intentionally make a sandboxed attempt
merely to discover the expected permission denial.

Use a narrow, command-specific escalation request and explain the exact branch
or remote ref being changed. Do not request full-access mode or a broad shell
allowlist. If a mutation unexpectedly returns a sandbox/permission denial,
immediately retry that same already-authorized command with escalation; do not
stop and ask the user to invoke `/cleanup-task` or tell the agent to retry.

A user-facing approval may still be required when the thread uses a mode that
requires manual approval. That approval is the security boundary and should be
presented directly; it is not a cleanup failure. Never evade it through a
terminal, helper daemon, alternate Git plumbing command, or indirect script.

## Execute

Re-run the critical cleanliness, activity, preservation, and scope checks
immediately before execution, including after any required confirmation. If
anything changed, re-audit. Decline if preservation fails; obtain confirmation
before proceeding with any expanded scope.

For each authorized, cleanup-eligible managed worktree branch:

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
