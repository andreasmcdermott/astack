---
name: diagnosing-bugs
description: Diagnose a reproducible software symptom by building a fast evidence loop, minimizing the case, and testing ranked falsifiable hypotheses. Use when asked to debug, investigate, root-cause, or diagnose a bug, flaky test, performance regression, or unexplained runtime behavior. Diagnosing alone does not authorize changing the implementation.
---

# Diagnose bugs

Turn the reported symptom into a deterministic signal, then use that signal to
eliminate causes. The deliverable is a supported root cause or the narrowest
remaining uncertainty, not a tour of suspicious code.

## Establish the contract and scope

Restate the expected behavior, observed behavior, affected environment, and
smallest known trigger. Distinguish a diagnose-only request from a request to
fix the problem. Read-only investigation, temporary probes, and disposable test
scripts are allowed during diagnosis; changing product behavior is not unless
the user asked for a fix.

Capture existing state before running invasive experiments. Redact credentials,
tokens, personal data, and proprietary payloads from saved logs and reports.

## Build the evidence loop

Create the cheapest repeatable signal that exercises the exact symptom. It may
be a focused test, CLI command, HTTP request, browser interaction, trace,
profile, query, or small reproduction script. Record the command and outcome.

Reduce the case while preserving the failure. Separate deterministic failures
from timing-sensitive or environment-dependent ones. If reproduction is not
possible, identify the nearest observable boundary and collect evidence there
instead of pretending the symptom was confirmed.

## Test hypotheses

List a small set of ranked explanations. Each hypothesis must predict an
observable result that differs from the alternatives. Run one-variable probes
and update the ranking after every result. Prefer probes at boundaries where
state, ownership, serialization, time, concurrency, or external dependencies
change.

Do not patch several suspected causes at once. Do not treat correlation, a
nearby code change, or a disappearing failure as proof. When a dependency is
involved, verify behavior at the repository's pinned version.

## Conclude and clean up

Name the root cause, the evidence that distinguishes it, and the path from
trigger to symptom. If it remains unresolved, report the eliminated causes,
ranked remaining hypotheses, and the next discriminating probe. Remove
temporary probes and restore modified local state unless the user asked to keep
an artifact.

When a fix is in scope, make the smallest correction that addresses the proved
cause, rerun the original signal, and run the closest regression checks.

## Completion criterion

Diagnosis is complete when the original symptom has a repeatable signal and one
cause is distinguished by evidence, or when the remaining uncertainty is
narrowed to a specific boundary with a concrete next probe. A plausible theory
without a discriminating result is not complete.
