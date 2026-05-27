# Provenance

Use this file to record what the agent relied on when making a decision or change.

Provenance helps prevent assumptions from being promoted into verified project memory without evidence.

---

## Inputs Used

| Input | Type | Trust Level | Evidence |
|---|---|---|---|
| `path/to/file` | source code | source-truth | Inspected directly |
| `PROJECT_STATE.md` | memory | verified / inferred / stale | valid as of commit |
| `WORKING_STATE.md` | local memory | assumed | branch note |
| Ticket or issue | work item | human-provided | ticket ID or link |

---

## Derived From Assumptions?

yes / no

If yes, list assumptions:

- Assumption one
- Assumption two

---

## Decision Confidence

low / medium / high

---

## Evidence Checked

- [ ] Source code inspected
- [ ] Tests inspected
- [ ] API schema or types inspected
- [ ] Existing documentation inspected
- [ ] Recent change records inspected
- [ ] Human instruction or ticket inspected

---

## Evidence Not Checked

List important evidence that was not checked.

---

## Inherited Risk

Does this decision inherit risk from unverified assumptions?

yes / no

If yes, explain:

- Risk one
