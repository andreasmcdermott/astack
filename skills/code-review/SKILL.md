---
name: code-review
description: Review a code change for substantive, actionable defects against its intended contract and repository context. Use for ordinary code review, PR review, diff review, or requests to find bugs before merge. Use interrogate only when the user asks for adversarial, stress-test, or multi-model review.
---

# Review a code change

Find defects the author would fix before merge. Do not inflate the result with
style preferences, broad cleanup suggestions, or speculative risks.

Read [references/review-axes.md](references/review-axes.md) before reviewing.

## Establish the target

Resolve the exact diff and its fixed point. Prefer the PR base, named base
branch, or merge-base implied by the current branch. Use the obvious choice
without blocking the user, and state it when ambiguity could affect findings.

Read the request, task, PR description, tests, and nearby contracts. Summarize
the intended behavior before judging the implementation. Preserve explicit
review boundaries such as ignoring style or limiting the review to a subsystem.

Do not modify code, post comments, approve a PR, or change external state unless
the user requested that action.

## Review by independent axes

Inspect the change through three separate lenses:

1. specification and contract fidelity
2. runtime correctness and integration
3. repository standards only where violating them creates a substantive defect

Delegate axes only when the environment supports it and the review warrants the
cost. Give each reviewer the same target and intent but one distinct axis. When
delegation is unavailable, run the axes sequentially yourself. Reserve
`interrogate` for an explicitly adversarial or multi-model review.

Trace changed values and state through consumers beyond the edited files. Check
the repository's pinned dependency behavior rather than relying on memory.

## Judge findings

Verify every candidate against the code. A valid finding needs:

- a concrete failure mode
- the affected file and line or symbol
- the input or state that reaches it
- why current guards or tests do not prevent it
- a useful correction or verification direction

Reject findings outside the change's responsibility, prevented by an
established invariant, or based only on taste. Merge duplicates and rank the
survivors by severity.

## Report

Lead with findings in severity order. If none survive verification, say so.
Then state the review target, checks performed, and any material gap caused by
missing access or unavailable execution. Keep summaries brief so they do not
hide findings.

## Completion criterion

The review is complete when all three axes have been examined, every reported
finding has a reachable failure path and precise location, duplicates and nits
have been removed, and important unreviewed surfaces are disclosed.
