# Evidence source guide

Choose sources that can realistically answer the question. Search them with the
terms people used at the time, including old feature names and linked IDs.

## Source control

Use blame to find the introducing commit, then read the whole commit and its PR.
Search review threads, test names, deleted code, and adjacent commits. Source
control is strongest for implementation-time constraints and alternatives that
reviewers discussed.

## Issue tracker

Search the current task, parent work, dependencies, labels, attachments, and
comments. Issue trackers are strongest for product requirements, scope changes,
customer requests, and deadlines. Do not infer design rationale merely from a
story title.

## Long-form documents

Search RFCs, PRDs, ADRs, postmortems, and meeting notes. These can state
alternatives and tradeoffs clearly, but compare their dates with the code. A
document written later may explain current policy rather than the original
decision.

## Team chat

Search symbols, feature names, PR URLs, task IDs, error strings, and contributor
names near the ship date. Chat is useful for real-time deliberation that never
reached a formal document. Treat isolated messages as context, not settled
policy.

## Observability and incidents

Use traces, metrics, logs, monitors, error reports, and incident timelines when
the code responds to runtime behavior. Match timestamps, releases, stack traces,
and threshold values. Correlation narrows the explanation but does not by itself
prove why a line was written.

## Product analytics

Use experiments, flag exposure, event volume, distributions, and rollout data
for product thresholds, migrations, and adoption decisions. Record the query or
dashboard and time range so the result can be checked.

## Evidence returned by another agent

Require direct citations and the query or search scope. Verify decisive claims
against the source before using them in the final explanation. An agent summary
without a traceable source is a lead.
