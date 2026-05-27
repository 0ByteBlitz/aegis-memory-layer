# Skill: Aegis Memory Layer

Use `.agent_files` as a structured memory layer for coding-agent work.

---

## Purpose

The Aegis Memory Layer helps agents understand a project, preserve context, record changes, separate verified facts from assumptions, and avoid repeated or unsafe modifications.

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

## Before modifying code

1. Check whether `.agent_files` exists.
2. Read `AGENT_RULES.md`.
3. Read `CONTEXT_PRIORITY.md`.
4. Read `PROJECT_STATE.md` or the relevant domain `STATE.md`.
5. Read `WORKING_STATE.md` if present.
6. Read the latest relevant change record or compacted summary.
7. Inspect the actual code before editing.
8. Treat unverified or stale notes as hints only.

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

Create a new change record under `.agent_files/local/changes/`.

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

## Decision labelling

Every decision or important observation must be labelled as one of:

- `human-approved`
- `code-inferred`
- `agent-assumption`
- `temporary`
- `needs-review`

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
