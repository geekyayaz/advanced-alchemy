#!/usr/bin/env bash
# test.sh — Project Olympus test harness
#
# Usage:
#   ./test.sh base   — run pre-existing tests (must pass on baseline, no solution needed)
#   ./test.sh new    — run the new challenge tests (must FAIL on baseline, PASS with solution)
#
# All tests use an in-memory SQLite database; no network access is required.

set -euo pipefail

MODE="${1:-new}"

# Resolve the uv-managed Python interpreter
PYTHON="$(uv run python -c 'import sys; print(sys.executable)')"
PYTEST="uv run pytest"

case "$MODE" in
  base)
    echo "=== Running baseline regression tests ==="
    exec $PYTEST tests/unit/ \
      --ignore=tests/unit/test_polymorphic.py \
      -q --tb=short \
      -x
    ;;
  new)
    echo "=== Running new polymorphic-support tests ==="
    exec $PYTEST tests/unit/test_polymorphic.py \
      -v --tb=short
    ;;
  *)
    echo "Unknown mode '$MODE'. Use: base | new" >&2
    exit 1
    ;;
esac
