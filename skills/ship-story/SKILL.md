---
name: ship-story
description: >-
  Explicit-only workflow that takes a Shortcut Story from description to a
  review-ready pull request, with independent fresh-context review rounds
  before anyone else sees the PR. Use only when the user invokes /ship-story
  with a Story ID or URL. Do not select this skill for ordinary implementation,
  review, or PR requests; use tdd, code-review, interrogate, or pr-ready.
disable-model-invocation: true
user-invocable: true
---

# Ship a story

Deliver a PR that other reviewers' agents have little left to find. The implementer's own review is not enough, because it shares the implementer's assumptions. Fresh reviewers who see only the Story and the diff provide the check.

Invoking `/ship-story` authorizes, for this Story only: creating a branch, committing, pushing, opening a draft PR, starting read-only reviewer subagents or bb threads, and marking the PR ready once the gate passes. It does not authorize force-pushing, merging, commenting on the Story, or changing Story state.

## 1. Load the Story and check the premise

Fetch the raw Story and set up the branch as the Shortcut branch-name instructions in AGENTS.md describe. Save the Story's title, description, and acceptance criteria verbatim to `$TMPDIR/ship-story-<id>/story.md` so every reviewer receives identical intent.

Run [../premise-check/SKILL.md](../premise-check/SKILL.md) before writing code. If the premise is disputed, stop: report the evidence to the user and do not implement, push, or open a PR.

## 2. Implement

Implement with [../tdd/SKILL.md](../tdd/SKILL.md) for behavior changes, including its CI-only rules for the Shortcut backend. Then:

- run the repository's available static checks and `git diff --check`
- re-read the full diff against each acceptance criterion and fix gaps you find
- commit and push following [../pr-ready/SKILL.md](../pr-ready/SKILL.md) staging and description rules, but open the PR as a **draft** so CI runs before review is requested

Record the base and head SHAs.

## 3. Review in independent rounds

Each round starts new reviewers. Never reuse a reviewer from an earlier round, and never give reviewers your conversation, reasoning, handoff notes, or earlier findings. Independence is the point of this step.

Start three read-only reviewers in parallel, one per axis from [../code-review/references/review-axes.md](../code-review/references/review-axes.md):

1. premise validity plus specification and contract fidelity
2. runtime correctness and integration
3. tests and repository-specific defect risks

Run at least one reviewer on a different model family when the environment offers one. In bb, read the `bb-cli` skill and start it as a thread in the current environment. Otherwise use fresh subagents and note in the final report that the panel shared a model.

Give each reviewer this packet and nothing else:

```markdown
Review this change read-only. Do not edit files, commit, or post comments.

Intent: <path to story.md>. The Story may itself be wrong; if the code contradicts it, report that as a finding.
Diff: `git diff <base-sha>...<head-sha>` in <repo path>. Read surrounding code and consumers as needed.
Axis: <axis name>. Read <absolute path to review-axes.md> and go deep on that section. Report severe defects outside the axis too.

Report each finding with: severity (high/medium/low), file:line, concrete failure mode, the input or state that reaches it, why existing tests or guards miss it, and a fix direction. Omit style preferences and speculation without a reachable path. If nothing survives, say "No findings".
```

Also read any CI failures and bot review comments on the draft PR, and treat them as reviewer findings.

## 4. Judge and fix

Verify each finding against the code yourself. A finding is valid when its failure path is reachable; reviewer agreement only tells you where to look.

- **Valid:** fix it, with a regression test when the tdd seam allows. Rerun the affected checks.
- **Rejected:** record the specific code evidence (an invariant, a guard at file:line, a test) that prevents the failure. "Unlikely" or "out of scope" without evidence is not a rejection.
- **Out of the Story's scope but real:** do not fix it here. List it for the user.

If a finding you rejected in an earlier round comes back from a new reviewer, rejecting it again requires executable evidence: a test or a run that shows the failure cannot happen.

Push the fixes. The next round reviews the whole updated diff, because fixes can introduce new defects.

## 5. Gate

The gate passes when a round produces no valid high or medium finding, every valid low finding is fixed or listed, and CI on the head commit is green (wait with `gh pr checks <pr> --watch` or the equivalent).

Run at most three rounds. If valid high or medium findings remain after round three, or the same class of defect keeps returning, leave the PR as a draft and report to the user: the fix is likely a design problem, not a matter of more patching.

When the gate passes, rewrite the PR title and body from the final diff using pr-ready's description rules, then mark the PR ready (`gh pr ready <pr>`).

## Completion criterion

Done means: the premise line is recorded, the PR is ready for review, CI is green on the final head, and the last review round found no valid high or medium findings. Report to the user:

- PR URL and the premise line
- for each round: findings fixed and findings rejected, each with its evidence
- real issues outside the Story's scope
- reviewer model families used, and any check that did not run

A draft PR with a report of remaining findings is a correct stopping state. Marking a PR ready without passing the gate is not.
