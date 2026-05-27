# Skill: Plumblines

Use `.agent_files` as a structured memory layer for coding-agent work.

---

## Purpose

Plumblines helps agents understand a project, preserve context, record changes, separate verified facts from assumptions, detect stale project memory, and avoid repeated or unsafe modifications.

---

## Core rule

The source code is the final truth. `.agent_files` is memory, not authority.

When sources conflict, trust them in this order:

1. Source code
2. Tests
3. API schemas, migrations, generated types
4. CI/CD configuration
5. Official documentation
6. Architecture Decision Records
7. Tickets, PRs, and commit history
8. `.agent_files/shared`
9. `.agent_files/domains`
10. `.agent_files/local`
11. Agent assumptions

---

## Loading policy

Do not load every memory file by default.

Always read:

1. `AGENT_RULES.md`
2. `CONTEXT_PRIORITY.md`
3. `LOADING_POLICY.md` if present
4. `PROJECT_STATE.md` or the relevant domain `STATE.md`
5. The actual source files involved in the task

Read only when relevant:

- domain-specific state
- latest change record for the touched domain
- compacted summaries for the touched domain
- design notes for UI work
- API contract notes for API work
- decision logs for refactors or architecture work

Do not auto-load unrelated domains, old change records, archived compactions, or scratch files from unrelated branches.

---

## Before modifying code

1. Check whether `.agent_files` exists.
2. Apply the loading policy.
3. Inspect the actual code before editing.
4. Treat unverified or stale notes as hints only.
5. Check whether relevant memory has `valid_as_of_commit` metadata.

---

## While modifying code

1. Make focused, reversible changes.
2. Follow existing architecture and design patterns.
3. Avoid unnecessary dependencies.
4. Do not change sensitive areas unless explicitly required.
5. Label assumptions clearly.
6. Prefer small, testable changes.
7. Update tests when behaviour changes.

---

## After modifying code

Create or update a change record under `.agent_files/local/changes/`.

Use a timestamp or ticket-based folder name:

```txt
YYYY-MM-DD_HHMM-short-description/
```

or:

```txt
TICKET-ID-short-description/
```

Include:

- `change.md`
- `validation.md`
- `decisions.md`
- `risks.md`
- `followups.md`

Also include when possible:

- `valid_as_of_commit`
- touched files
- provenance inputs
- assumptions used

The change record must document:

- goal
- files changed
- behaviour before and after
- decisions made
- validation performed
- what was not checked
- risks
- follow-up tasks
- whether official docs or ADRs need updating

---

## Completion gate

A task that changes code or durable project documentation is not complete until one of these is true:

1. A new change record exists and includes validation, risks, follow-ups, touched files, and commit validity metadata.
2. An existing change record was updated with the same information.
3. No change record was needed because no files were changed.

Do not present the task as complete before satisfying this gate.

---

## Decision labelling

Every decision or important observation must be labelled as one of:

- `human-approved`
- `code-inferred`
- `agent-assumption`
- `temporary`
- `needs-review`

Do not present assumptions as approved decisions.

---

## Provenance

When making or recording an important decision, record what the decision was based on.

Track:

- source files inspected
- state files used
- tickets or human instructions used
- assumptions used
- evidence not checked
- confidence level

If a decision depends on an assumption, mark that decision as lower confidence or `needs-review`.

---

## Staleness

State files and change records should include:

```txt
valid_as_of_commit: COMMIT_SHA
```

They should also list files they depend on or touched files.

If a related file changed after `valid_as_of_commit`, treat the memory record as `needs-review` until checked again.

---

## Private context rule

Do not store credentials, tokens, customer information, production data, or private operational details in `.agent_files`.

Use placeholders such as:

- `<TOKEN>`
- `<CUSTOMER_ID>`
- `<INTERNAL_URL>`

---

## Compaction

After around 10 change records, or after a large task, compact older records into `.agent_files/compacted/`.

A compacted summary must include:

- major changes
- important decisions
- architecture, design, API, or data changes
- risks introduced and resolved
- remaining follow-ups
- rejected approaches
- current state
- lessons for future agents

After compaction, update `PROJECT_STATE.md` or the relevant domain `STATE.md`.

---

## Large codebases

For large or distributed systems, use domain memory:

```txt
.agent_files/domains/<domain>/STATE.md
```

Agents should read only:

1. global rules
2. global project state
3. relevant domain state
4. latest relevant changes
5. source code

Do not load unrelated domain history unless needed.

---

## Shared vs local

Use:

```txt
.agent_files/shared/
```

for reviewed, team-safe, optionally committed context.

Use:

```txt
.agent_files/local/
```

for temporary, branch-specific, usually gitignored agent memory.

---

## Final reminder

`.agent_files` should help agents understand the codebase faster, but it must never replace reading the actual code.
