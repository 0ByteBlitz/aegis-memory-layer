# Loading Policy

Use this file to decide what an agent should read before working on a task.

The goal is to provide enough context without flooding the model with unrelated project history.

---

## Always read

For any code task, read:

1. `CONTEXT_PRIORITY.md`
2. `AGENT_RULES.md`
3. The relevant project or domain state file
4. The actual source files involved in the task

---

## Read only when relevant

Read these only if they match the task:

- domain-specific state files
- latest change records for the touched domain
- compacted summaries for the touched domain
- design language notes for UI work
- API contract notes for API work
- decision logs for refactors or architecture work

---

## Do not auto-load

Do not automatically load:

- unrelated domain histories
- old change records
- archived compaction files
- scratch files from unrelated branches
- every file under `.agent_files/`

---

## Task-based loading

### UI task

Read:

- frontend or UI domain state
- design language notes
- latest relevant frontend change record
- source files being changed

Skip unless relevant:

- unrelated backend domains
- payment or auth internals
- deployment notes

### API task

Read:

- API contract summary
- relevant backend domain state
- latest relevant backend change record
- source files being changed

Skip unless relevant:

- unrelated UI design notes
- unrelated service history

### Bug fix

Read:

- relevant domain state
- latest change record touching the affected file or feature
- validation notes if available
- source files being changed

### Refactor

Read:

- project state
- relevant domain state
- decision log
- recent compacted summary for the domain
- source files being changed

### Documentation-only task

Read:

- relevant official docs
- project state
- affected templates or docs

Do not load unrelated implementation history unless the documentation depends on it.

---

## Completion rule

If the task changes code or durable project documentation, the agent should create or update a change record before calling the task complete.
