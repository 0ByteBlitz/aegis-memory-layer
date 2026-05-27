---
record_type: change
id: YYYY-MM-DD-short-description
valid_as_of_commit: COMMIT_SHA
depends_on:
  - path/to/file
trust: verified
provenance:
  - { source: path/to/file, trust: verified }
validation: none
risks: see-body
followups: see-body
---

# Change Record

## Metadata

Date:
Agent:
Branch:
Base branch:
Ticket:
Pull request:
Domain:

## Validity

Base commit:
Result commit:
Valid as of commit:

## Touched Files

- `path/to/file`

## Goal

Describe the goal of this change.

## Summary

Explain what changed in plain language.

## Files Changed

| File | Change | Reason |
|---|---|---|
| `path/to/file` | Updated logic | Reason |

## Behaviour Before

Describe previous behaviour.

## Behaviour After

Describe new behaviour.

## Inputs Used

| Input | Type | Trust Level | Evidence |
|---|---|---|---|
| `path/to/file` | source code | source-truth | Inspected directly |
| `PROJECT_STATE.md` | memory | verified / inferred / stale | valid as of commit |

## Assumptions Used

- Assumption one

## Validation Summary

Link to `validation.md` or summarise validation performed.

## State Update Needed?

- [ ] No
- [ ] Yes, update project or domain state
- [ ] Yes, update official docs
- [ ] Yes, create an architecture decision record

## Completion Check

- [ ] Change record filled in
- [ ] Validation recorded
- [ ] Risks recorded
- [ ] Follow-ups recorded
