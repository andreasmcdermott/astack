---
name: why
description: Investigate why code or a product decision has its current shape by combining code archaeology with available issue, PR, document, chat, observability, incident, and analytics evidence. Use for design rationale, regressions, postmortems, thresholds, and "why was this built this way". Use how for current runtime behavior and ordinary debugging for a present failure.
---

# Investigate why

Recover the forces that shaped a decision. The implementation shows what
shipped, but intent often lives in reviews, tasks, incidents, or operational
data.

Read [references/evidence-sources.md](references/evidence-sources.md) when more
than source control is relevant.

## Anchor the question

Identify the exact symbol, behavior, constant, feature, or decision in question.
Read enough current code to state what exists now and when it entered the
system. If the target is ambiguous, make the narrowest reasonable interpretation
and state it so the user can correct course.

## Search the available record

Source control is the baseline. Inspect blame, commits, PR descriptions, review
threads, linked issues, tests, and nearby comments. Search for the symbol, user-
facing term, task ID, PR URL, error text, and earlier names when needed.

Then choose other evidence sources based on the question and the tools actually
available. Do not pretend that an unavailable connector was searched. Do not
install a plugin, connect an account, or request broad new access merely to make
the investigation look complete.

Parallelize independent source searches when delegation is available and the
question warrants it. Give each investigator one evidence category and a
bounded query. Otherwise search sequentially. Keep all work read-only.

In bb, native app tools and project skills may expose Shortcut, GitHub, docs,
observability, or other sources. Prefer those over browser scraping. Use the
`bb-cli` skill when thread history itself is evidence.

## Calibrate conclusions

Distinguish:

- documented intent, stated directly in a source
- strong inference, supported by timing and several consistent facts
- plausible inference, consistent but not confirmed
- unknown, because the necessary record is missing or contradictory

Later documentation does not prove the original reason. A commit timestamp does
not prove causation. Repeated folklore does not outrank the review or incident
where the decision was made.

When sources disagree, report the disagreement and favor evidence closest to the
decision in time and responsibility. A null search is worth mentioning only
when the missing source would reasonably have contained the answer.

## Report

Answer the question first. Cite the strongest evidence with links, task or
thread IDs, commits, and file paths. Explain alternatives considered, constraints,
and later changes when the record supports them. State confidence plainly and
name meaningful evidence gaps.

If the user plans to change the code, finish with a short constraint set:

- preserve: behavior or invariants still justified by the evidence
- change: assumptions the current request intentionally replaces
- avoid: rejected approaches whose failure still applies
- risk: unresolved facts to verify before implementation
