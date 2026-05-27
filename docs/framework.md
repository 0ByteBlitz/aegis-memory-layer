# Plumblines Framework

Plumblines is a plain-Markdown project continuity framework for AI coding agents.

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
- Which memory records may be stale?
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

### 3. Memory should be anchored to commits

State files and change records should include:

```txt
valid_as_of_commit: COMMIT_SHA
```

This lets humans or tools detect when related source files changed after the memory record was written.

### 4. Agents should load selectively

Agents should not load every memory file by default.

Use `LOADING_POLICY.md` to decide which project, domain, change, and compaction files are relevant to the task.

### 5. Shared and local memory must be separate

Use:

```txt
shared/ = reviewed, team-safe, optionally committed
local/  = temporary, personal, branch-specific, usually ignored by git
```

### 6. Every change should leave a useful trail

A change record should explain what changed, why, what was validated, what was not checked, and what risks remain.

### 7. Memory must be compacted

Agent history becomes noisy. Compact older records into durable summaries.

### 8. Large systems need domain memory

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
  LOADING_POLICY.md
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
        provenance.md
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

## Loading policy

The loading policy is the main defense against context-window bloat.

Agents should always read:

1. `CONTEXT_PRIORITY.md`
2. `AGENT_RULES.md`
3. `LOADING_POLICY.md`
4. The relevant project or domain state file
5. The actual source files involved in the task

Agents should only read relevant domain history, compacted summaries, and decision logs.

They should not automatically read unrelated domains, old change records, archived compactions, or scratch files from unrelated branches.

---

## Agent workflow

### Before changing code

1. Read `CONTEXT_PRIORITY.md`.
2. Read `AGENT_RULES.md`.
3. Read `LOADING_POLICY.md` if present.
4. Read `PROJECT_STATE.md` or the relevant domain `STATE.md`.
5. Read `WORKING_STATE.md` if present and relevant.
6. Read the latest relevant change record or compacted summary.
7. Inspect the actual code.
8. Treat stale or unverified notes as hints only.

### While changing code

1. Make focused, reversible changes.
2. Follow existing architecture and design patterns.
3. Avoid unnecessary dependencies.
4. Avoid changing sensitive areas unless explicitly required.
5. Label assumptions clearly.
6. Update tests when behaviour changes.

### After changing code

1. Create or update a change record under `.agent_files/local/changes/`.
2. Record files changed.
3. Record touched files.
4. Record `valid_as_of_commit`.
5. Record why changes were made.
6. Record validation performed.
7. Record what was not checked.
8. Record risks and follow-ups.
9. Record provenance if decisions were made.
10. Update project or domain state if the stable project state changed.
11. Escalate important changes to official docs or ADRs if needed.

---

## Completion gate

A task that changes code or durable project documentation is not complete until one of these is true:

1. A new change record exists and includes validation, risks, follow-ups, touched files, and commit validity metadata.
2. An existing change record was updated with the same information.
3. No change record was needed because no files were changed.

This turns memory writing into a completion condition instead of a nice-to-have side task.

---

## Commit anchoring and staleness

State files and change records should include:

```txt
valid_as_of_commit: COMMIT_SHA
```

State files should also include:

```txt
## Files This State Depends On

- `path/to/file`
```

Change records should include:

```txt
## Touched Files

- `path/to/file`
```

The optional script `scripts/check-staleness.sh` uses these fields to flag memory records that may need review.

---

## Provenance and lineage

Important decisions should record what they were based on.

Track:

- source files inspected
- state files used
- ticket or human instructions used
- assumptions used
- evidence not checked
- confidence level

If a decision depends on an assumption, mark that decision as lower confidence or `needs-review`.

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

Do not present assumptions as approved decisions.

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

## Optional staleness check

Run:

```bash
bash scripts/check-staleness.sh
```

The script scans `.agent_files` for Markdown records with `valid_as_of_commit` and flags records whose listed files changed after that commit.

---

## Final reminder

Plumblines should help agents understand the project faster, but it must never replace reading the actual code.
