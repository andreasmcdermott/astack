---
name: premise-check
description: Verify that a story, ticket, PR description, or stated requirement is actually true and actually solves its stated problem before implementing or approving it. Use whenever work starts from a written requirement authored by someone else, especially Shortcut Stories, PR descriptions, and delegated assignments. Other skills link here; it also stands alone.
---

# Check the premise before the implementation

A requirement is a claim about the code plus a request to change it. Agents
reliably check whether the change matches the request. They rarely check
whether the request matches the code. A faithful implementation of a wrong
requirement ships a defect with a green checkmark on it.

The default harness behavior is to note a concern and keep building. For work
that starts from a story or ticket, that default is wrong. When the evidence in
the repository contradicts the requirement, stop and report. A paused story
costs an hour. A shipped workaround costs a rollback and hides the real bug.

## What to verify

Run this before writing code, and again before approving a change that claims
to satisfy a requirement. Each item is a lookup in the repository, not an
opinion.

1. **Claims about current behavior.** The story says "X happens when Y" or "the
   function does Z". Find the code and confirm it. If the story describes a bug,
   reproduce it or trace the path that produces it. If you cannot find the
   behavior described, that is a finding, not a detail to skip.
2. **Named things exist and match.** Files, functions, fields, flags, endpoints,
   and versions named in the story exist and behave as the story assumes.
   Stories written from memory or from an older branch are often stale.
3. **The requested change produces the stated goal.** Trace the change through
   to the outcome the story wants. A story can ask for a change that is
   harmless but does not fix the problem it cites.
4. **Cause versus symptom.** If the story prescribes a guard, fallback, retry,
   or default, ask why the bad value reaches that point. Look one level
   upstream. A guard that hides an upstream bug is worse than the crash.
5. **Conflicts with prior decisions.** Check nearby tests, invariants,
   contracts, ADRs, and contributor instructions. A story author may not know
   that the current behavior is deliberate. A test that must be deleted to
   satisfy a story is a signal, not an obstacle.
6. **Collateral effect.** Follow the change to other consumers. A requirement
   scoped to one caller can break another that relies on the current behavior.

## Decide

Apply the threshold strictly. The trigger is repository evidence that
contradicts the story, not a preference for a different design. Do not turn
this into blanket skepticism; that makes agents slow and annoying and trains
people to ignore the flag.

| Result | Action |
| --- | --- |
| Premise verified | Proceed. Record one line naming what you checked. |
| Premise unverifiable from the repo | Proceed. State the assumption you are working under in the handoff or PR. |
| Premise false, or the change makes something else worse | Stop. Do not implement a workaround. Report the evidence and the likely correct change. |

"Stop" means do not write the requested code and do not mark the work done.
Reporting the problem is the deliverable. Include:

- the specific claim in the story that is wrong
- the file and line or command output that contradicts it
- what you believe the real problem or correct change is, if you can tell
- what you did not change

Route the report through whatever channel the workflow provides: a comment on
the story plus release, an escalation to the lead, or a review finding. Never
route it only into chat that nobody reads.

## Record the result

Whatever the outcome, the completion report, PR description, review, or
handoff must include a premise line. Reviewers and orchestrators should reject
work that omits it.

```
Premise: verified — reproduced the stale read with `npm test -- cache`; TTL is 0 in config/defaults.ts:41
Premise: assumed — could not reach the staging DB; assumed the migration ran as the story states
Premise: disputed — story says tenant_id is nullable; schema.prisma:88 marks it required and no insert path omits it
```

## Worked examples

**Symptom prescribed as a fix.** Story: "Add a null check in `formatInvoice`
because it crashes when `customer` is null." Check: `customer` is populated by
`loadInvoice`, which validates it, except in the bulk export path added last
month that skips validation. The null check would hide that path's bug and
produce blank invoices instead of a crash. Correct action: dispute, point at
the bulk export path, propose fixing validation there.

**Stale premise.** Story: "Raise the upload limit in `config/upload.ts` from
10MB to 50MB." Check: that file was replaced two months ago; the limit now lives
in the gateway config and is already 50MB. The actual failure users hit is a
25MB limit in the CDN. Correct action: dispute, name the real limit location,
ask whether the CDN is in scope.

**Change does not reach the goal.** Story: "Users see duplicate notifications.
Deduplicate by notification ID in the client." Check: the client already dedupes
by ID. The duplicates have different IDs because the server enqueues twice on
retry. Correct action: dispute, point at the enqueue path, propose an
idempotency key on the server.

**Contradicts a prior decision.** Story: "Make `deleteAccount` hard-delete the
row." Check: an ADR and a test both require soft delete for a 30-day recovery
window and for audit. Correct action: dispute, cite the ADR and test, ask
whether the policy changed.

**Verified premise, proceed.** Story: "Cache lookups return stale values after a
write because the TTL is 0." Check: TTL default is 0 in config, and the test
reproduces the stale read. Correct action: implement, and write
`Premise: verified` with the line reference.

## For reviewers

Read the story or PR description first and form your own view of what the
correct fix is before reading the diff. Then compare. If the diff faithfully
implements a requirement that the code disproves, report that as the top
finding. It outranks every runtime or style finding, because fixing the
implementation would only make the wrong change more robust.
