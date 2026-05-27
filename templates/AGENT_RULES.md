# Agent Rules

These rules define how an AI coding agent should use Plumblines project memory.

`.agent_files` is a memory layer, not the source of truth. The agent must inspect the actual code before making or validating changes.

---

## Core rule

Source code is the final truth.

When sources conflict, trust them in this order:

1. Source code
2. Tests
3. API schemas, migrations, generated types
4. CI/CD configuration
5. Official documentation
6. Architecture Decision Records
7. Tickets, pull requests, and commit history
8. `.agent_files/shared`
9. `.agent_files/domains`
10. `.agent_files/local`
11. Agent assumptions

---

## Before changing code

1. Read `CONTEXT_PRIORITY.md`.
2. Read `LOADING_POLICY.md` if present.
3. Read the relevant project or domain state file.
4. Read relevant design, architecture, API, or decision notes.
5. Read `local/WORKING_STATE.md` only if it is relevant to the current branch or task.
6. Read the latest relevant change record or compacted summary.
7. Inspect the actual source files involved in the task.
8. Treat stale, inferred, or unverified memory as hints only.

---

## Loading rules

Do not load every file under `.agent_files`.

Always load:

- `CONTEXT_PRIORITY.md`
- `LOADING_POLICY.md`, if present
- relevant project or domain state
- actual source files involved in the task

Load only when relevant:

- domain-specific change records
- compacted summaries
- design notes
- API contract notes
- decision logs
- validation notes

Do not auto-load:

- unrelated domain history
- old change records
- archived compactions
- unrelated scratch files
- branch notes from unrelated work

---

## While changing code

1. Make focused, reversible changes.
2. Follow existing architecture and design patterns.
3. Prefer consistency over novelty.
4. Avoid unnecessary dependencies.
5. Do not change important system boundaries unless explicitly required.
6. Label assumptions clearly.
7. Update tests when behaviour changes.
8. Do not present assumptions as verified facts.

---

## After changing code

Create or update a change record under:

```txt
.agent_files/local/changes/
```

Use a timestamp or ticket-based folder name:

```txt
YYYY-MM-DD_HHMM-short-description/
```

or:

```txt
TICKET-ID-short-description/
```

A change record should include:

- `change.md`
- `validation.md`
- `decisions.md`
- `risks.md`
- `followups.md`

Add `provenance.md` when the task involved important decisions, assumptions, architecture changes, or unclear evidence.

---

## Completion gate

A task that changes code or durable project documentation is not complete until one of these is true:

1. A new change record exists.
2. An existing change record was updated.
3. No change record was needed because no files were changed.

If files were changed, the change record must include:

- goal
- summary
- files changed
- touched files
- behaviour before
- behaviour after
- validation performed
- what was not checked
- risks
- follow-ups
- `valid_as_of_commit`
- assumptions used, if any

Do not call the task complete before satisfying this gate.

---

## Validity and staleness

State files and change records should include:

```txt
valid_as_of_commit: COMMIT_SHA
```

State files should list files they depend on:

```md
## Files This State Depends On

- `path/to/file`
```

Change records should list touched files:

```md
## Touched Files

- `path/to/file`
```

If a related source file changed after `valid_as_of_commit`, treat the memory record as `needs-review` until it has been checked again.

---

## Decision labels

Every important decision or observation should be labelled as one of:

- `human-approved`
- `code-inferred`
- `agent-assumption`
- `temporary`
- `needs-review`

Do not promote an assumption into a verified decision without evidence.

---

## Provenance rules

When recording an important decision, include what the decision was based on.

Track:

- source files inspected
- tests inspected
- state files used
- tickets or human instructions used
- assumptions used
- evidence not checked
- confidence level

If a decision depends on an assumption, mark the decision as lower confidence or `needs-review`.

---

## Validation rules

Record validation in `validation.md`.

Include:

- commands run
- results
- manual checks
- known failures
- what was not checked
- confidence level

If no tests or checks were run, say so clearly.

---

## Private context rules

Do not store private credentials, tokens, customer information, production data, or private operational details in `.agent_files`.

Use placeholders such as:

- `<TOKEN>`
- `<CUSTOMER_ID>`
- `<INTERNAL_URL>`
- `<PRIVATE_VALUE>`

---

## Compaction rules

After around 10 change records, or after a large task, compact older records into:

```txt
.agent_files/compacted/
```

A compacted summary should preserve:

- major changes
- important decisions
- architecture changes
- design changes
- API or data changes
- risks introduced and resolved
- remaining follow-ups
- rejected approaches
- current state
- lessons for future agents

After compaction, update `PROJECT_STATE.md` or the relevant domain `STATE.md`.

---

## Final reminder

Plumblines should help agents understand the project faster, but it must never replace reading the actual code.
