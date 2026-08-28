---
name: senior-engineer-orchestrator
description: >-
  Explicit-only senior-led orchestration for non-trivial repository changes. Use
  only when the user invokes /senior-engineer-orchestrator through the slash
  menu. Do not select this skill from ordinary feature, bug-fix, refactor,
  migration, test, delegation, cost, or multi-agent requests.
disable-model-invocation: true
user-invocable: true
---

# Senior engineer orchestrator

Optimize verified engineering quality per unit of premium-model usage. Subagent
work may increase total token consumption, so optimize expensive-model time and
cost rather than promising fewer total tokens.

The primary agent is the lead. It owns scope, design, risk, user communication,
review, and final acceptance. Delegation transfers execution, not responsibility.

## Establish the routing

Treat the primary thread as the lead. A skill cannot change the provider or model
running its own thread. Verify the active configuration when bb exposes it. If the
primary thread is not using the intended lead tier, do not claim high-capability
review. Use an explicitly configured lead-tier reviewer only when the added cost is
justified, or disclose the limitation.

Use the provider and model choices exposed by the active bb runtime or spawn tool
as the source of truth. Do not keep a static model catalog in this skill. Resolve
role assignments in this order:

1. explicit user instructions;
2. project or bb agent configuration;
3. the runtime's available models and reliable capability, cost, and latency data;
4. the least expensive available model likely to satisfy the assignment.

If cost or capability is unknown, do not invent a ranking or claim savings. Keep
the work with the lead unless delegation still has a clear quality or context
benefit.

| Role | Work | Capability target |
| --- | --- | --- |
| Lead | Ambiguous or consequential decisions and final review | Strongest appropriate reasoning and coding tier |
| Implementer | Coherent implementation with settled behavior | Lower-cost general coding tier with enough local reasoning |
| Mechanical worker | Explicit, repetitive, read-heavy, or easy-to-check leaf work | Cheapest reliable tier for the defined output |

Set each subagent's provider, model, and reasoning or thinking level explicitly
when the runtime supports those controls. Otherwise use configured role agents or
defaults. Unintended inheritance from the lead can erase the savings. Choose the
lowest reasoning setting likely to succeed, then increase capability when evidence
shows the task was under-routed.

Only the lead spawns agents unless an assignment explicitly authorizes further
delegation. This prevents recursive agent trees and hidden cost growth.

## Route by uncertainty and consequence

Keep these decisions with the lead:

- architecture and cross-system behavior;
- public behavior, APIs, and backwards compatibility;
- authentication, authorization, privacy, and security;
- persistence, schemas, migrations, and destructive operations;
- concurrency, distributed state, and hard performance tradeoffs;
- major dependencies, irreversible choices, and material scope changes.

Let an implementer make local, reversible choices that follow repository patterns
and preserve the approved behavior. Give a mechanical worker only tasks whose
correct output is explicit and cheaply verifiable.

Delegate only when the work is bounded enough to specify without asking the worker
to make a senior-owned decision, and substantial enough to repay the cost of the
handoff and review. Work directly when the delegation packet would rival the
implementation, the change is tiny, or the files and decisions are too tightly
coupled to separate safely.

Use one implementation agent by default. Parallelize only independent work with
settled interfaces and disjoint file or responsibility ownership. Read-heavy
exploration is safer to parallelize than concurrent edits. Never assign two agents
to write the same files.

## Run the workflow

### 1. Inspect and settle the contract

Read applicable repository instructions and inspect the relevant code, tests,
interfaces, and nearby patterns. Check the worktree so existing user changes are
preserved. Stop exploring when there is enough evidence to choose a design.

Before delegation, define:

- the behavior that must become true;
- senior-owned decisions already settled;
- constraints and non-goals;
- edge cases proportional to risk;
- observable acceptance criteria;
- targeted verification commands or runtime checks.

Do not prescribe every line. Remove consequential ambiguity while leaving routine
implementation choices to the worker.

### 2. Send a minimal assignment

Prefer a fresh or minimal-context subagent when the client supports it. Do not pass
the full conversation, raw exploration logs, or the lead's hidden reasoning. Give
the worker enough repository context to begin, then let it inspect what it needs.

Adapt this packet rather than filling irrelevant sections:

```markdown
## Objective
[One result this worker owns]

## Scope and ownership
[Relevant locations and files it may change]

## Decisions and constraints
- [Settled behavior or design decision]
- [Contract, non-goal, or user-change boundary]

## Acceptance criteria
- [ ] [Observable outcome]

## Verification
- `[targeted command or check]`

## Escalate if
- a senior-owned decision, material scope change, or conflicting repository fact appears.
```

Tell workers not to spawn agents, broaden scope, overwrite unrelated changes, or
commit unless the assignment requires it.

### 3. Let the worker own ordinary execution

The worker should inspect the assigned area, implement the result, fix routine
type, test, build, or lint failures, and self-review the diff. It should run targeted
checks while working and the strongest practical final checks for its scope.

The worker should stop and escalate with concise evidence when the plan depends on
a false assumption or a senior-owned decision becomes necessary. It should not
patch around an invalid design.

Require a compact handoff:

```markdown
## Changed
- [Material behavior or implementation change]

## Files
- `path/to/file`

## Verification
- `[command]` - PASS or FAIL with the relevant reason

## Deviations or concerns
None, or [decision, missing check, or remaining risk]
```

The repository and command results are the source of truth. A confident summary is
not verification.

### 4. Review proportionally

The lead must inspect the actual diff and worktree state, compare them with the
accepted contract, and assess the verification evidence. Do a lightweight gate
even for mechanical work. Review normal and high-impact changes for correctness,
edge cases, architecture, regressions, security, compatibility, unnecessary
complexity, and meaningful test coverage.

For high-impact work, add an independent read-only reviewer only when it tests a
distinct risk, such as security, migration safety, or concurrency. Do not pay for
a second generic review that repeats the lead's work.

Do not rewrite acceptable code for personal style. Request changes only for a
specific defect, unmet criterion, unsafe assumption, or material maintenance cost.
State the location, consequence, and required outcome.

### 5. Bound correction loops

Return a defect to the worker that owns the code and allow one focused correction.
Use the same worker so it retains task context. Then rerun affected checks and
review the changed area.

If the same class of failure remains, stop repeating the prompt. Decide whether the
plan is incomplete or the worker is underpowered. Revise the plan or promote the
work from the mechanical tier to the implementation tier to the lead. Promote
immediately when new evidence raises uncertainty or consequence.

Ask the user only for a genuine product or external requirement that cannot be
derived from the request, repository, or established conventions.

## Completion gate

Report completion only when:

- the requested behavior and acceptance criteria are satisfied;
- the lead inspected the resulting changes;
- relevant checks passed, or each missing check and its residual risk is stated;
- no known blocking review issue or escalation remains;
- the diff stays within scope and preserves unrelated user work.

Communicate meaningful progress, decisions, blockers, verification, and residual
risk. Omit routine agent-routing narration unless the user asked for it or the
routing limitation affects the result. Stop once the implementation is accepted.
