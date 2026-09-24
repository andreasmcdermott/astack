---
name: pr-description
description: Write a succinct pull request description for the existing PR tied to the current bb thread's branch. Use when the user invokes /pr-description or asks for a PR description, pull request summary, or concise explanation of the current branch's code changes and purpose.
---

# PR description

Write a brief, paste-ready description for the pull request associated with the
current bb thread and its current branch. Describe only the code changes and
their purpose.

## Find the current PR

Start with `bb thread show --self --json` to identify the current environment,
then use `bb environment pull-request show <environment-id> --json`. The PR must
be tied to that environment's current branch; do not choose a PR merely because
it has a similar title or story reference.

If bb cannot resolve it, run `gh pr view --json
number,title,body,baseRefName,headRefName,url` from the current workspace. If
there is still no PR for the checked-out branch, say so concisely instead of
guessing or describing a different PR.

## Understand the change

Use the PR's actual base branch and inspect the branch diff, including its stat
and the relevant changed code. Prefer `git diff <base>...HEAD`; use `gh pr diff`
when the base ref is unavailable locally. Treat commit messages and the existing
PR body as secondary context because they may be incomplete or stale.

Infer the purpose from the resulting behavior, tests, code structure, and the
current conversation. Keep every claim grounded in the code change. If the
purpose is genuinely ambiguous, describe the observable change without
inventing motivation.

## Writing priorities

Prioritize brevity and high-level meaning:

- Keep the body under 100 words. Most changes need 30 to 60.
- Lead with one or two sentences explaining what changes and why it matters.
- Add bullets when they carry facts those sentences do not, such as a second
  area touched for a different reason. If a bullet restates, elaborates on, or
  justifies the paragraph, delete it rather than rewording it.
- Describe outcomes and intent rather than narrating files, commits, or small
  implementation details.
- Use direct, neutral language. Remove filler such as "This PR," "in order to,"
  and process commentary.

Do not mention Shortcut, related Shortcut stories, story IDs, story titles,
story links, ticket metadata, or branch-name tracking references—even when they
appear in the PR title, branch name, commits, existing description, or chat.
Do not include a "Related stories" section.

Do not claim tests were run unless the available evidence shows they were. A
testing section is normally unnecessary for this brief description; include one
only when the user asks for it.

## Output

Return only the paste-ready Markdown description, without analysis, a proposed
title, PR metadata, or a preamble. Use a single compact paragraph when the
opening sentences say everything. Add bullets when there are separate facts left
to state:

```markdown
## Summary

[One or two sentences describing the change and its purpose.]

- [A change the summary sentences do not already state]
- [A change the summary sentences do not already state]
```

The size of the diff is not itself a reason to add bullets.

## Cut before you post

The reader is a reviewer who is about to read the diff. The body orients them.
It is not a record of the work you did. Anything they will learn from the diff,
the tests, or CI does not belong in it.

Leave out:

- Test counts, test names, coverage claims, lint and typecheck results, and
  which suites did or did not run.
- Implementation rationale, parity arguments, inventories of side effects, and
  justifications for choices the diff already shows.
- Merge order, dependencies, follow-up work, and story or ticket references.

Do not label sections of the body. Bold lead-ins such as "Parity contract.",
"Validation.", or "Merge order." turn a description into a report. A PR body has
no sections.

If one of these is genuinely load-bearing for the reviewer, it belongs as one
clause in the opening sentences, not as its own labeled part.

Keep a harness-required attribution footer if one applies. It does not count
toward the length.

Then count the words. If the body is over 100, delete sentences until it is not.
Cutting means removing whole sentences, not compressing them into denser ones. A
long or intricate diff is a reason for a shorter description, not a longer one,
because no summary of it will be accurate enough to trust.

Drafting is read-only. Do not update the remote PR unless the user explicitly
asks to apply or publish the description. If they do, show the final text before
performing the external write unless they have already approved that exact
text.
