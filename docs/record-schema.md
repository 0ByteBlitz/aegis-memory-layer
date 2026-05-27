# Plumblines Record Schema (v0.2.1)

Every change record and state file begins with a YAML frontmatter block
delimited by `---`. Frontmatter is machine-read by the scripts; the Markdown
body is for humans and agents. Metadata lives in frontmatter (not prose) so the
check scripts are deterministic instead of regex-guessing.

## Change record (`.agent_files/**/changes/*.md`)

```yaml
---
record_type: change          # change | state | decision | validation
id: 2026-05-27-auth-refresh  # unique, stable; date-slug convention
valid_as_of_commit: a1b2c3d  # SHA the record was true as of
depends_on:                  # files/dirs this record's claims depend on
  - src/auth/session.ts
trust: verified              # verified | inferred | assumed | needs-review | stale
provenance:                  # inputs that informed this record
  - { source: src/auth/session.ts, trust: verified }
  - { source: "assumption: tokens rotate every 15m", trust: assumed }
validation: passed           # passed | failed | none
risks: none                  # none | <text> | see-body
followups: none              # none | <id-list> | see-body
---

# What changed
<prose: what, why, files touched, how validated, residual risk>
```

## State file (`PROJECT_STATE.md`, `domains/*/STATE.md`, `WORKING_STATE.md`)

```yaml
---
record_type: state
id: project-state
valid_as_of_commit: a1b2c3d
depends_on:
  - src/
trust: verified
---

# Project state
<prose>
```

## Field rules

- `valid_as_of_commit` — short or full SHA; resolved with `git rev-parse`.
- `depends_on` — paths relative to repo root; directories allowed.
- `trust` — one of the five labels.
- `provenance[].trust` — same vocabulary as `trust`.

## Provenance-propagation rule

> A record's `trust` cannot exceed the **lowest** `trust` among its `provenance`
> inputs. Ordering high→low: `verified > inferred > assumed`. Records labelled
> `needs-review` or `stale` are exempt. `check-completeness.sh` fails violations.
