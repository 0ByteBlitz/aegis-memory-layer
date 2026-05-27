# Agent Rules

## Before changing code

1. Read `CONTEXT_PRIORITY.md`.
2. Read the relevant project or domain state file.
3. Read relevant design, architecture, or API notes.
4. Read `local/WORKING_STATE.md` if present.
5. Inspect the actual source code before editing.
6. Treat stale or unverified notes as hints, not facts.

## While changing code

1. Make focused, reversible changes.
2. Follow existing project patterns.
3. Prefer consistency over novelty.
4. Avoid unnecessary dependencies.
5. Do not change important system boundaries unless explicitly required.
6. Label assumptions clearly.
7. Update tests when behaviour changes.

## After changing code

1. Create a new change record under `local/changes/`.
2. Record files changed.
3. Record why changes were made.
4. Record validation performed.
5. Record what was not checked.
6. Record risks and follow-ups.
7. Update project or domain state if the stable project state changed.
8. Escalate important decisions to official docs or ADRs if needed.

## Context rules

- Source code is the final truth.
- `.agent_files` is memory, not authority.
- Unverified notes should be treated as hints only.
- Agent assumptions must be labelled clearly.
- If a memory file conflicts with code, inspect the code and update the memory file if appropriate.

## Change record rules

Every meaningful code change should create or update a change record.

A change record should include:

- goal
- summary
- files changed
- behaviour before
- behaviour after
- validation performed
- risks
- follow-ups
- unresolved questions

## Decision rules

Important decisions should be labelled as one of:

- `human-approved`
- `code-inferred`
- `agent-assumption`
- `temporary`
- `needs-review`

Do not present assumptions as approved decisions.

## Private project context

Keep private project details out of agent memory files unless they are safe to share with the team.

Use short placeholders for values that should not be copied into documentation.

Examples:

- `<PRIVATE_VALUE>`
- `<CUSTOMER_REFERENCE>`
- `<INTERNAL_REFERENCE>`
- `<ENV_VALUE>`

## Compaction rules

After around 10 change records, or after a large task, compact older records into `compacted/`.

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
