# Plumblines Framework

Plumblines is a structured project-memory framework for AI coding agents.

It gives agents a reliable place to read and write project context without turning temporary notes into the source of truth.

---

## Purpose

Plumblines helps agents answer:

- What is this project?
- What architecture and design rules should I follow?
- What changed recently?
- What is currently being worked on?
- Which decisions are verified?
- Which assumptions need review?
- What should I avoid touching?

The framework is useful when agents repeatedly modify a codebase across multiple iterations.

---

## Core principles

### 1. Code is the final truth

`.agent_files` is a memory layer, not an authority layer.

When documents and code disagree, the agent should inspect and trust the current source code first.

### 2. Memory must be labelled

Important claims should be labelled as:

- `verified`
- `inferred`
- `assumed`
- `needs-review`
- `stale`

This prevents agents from treating guesses as approved decisions.

### 3. Shared and local memory must be separate

Use:

```txt
shared/ = reviewed, team-safe, optionally committed
local/  = temporary, personal, branch-specific, usually ignored by git
```

### 4. Every change should leave a useful trail

A change record should explain what changed, why, what was validated, what was not checked, and what risks remain.

### 5. Memory must be compacted

Agent history becomes noisy. Compact older records into durable summaries.

### 6. Large systems need domain memory

Large distributed codebases should split memory by domain, service, package, or product area.

---

## Source-of-truth hierarchy

When sources conflict, use this priority order:

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

## Small-project structure

```txt
.agent_files/
  AGENT_RULES.md
  CONTEXT_PRIORITY.md
  PROJECT_STATE.md

  docs/
    system-design.md
    frontend-design.md
    design-language.md
    api-contracts.md
    coding-standards.md

  local/
    WORKING_STATE.md
    scratch.md
    changes/
      2026-05-27_1130-ui-layout-update/
        change.md
        validation.md
        decisions.md
        risks.md
        followups.md

  compacted/
    2026-05.md

  templates/
```

---

## Team or large-codebase structure

```txt
.agent_files/
  README.md
  AGENT_RULES.md
  CONTEXT_PRIORITY.md

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

## Recommended git strategy

For personal projects, the whole folder can be ignored:

```gitignore
.agent_files/
```

For team projects, commit shared context and ignore local context:

```gitignore
.agent_files/local/
```

Commit reviewed files such as:

```txt
.agent_files/README.md
.agent_files/AGENT_RULES.md
.agent_files/CONTEXT_PRIORITY.md
.agent_files/shared/
.agent_files/domains/
.agent_files/templates/
```

Keep temporary agent state local:

```txt
.agent_files/local/
```

---

## Agent workflow

### Before changing code

1. Read `CONTEXT_PRIORITY.md`.
2. Read `AGENT_RULES.md`.
3. Read `PROJECT_STATE.md` or the relevant domain `STATE.md`.
4. Read `WORKING_STATE.md` if present.
5. Read the latest relevant change record or compacted summary.
6. Inspect the actual code.
7. Treat stale or unverified notes as hints only.

### While changing code

1. Make focused, reversible changes.
2. Follow existing architecture and design patterns.
3. Avoid unnecessary dependencies.
4. Avoid changing sensitive areas unless explicitly required.
5. Label assumptions clearly.
6. Update tests when behaviour changes.

### After changing code

1. Create a new change record under `.agent_files/local/changes/`.
2. Record files changed.
3. Record why changes were made.
4. Record validation performed.
5. Record what was not checked.
6. Record risks and follow-ups.
7. Update project or domain state if the stable project state changed.
8. Escalate important changes to official docs or ADRs if needed.

---

## Change record naming

For solo work, simple versions are acceptable:

```txt
v1/
v2/
v3/
```

For real teams, prefer timestamp or ticket-based names:

```txt
2026-05-27_1130-payment-retry/
PROJ-123-payment-retry/
```

This avoids conflicts when multiple branches create change records at the same time.

---

## Decision labelling

Every decision or important observation should be labelled as one of:

- `human-approved`
- `code-inferred`
- `agent-assumption`
- `temporary`
- `needs-review`

---

## Handling private or sensitive context

Do not store private credentials, tokens, customer information, or production-only details in Plumblines files. Use placeholders such as `<TOKEN>`, `<CUSTOMER_ID>`, or `<INTERNAL_URL>`.

---

## Compaction

Compact after:

- around 10 change records
- one month of active work
- a large branch is ready to merge
- the local history becomes noisy

A compacted summary should include:

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
