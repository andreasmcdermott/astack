# Adversarial review rubric

Review the change against its stated intent. Report only defects that the author
would probably fix before merge.

Use these as distinct reviewer axes when a panel is available. Each reviewer
should go deep on one axis while remaining free to report a severe defect found
outside it.

## Runtime correctness

- Trace state transitions and error paths, including partial failure and retry.
- Check boundary values, empty inputs, ordering, time, concurrency, and stale
  state where the changed code makes them relevant.
- Compare writes, side effects, and emitted events with the state that actually
  committed.
- Check that new branches preserve existing behavior outside the requested
  change.

## Specification, contracts, and integration

- Follow changed types and wire shapes through every consumer, including other
  languages or persisted data when applicable.
- Check authorization, tenancy, ownership, and lifecycle rules at system
  boundaries.
- Look beyond direct callers for scheduled work, cleanup, caches, queues,
  telemetry, and feature flags.
- Verify assumptions against the pinned dependency version rather than memory.

## Tests

- Ask whether the tests would fail if the implementation were subtly wrong.
- Flag tests that assert mocks or implementation details while missing the
  user-visible contract.
- Do not demand a new test when the repository has no practical test path. Ask
  for the closest executable verification instead.

## Repository-specific defect risks

- Read applicable repository instructions and established patterns near the
  change.
- Report a deviation only when it creates incorrect behavior, incompatible
  architecture, an unsafe migration, or a likely maintenance failure.
- Exclude formatting, naming, and preference nits without a substantive effect.

## Finding standard

A finding needs a reproducible path from input or state to an incorrect result.
Name the exact code involved. Avoid vague risk, preferences, cleanup ideas, and
style commentary unless style creates a real correctness or maintenance defect.
