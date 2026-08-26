---
name: how
description: Explain how a codebase, subsystem, feature, or runtime path works, including ownership, data flow, state changes, and failure behavior. Use for code walkthroughs and questions such as "how does X work", "where should this live", or "which layer owns this". Use why for historical motivation and tradeoffs.
---

# Explain how it works

Build a working mental model from the code. Do not narrate files in discovery
order.

## Choose the depth

- For one function or a narrow path, investigate directly.
- For a subsystem spanning several components, split the investigation by real
  boundaries such as entry points, state ownership, persistence, and external
  effects. Delegate independent slices when that materially reduces time.
- For an architectural critique, explain the current system first. Critique
  only after the reader can see why the current boundaries matter.

If the environment supports subagents, give each one a bounded question and ask
for cited findings. In bb, use the current environment for delegated work. Do
not hardcode a provider or model. Keep raw exploration outside the main context
when it is large.

## Trace the system

Anchor every explanation in concrete code and cover the parts that answer the
question:

1. the entry point and caller
2. the important data shape and where it is constructed
3. ownership of mutable state
4. the call or event sequence
5. persistence, network, queue, or UI boundaries
6. errors, retries, cancellation, and cleanup
7. the observable result

Follow at least one representative path end to end. Cite file paths and symbols.
Use runtime evidence when static reading leaves an important ambiguity.

For placement questions, compare the proposed owner with existing dependency
direction and data ownership. "This file is nearby" is not an architectural
reason.

Prefer interfaces that hide a meaningful implementation choice and expose a
small, stable contract. When explaining a module boundary, say what complexity
the boundary contains, which assumptions cross it, and whether callers must
understand the internals to use it correctly. A large file is not necessarily a
deep module, and a small file is not necessarily a useful abstraction.

## Explain the model

Lead with the smallest useful summary. Then build the picture in layers:

- the components and their responsibilities
- the main sequence through them
- the state and invariants that make the sequence work
- important failure or edge paths

Use a compact diagram only when three or more components interact and prose
would obscure the sequence or ownership. End with the code locations a reader
should inspect next. Separate observed behavior from interpretation.

If the user asks why the system has this shape, invoke `why` for that part rather
than guessing from the implementation.

## Completion criterion

The explanation is complete when the reader can identify the owner, trace one
representative path from entry to observable result, describe the key state or
invariant, and predict the important failure behavior without reopening every
file inspected during discovery.
