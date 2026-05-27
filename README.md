# Plumblines

**A plain-Markdown project continuity framework for AI coding agents.**

Plumblines helps AI coding agents preserve project context across sessions, record changes, track assumptions, detect stale memory, and avoid repeatedly rediscovering the same codebase decisions.

It creates a lightweight memory system inside a project using a `.agent_files/` directory.

---

## Why this exists

AI coding agents often struggle with continuity. They may forget previous decisions, repeat work, misread architecture, or confidently act on stale assumptions.

Plumblines gives agents a clear place to read and write project context:

- current project state
- architecture and design notes
- working branch state
- change history
- validation logs
- risks and follow-ups
- verified decisions vs assumptions
- commit-anchored validity metadata
- compaction summaries after many iterations

---

## Core idea

Plumblines is not a replacement for your codebase, tests, pull requests, or official documentation.

It is an **agent coordination layer**.

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

The source code remains the final truth.

---

## What changed in v0.2

Plumblines v0.2 responds to the biggest weakness of passive Markdown memory: agents can skip it, and stale notes can silently become wrong.

New mechanics:

- **Loading policy**: tells agents what to read and what to skip per task type.
- **Commit anchoring**: state files and change records include `valid_as_of_commit`.
- **Staleness checker**: optional Git-based script flags records whose dependent files changed after their validity commit.
- **Provenance tracking**: records which sources and assumptions informed a decision.
- **Completion checks**: code changes are not complete until the change record, validation, risks, and follow-ups are recorded.

See [`docs/v0.2-upgrade-notes.md`](docs/v0.2-upgrade-notes.md).

---

## Minimal project structure

```txt
.agent_files/
  AGENT_RULES.md
  CONTEXT_PRIORITY.md
  LOADING_POLICY.md
  PROJECT_STATE.md

  docs/
    system-design.md
    frontend-design.md
    design-language.md

  local/
    WORKING_STATE.md
    changes/

  compacted/

  templates/
```

---

## Team or large-codebase structure

```txt
.agent_files/
  README.md
  AGENT_RULES.md
  CONTEXT_PRIORITY.md
  LOADING_POLICY.md

  shared/
    PROJECT_STATE.md
    ARCHITECTURE_SUMMARY.md
    DESIGN_SYSTEM_SUMMARY.md
    API_CONTRACT_SUMMARY.md
    DECISION_LOG.md
    KNOWN_RISKS.md

  domains/
    frontend/
      STATE.md
      DESIGN_NOTES.md
      DECISION_LOG.md
      changes/

    auth/
      STATE.md
      DECISION_LOG.md
      changes/

    payments/
      STATE.md
      DECISION_LOG.md
      changes/

  local/
    WORKING_STATE.md
    scratch.md
    changes/

  compacted/

  templates/
```

---

## Recommended Git strategy

For solo projects, you can keep everything local:

```gitignore
.agent_files/
```

For team projects, use a hybrid approach:

```gitignore
.agent_files/local/
```

Commit reviewed shared context:

```txt
.agent_files/README.md
.agent_files/AGENT_RULES.md
.agent_files/CONTEXT_PRIORITY.md
.agent_files/LOADING_POLICY.md
.agent_files/shared/
.agent_files/domains/
.agent_files/templates/
```

Keep temporary agent state local:

```txt
.agent_files/local/
```

---

## Core principles

### 1. Code is the final truth

Plumblines helps agents understand the project faster, but it must never replace reading the actual code.

### 2. Memory must be labelled

Important observations should be labelled as:

- `verified`
- `inferred`
- `assumed`
- `needs-review`
- `stale`

### 3. Memory should be anchored to commits

State files and change records should include:

```txt
valid_as_of_commit: COMMIT_SHA
```

This allows stale records to be found when related files change later.

### 4. Agents should load selectively

Agents should read the relevant domain and latest related records, not the whole `.agent_files/` tree.

### 5. Every change should leave a trail

After modifying a codebase, an agent should record:

- what changed
- why it changed
- files touched
- validation performed
- risks
- follow-ups
- links to tickets, PRs, branches, or commits

### 6. Memory must be compacted

After about 10 change records, or after a large task, compact older notes into a summary.

---

## What is included in this repository

```txt
docs/
  framework.md
  skill.md
  v0.2-upgrade-notes.md

templates/
  context-priority.md
  loading-policy.md
  project-state.md
  working-state.md
  domain-state.md
  change.md
  validation.md
  decisions.md
  provenance.md
  risks.md
  followups.md
  compaction.md

scripts/
  check-staleness.sh
```

---

## Quick start

1. Copy the templates into your project under `.agent_files/`.
2. Fill out `PROJECT_STATE.md`.
3. Add project-specific rules to `AGENT_RULES.md`.
4. Add `LOADING_POLICY.md` so agents know what to read and what to skip.
5. Tell your coding agent to read `.agent_files/AGENT_RULES.md`, `.agent_files/CONTEXT_PRIORITY.md`, and `.agent_files/LOADING_POLICY.md` before modifying code.
6. After every meaningful change, ask the agent to create a new change record under `.agent_files/local/changes/`.
7. Add `valid_as_of_commit` and touched/dependent files to state and change records.
8. Optionally run `scripts/check-staleness.sh` to flag records that may need review.
9. Compact older records when the history becomes noisy.

---

## Suggested agent instruction

```txt
Before changing this codebase, read `.agent_files/AGENT_RULES.md`, `.agent_files/CONTEXT_PRIORITY.md`, `.agent_files/LOADING_POLICY.md`, `.agent_files/PROJECT_STATE.md`, and the relevant domain state. Load only task-relevant memory. After making changes, create or update a change record under `.agent_files/local/changes/` using the Plumblines templates. The task is not complete until validation, risks, follow-ups, touched files, and valid_as_of_commit are recorded, or until you state that no files were changed.
```

---

## Optional staleness check

```bash
bash scripts/check-staleness.sh
```

The script scans `.agent_files` for Markdown records with `valid_as_of_commit` and flags records whose listed files changed after that commit.

---

## Status

Public framework draft, upgraded to v0.2. The structure remains plain Markdown so it works with any coding agent, editor, or repository.
