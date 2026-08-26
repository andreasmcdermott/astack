# Test quality

## Stable tests

- Exercise the smallest public interface that expresses the behavior.
- Assert caller-visible results, state, or side effects.
- Compute expected values independently. Do not copy the implementation's
  algorithm into the test.
- Cover one vertical behavior slice per cycle. Add boundaries only when they
  express a distinct contract.
- Prefer tests that survive internal refactors without edits.

## Mocking

Use a real dependency when it is fast, deterministic, and locally controllable.
Use a fake or mock at a true system boundary when the dependency is slow,
non-deterministic, costly, destructive, or unavailable in tests.

Mock contracts, not internal collaborators. Avoid tests whose primary assertion
is that private methods were called in a particular order. When a mock is
necessary, keep its behavior smaller than the production dependency and verify
that the assumed contract is accurate.
