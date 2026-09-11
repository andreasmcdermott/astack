# Review axes

## Premise validity

Check the requirement against the code before checking the code against the
requirement. Full checklist and worked examples in
[../../premise-check/SKILL.md](../../premise-check/SKILL.md).

- Verify each claim the story, task, or PR description makes about current
  behavior. Find the code path or reproduce the bug. If the described behavior
  does not exist, say so.
- Confirm that named files, functions, fields, flags, and versions exist and
  behave as the requirement assumes.
- Trace the requested change to the stated goal. A change can match the
  request and still not fix the cited problem.
- When the change adds a guard, fallback, retry, or default, look one level
  upstream for the real cause. A guard that hides an upstream bug is a defect.
- Check whether the change contradicts a test, invariant, contract, or ADR
  that records a deliberate decision. A test deleted to satisfy the story is
  a finding.
- A diff that faithfully implements a requirement the code disproves is the
  highest-severity finding in the review. Report it first and state the
  contradicting evidence, not just the disagreement.

## Specification and contract fidelity

- Compare behavior with the user request, task, PR description, tests, and
  public contracts.
- Check missing requirements, unintended scope changes, compatibility, and
  behavior outside the happy path.
- Follow changed types, serialized shapes, persistence, and API contracts to
  every relevant consumer.

## Runtime correctness and integration

- Trace state transitions, partial failures, retries, cancellation, cleanup,
  ordering, concurrency, and stale state where relevant.
- Check empty inputs, boundaries, time, ownership, authorization, tenancy, and
  lifecycle behavior.
- Verify side effects, events, caches, queues, flags, scheduled work, and UI
  updates agree with committed state.
- Ask whether tests would fail for a subtly wrong implementation, not merely
  whether they execute the new lines.

## Repository-specific defect risks

- Read applicable contributor instructions and nearby established patterns.
- Report a convention violation only when it creates incorrect behavior,
  incompatible architecture, an unsafe migration, or a likely maintenance
  failure.
- Do not report formatting, naming, comment, or preference nits that automated
  checks handle or that have no substantive consequence.
