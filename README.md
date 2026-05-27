# Aegis Memory Layer

**A structured project-memory framework for AI coding agents.**

Aegis Memory Layer helps AI coding agents preserve project context, record changes, separate verified facts from assumptions, and avoid stale or unsafe modifications.

It creates a lightweight memory system inside a project using a `.agent_files/` directory. The goal is to make agents smoother, safer, and more consistent when working across multiple coding iterations.

---

## Why this exists

AI coding agents often struggle with continuity. They may forget previous decisions, repeat work, misread architecture, or confidently act on stale assumptions.

Aegis Memory Layer gives agents a clear place to read and write project context:

- current project state
- architecture and design notes
- working branch state
- change history
- validation logs
- risks and follow-ups
- verified decisions vs assumptions
- compaction summaries after many iterations

The framework is useful for solo projects, agent-heavy development workflows, and larger team environments where shared and local agent context need to be separated.

---

## Core idea

Aegis is not a replacement for your codebase, tests, pull requests, or official documentation.

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

## Minimal project structure

```txt
.agent_files/
  AGENT_RULES.md
  CONTEXT_PRIORITY.md
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

  shared/
    PROJECT_STATE.md
    ARCHITECTURE_SUMMARY.md
    DESIGN_SYSTEM_SUMMARY.md
    API_CONTRACT_SUMMARY.md
    SECURITY_RULES.md
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

Aegis helps agents understand the project faster, but it must never replace reading the actual code.

### 2. Memory must be labelled

Important observations should be labelled as:

- `verified`
- `inferred`
- `assumed`
- `needs-review`
- `stale`

### 3. Shared and local memory must be separate

Use shared memory for reviewed, team-safe context. Use local memory for temporary branch notes, scratchpads, and agent iteration logs.

### 4. Every change should leave a trail

After modifying a codebase, an agent should record:

- what changed
- why it changed
- files touched
- validation performed
- risks
- follow-ups
- links to tickets, PRs, branches, or commits

### 5. Memory must be compacted

After about 10 change records, or after a large task, compact older notes into a summary.

### 6. Large systems need domain memory

Large distributed codebases should use domain-level memory instead of one giant global project state file.

---

## What is included in this repository

```txt
docs/
  framework.md
  skill.md

templates/
  AGENT_RULES.md
  CONTEXT_PRIORITY.md
  PROJECT_STATE.md
  WORKING_STATE.md
  DOMAIN_STATE.md
  change.md
  validation.md
  decisions.md
  risks.md
  followups.md
  compaction.md
```

---

## Quick start

1. Copy the templates into your project under `.agent_files/`.
2. Fill out `PROJECT_STATE.md`.
3. Add project-specific rules to `AGENT_RULES.md`.
4. Tell your coding agent to read `.agent_files/AGENT_RULES.md` before modifying code.
5. After every meaningful change, ask the agent to create a new change record under `.agent_files/local/changes/`.
6. Compact older records when the history becomes noisy.

---

## Suggested agent instruction

```txt
Before changing this codebase, read `.agent_files/AGENT_RULES.md`, `.agent_files/CONTEXT_PRIORITY.md`, `.agent_files/PROJECT_STATE.md`, and any relevant domain state. After making changes, create a new change record under `.agent_files/local/changes/` using the Aegis Memory Layer templates.
```

---

## Status

Early public framework draft. The structure is intentionally plain Markdown so it works with any coding agent, editor, or repository.
