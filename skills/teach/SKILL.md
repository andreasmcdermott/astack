---
name: teach
description: Teach a code change, subsystem, or technical decision so the user can reason about it independently. Use when the user says "teach me", "help me understand", or asks for an explanation that combines how something works with why it was designed that way. Do not use when a short factual answer is enough.
---

# Teach the system

Help the user build a reusable mental model. A summary tells them the answer;
teaching should let them predict what happens in a new case.

## Build the source material

Use `how` to establish current behavior and ownership. Use `why` when history,
constraints, or rejected alternatives matter. Run the investigations in parallel
only when they are independent and substantial. For a narrow question, one may
be enough.

Do not redo those investigations from memory. Preserve `why`'s confidence
language and evidence gaps.

## Teach in layers

Start with the problem the system solves and one plain mental model. Then add:

1. the main components and who owns what
2. one representative request, event, or state transition
3. the invariant that keeps it correct
4. one failure or edge case that tests the model
5. the historical constraint or tradeoff, when relevant

Use the user's vocabulary and apparent depth. Define unavoidable domain terms
once. Prefer a small concrete example over a catalog of abstractions.

Use diagrams only when they reduce reader effort. For a complex sequence, build
two or three small diagrams that add one idea at a time instead of presenting a
single dense picture.

## Check understanding

End with a short prediction question or thought experiment when it helps. For
example, ask what the model predicts if a retry happens after the write but
before the event is emitted. Do not turn a straightforward explanation into a
quiz.

Point to the few source files, commits, tasks, or documents that best reinforce
the model. Keep uncertain rationale marked as uncertain.
