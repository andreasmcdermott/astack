---
name: blast-radius
description: Determine what a proposed or completed code change could break outside its immediate diff, and prove the key safety assumption with executable evidence. Use for "blast radius", "what could this break", risky migrations, or a small-looking change the user does not trust. Do not use as a generic code review.
---

# Blast radius

Find the hidden contract a change depends on, then test that contract. A long
list of hypothetical risks is less useful than one proved safety fact.

## Trace beyond the diff

Read the change, its stated intent, and the symbols it adds, changes, or removes.
Follow direct callers, then look where symbol search stops:

- serialized data, API responses, database columns, and wire formats
- code in another language or service that reads the same state
- dependency behavior at the pinned version
- queues, caches, scheduled work, cleanup, retries, and lifecycle events
- flags, configuration, observability, and downstream user-visible behavior

Use the `why` skill when historical rationale or rejected alternatives affect
the contract. Use `interrogate` only when the change is broad or the user asks
for independent adversarial review.

## Find the safety hinge

State the one or two facts on which the change's safety depends. Examples are
"the cleanup call only removes already-dead entries" or "all readers ignore the
new optional field." Do not bury these facts in a risk catalog.

Push each fact as far down this evidence ladder as practical:

1. a claim
2. a cited implementation line or authoritative dependency source
3. a traced argument showing the bad case cannot reach the code
4. a script or test that runs the real code
5. a reproduction in the running product

Do not call a fact proved below level 4. If direct execution is too expensive or
unavailable, mark it unproven and say what would prove it.

## Report

Lead with what changed and the safety hinge. Show the executable proof and its
result. Then list confirmed risks, cleared risks, and the cheapest remaining
pre-merge check. Give each risk a concrete failure mode, evidence location,
likelihood, and impact. Omit speculative possibilities that survived no contact
with the code.
