# Wiring the Plumblines gate

## Pre-push hook

`.git/hooks/pre-push`:

```bash
#!/usr/bin/env bash
exec scripts/check-completeness.sh origin/main HEAD
```

`chmod +x .git/hooks/pre-push`.

## CI (GitHub Actions)

`.github/workflows/plumblines.yml`:

```yaml
name: plumblines
on: pull_request
jobs:
  completeness:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with: { fetch-depth: 0 }
      - name: Completeness gate
        run: bash scripts/check-completeness.sh origin/${{ github.base_ref }} HEAD
      - name: Staleness report (non-blocking)
        run: bash scripts/check-staleness.sh || true
```

Completeness **blocks**; staleness **reports** (`|| true`) — stale notes need
human judgement, not auto-fail.

## Tuning

- `PLUMBLINES_SRC_GLOBS="src/ services/ cmd/"` — what counts as source for
  coverage. Default: `src/ lib/ app/ packages/`.
- `PLUMBLINES_DIR=.agent_files` — override if you relocate the memory tree.

## Scope (be honest in the README)

The gate enforces that a record *exists* and that trust labels don't escalate.
It does not verify the prose is accurate — that still needs review. It removes
the silent-skip failure mode: non-compliance is now loud.
