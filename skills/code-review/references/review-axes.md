# Review axes

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
