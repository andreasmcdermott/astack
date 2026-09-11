---
name: interrogate
description: Run an adversarial, defect-first review of a code change using independent reviewers when available, then judge and deduplicate their findings. Use when the user asks to interrogate, stress-test, challenge, tear apart, or perform a multi-model review. Do not trigger for an ordinary implementation request.
---

# Interrogate a change

Try to break the change. The deliverable is a judged set of actionable defects,
not a pile of reviewer prose.

Read [references/review-rubric.md](references/review-rubric.md) before launching
reviewers.

## Establish the review target

Resolve the exact diff, commit, branch, or PR. Read the user request, linked
task, PR description, and nearby tests to state the intended behavior in a few
sentences. Reviewers need the intent because code can be internally consistent
and still solve the wrong problem.

Treat the intent as a claim to test, not a fixed point. Before launching
reviewers, check the premise yourself using the first axis of the rubric: does
the described current behavior exist, and does the requested change reach the
stated goal? If the code disproves the requirement, that is the lead finding
regardless of what the panel reports about the implementation.

Preserve the user's review boundary. If they asked to ignore stylistic nits,
exclude them. Do not post comments, approve a PR, or change code unless the user
also asked for that action.

## Get independent reviews

Use independent reviewers when the environment supports delegation. Two or
three reviewers are usually enough. Add another only for a genuinely distinct
model family or specialized code path.

- Give every reviewer the same target and intent statement, but assign a
  distinct review axis from the rubric: premise validity, specification
  fidelity, runtime and integration correctness, or repository-specific defect
  risks. Tell every reviewer that the intent statement may be wrong and that a
  contradiction between the requirement and the code should be reported.
- Ask for read-only review. Reviewers report findings and do not edit files.
- Prefer different model families when the harness supports model choice.
- In bb, read the `bb-cli` skill before creating cross-provider threads. Reuse
  the current environment so every reviewer sees the same files. Use available
  providers rather than hardcoded model names.
- If delegation is unavailable or would cost more than the review warrants,
  perform one rigorous review and disclose that there was no independent panel.

Do not assign personas that manufacture disagreement. The axes should divide
real verification work, while independent models or contexts reduce correlated
blind spots.

## Judge the findings

Read the code and verify each candidate yourself. A reviewer vote is evidence
about where to look, not evidence that a bug exists.

Reject findings that are speculative, outside the diff's responsibility,
already prevented by a proven invariant, or purely stylistic. Merge duplicate
findings. Agreement raises confidence, but a lone finding with direct evidence
can still be the most important one.

For every accepted finding, require:

- the concrete failure mode
- the affected file and line or symbol
- the input or state that reaches the failure
- why existing tests or guards do not prevent it
- the smallest useful correction or verification

## Report

List findings in severity order. Keep the list empty when no actionable defect
survives judgment. After the findings, state the premise result in one line
(verified, assumed, or disputed, with what was checked), then briefly name what
reviewers examined, where they agreed or disagreed, and any review gap caused
by unavailable tools or incomplete access.
