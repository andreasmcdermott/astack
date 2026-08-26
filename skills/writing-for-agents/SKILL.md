---
name: writing-for-agents
description: Write or refine concise agent-facing instructions such as SKILL.md, AGENTS.md, CLAUDE.md, workflow guides, and linked references. Use when asked to improve agent instructions, triggering, progressive disclosure, completion criteria, or source-of-truth guidance. Use the platform's skill-creator as well when creating a full skill package.
---

# Write for agents

Make the desired behavior easy to select, execute, and verify. Agent-facing
prose is routing and control logic, not documentation for its own sake.

## Design invocation deliberately

Decide whether the instruction should trigger implicitly from natural language,
only through explicit invocation, or both. Put trigger wording in the field the
platform actually uses for selection, usually the skill description. Front-load
distinctive phrases and scope boundaries. Do not rely on body text to fix a
description that never routes the agent into the skill.

For a skill package, follow the available `skill-creator` guidance for required
metadata, layout, validation, and platform conventions. This skill focuses on
the instruction content.

## Point to context

Tell the agent exactly when to read each linked reference. A file that is merely
listed may never be opened. Keep the entrypoint sufficient for the common path,
then use progressive disclosure for detailed rubrics, examples, variants, and
tool-specific material.

Treat repository files, environment configuration, and authoritative tools as
sources of truth. Point to them instead of copying values likely to become
stale. State what to do when a source is missing or contradictory.

## Write operational instructions

Front-load branches that change the workflow, such as read-only versus mutating
requests, explicit versus automatic invocation, or available versus unavailable
delegation. Prefer positive target behavior with a reason or boundary. Use
prohibitions for genuinely unsafe or easy-to-confuse actions, not as the main
structure.

Remove duplicated rules, no-op reminders, stale paths, hardcoded model names,
and platform syntax that is not essential. Keep examples only when they resolve
an ambiguity better than a rule.

End workflows with checkable, exhaustive completion criteria. The agent should
be able to distinguish done, partially done, and blocked from observable state.

## Validate

Check metadata and naming with the platform validator when available. Test
several prompts that should trigger, should not trigger, and should route to a
neighboring skill. Inspect whether linked references are actually reached and
whether the completion criterion changes behavior. Revise the wording based on
observed failures rather than adding generic emphasis.

## Completion criterion

The instruction is complete when its invocation policy is explicit, common work
fits in the entrypoint, optional detail is reached through clear context
pointers, authoritative state is not duplicated, and completion can be checked
from observable evidence.
