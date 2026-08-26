---
name: recall
description: Reconstruct recent working context before resuming a task. Use when the user says "continue from", "catch me up", "where did I leave off", "recall my work on X", or asks to resume work from another chat or agent thread. Do not use for a general summary of unrelated history.
---

# Recall working context

Rebuild the smallest reliable context capsule needed to resume work. Treat prior
agent summaries as leads, not proof. Check live state before presenting anything
as current.

## Scope

1. Identify the topic, project, source thread, task, PR, or branch named by the
   user.
2. Stay within that scope. Do not search unrelated projects or private chat
   history merely because it is accessible.
3. If the user names a source thread, start there and follow only explicit
   predecessor links needed to understand the handoff.

## Find the record

Use the history mechanism the current environment provides.

- In bb, read the `bb-cli` skill, then use `bb thread show`, `bb thread log`,
  `bb thread output`, and thread search or history commands. Inspect the current
  environment and PR state as well. Do not assume that a previous thread shares
  the current working directory.
- In another harness, use its native conversation history, transcript index, or
  session tools. If no history tool exists, use the context the user supplied
  and say what could not be recovered.
- For a small number of threads, read them directly. For a large relevant set,
  delegate bounded slices if delegation is available, then keep only the
  findings in the main context.

## Reconcile with live state

Check the artifacts that can make an old handoff stale:

- `git status`, current branch, recent commits, and the relevant diff
- pull request status, checks, and review threads when a PR is in scope
- task or issue state when the work is tracked externally
- running commands, terminals, generated artifacts, or local files mentioned
  in the handoff

Reference existing artifacts in place. Do not paste large diffs, logs, plans,
or prior summaries into a new document merely to preserve them. Extract only
the decisions and state needed to resume, then link to the authoritative
artifact.

Do not mutate these systems during recall. The user asked for context, not for
the work to be advanced.

## Return a context capsule

Lead with the current state, followed by:

- the user's goal
- decisions already made and why
- completed work with evidence
- open work, blockers, and unresolved questions
- the exact artifact or command that should be examined next

Cite thread IDs, PRs, tasks, commits, and file paths. Separate confirmed live
state from statements found only in an older conversation.

Recommend a next skill only when it matches the recovered state: `how` for a
runtime model, `why` for rationale, `diagnosing-bugs` for an unresolved symptom,
`code-review` for an ordinary review, or `interrogate` for explicit adversarial
review.

## Completion criterion

Recall is complete when the user can resume from one verified context capsule:
the live state is reconciled with the handoff, authoritative artifacts are
linked rather than duplicated, and the next concrete action or decision is
clear. Do not advance that action during recall.
