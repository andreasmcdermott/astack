---
name: tdd
description: Implement a behavior change with a focused red-green-refactor loop and tests through stable public interfaces. Use when the user asks for TDD, test-first development, a regression test before a fix, or explicitly requests red-green-refactor evidence. Do not force TDD onto ordinary implementation requests.
---

# Test-driven development

Use a failing behavioral test to define the next small slice, then write only
enough implementation to make it pass.

Read [references/test-quality.md](references/test-quality.md) when choosing the
test seam or deciding whether mocks are justified.

## Choose one vertical slice

State the behavior in terms of inputs, observable outputs, state changes, or
side effects through the narrowest stable public interface. Follow repository
test conventions unless they obscure the behavior being specified.

Prefer a seam that is cheap, deterministic, and close to what a caller or user
observes. If the only available regression seam would be expensive, brittle, or
misleading, explain that constraint and use the closest executable check rather
than manufacturing a low-value test.

## Red

Write one focused test for the missing behavior. Derive expected values
independently from the implementation. Run it and confirm it fails for the
intended reason, not from setup, syntax, or unrelated breakage. Record the
failing command and meaningful result.

If the test unexpectedly passes, determine whether the behavior already exists
or the assertion misses it before changing production code.

## Green

Make the smallest coherent production change that satisfies the behavioral
contract. Avoid adding speculative abstractions or unrelated cleanup. Run the
focused test until it passes, then run the closest relevant suite.

## Refactor

Improve names, duplication, and boundaries only while the tests stay green.
Do not couple assertions to the refactored implementation. Repeat with the next
vertical slice if more behavior remains.

## Completion criterion

The cycle is complete when the new test was observed failing for the intended
reason, the minimal implementation makes it pass, relevant regression checks
pass, and the test asserts stable behavior rather than implementation details.
Report both failing-before and passing-after evidence, or clearly explain why a
different executable check was necessary.
