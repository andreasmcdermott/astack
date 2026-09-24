---
name: pr-ready
description: Commit the current branch's intended changes, push the branch, and open a new pull request with a concise title and body. Use when the user invokes /pr-ready or explicitly asks to finish the current work by committing it, pushing it, and creating a PR. Do not use for updating an existing PR, drafting a description only, or merging a PR.
---

# PR ready

Turn the current branch into one new, non-draft pull request. The invocation
authorizes the commit, push, and PR creation described here. It does not
authorize force-pushing, rewriting history, merging, or including unrelated
workspace changes.

## Clarify only material ambiguity

Use the conversation, repository state, branch diff, and repository conventions
to infer the intended change set, base branch, commit message, PR title, and PR
purpose. Ask one focused question before making changes only when you cannot
safely infer one of these, or when unrelated working-tree changes make staging
ambiguous. Combine related uncertainties into that question.

Do not pause for routine confirmation when the intent is clear. A direct
`/pr-ready` invocation is approval to carry out this workflow.

## Preflight

1. Inspect the current bb environment, Git status, current branch, remotes, and
   any repository instructions. Respect narrower repository rules over this
   generic workflow.
2. Confirm the checkout is on a named feature branch and identify the target
   base branch. Use a base named by the user; otherwise use the repository's
   configured default branch. Do not create a PR from the default branch or a
   detached HEAD.
3. Confirm GitHub CLI authentication and push access before committing when
   possible. Never print credentials or secret values.
4. Check whether an open PR already uses this head branch. Prefer bb's
   environment-linked PR lookup, then `gh pr list` or `gh pr view`. If one
   exists, stop and return its URL rather than creating a duplicate. This skill
   is for a new PR; use the existing-PR workflow for updates.
5. Inspect tracked, staged, unstaged, and untracked changes plus the full branch
   diff against the base. Include only changes that belong to the user's current
   work. Flag likely secrets, generated debris, or unusually large accidental
   files instead of staging them.
6. Run the smallest relevant validation supported by the repository when it is
   reasonably available. If validation fails, stop before commit and report the
   failure unless the user explicitly directs otherwise.

If the branch has no changes or commits relative to the base, stop. If it has
commits but no uncommitted changes, skip creating an empty commit and continue
with the push and PR.

## Commit and push

Stage the intended paths, including intended deletions, without sweeping in
unrelated files. Review the staged diff before committing. Use a short commit
subject that states the resulting change and follows repository conventions.

Push the current branch to its normal remote and set the upstream when needed.
Use a normal fast-forward push. If the push is rejected, report the rejection;
do not force-push, rebase, amend, or reset unless the user separately asks.

## Write the pull request

Draft the title and body from the final diff against the actual base branch.
Apply the same priorities as the `pr-description` skill, adapted for a PR that
does not exist yet:

- Use an outcome-focused title that is specific but short.
- Keep the body under 100 words. Most changes need 30 to 60.
- Lead with one or two sentences saying what changed and why it matters.
- Add bullets when they carry facts those sentences do not, such as a second
  area touched for a different reason. If a bullet restates, elaborates on, or
  justifies the paragraph, delete it rather than rewording it.
- Describe behavior and intent, not files, commits, or small implementation
  details.
- Use direct, neutral language. Omit filler such as "This PR" and "in order to."
- Do not mention Shortcut stories, IDs, titles, links, ticket metadata, or
  branch-name tracking references.
- Do not add a testing section unless the user asks for one. Never claim a test
  ran without evidence.

Use a single compact paragraph when the opening sentences say everything. Add
bullets when there are separate facts left to state:

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

Honor a repository-required PR template, but keep required fields terse and do
not add empty decorative sections. Create a new non-draft PR with the resolved
base, current head branch, title, and body. Re-read the body against the list
above one last time before creating the PR.

## Finish

Verify the remote PR points at the expected head and base branches. Report the
commit hash, pushed branch, PR title and URL, and validation performed. If any
step fails, state the last completed step and the remaining work. Do not claim
the PR exists until the hosting service confirms it.
