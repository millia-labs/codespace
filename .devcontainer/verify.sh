#!/usr/bin/env bash
# Smoke check for the devcontainer sandbox — runs on postCreate, safe to re-run by hand.
# This box only carries the two tools it exists for: `act` and a container builder.
set -uo pipefail

fail=0
check() {
  local name="$1"; shift
  if out="$("$@" 2>&1)"; then
    printf '  ✓ %-8s %s\n' "$name" "$(printf '%s' "$out" | head -n1)"
  else
    printf '  ✗ %-8s FAILED: %s\n' "$name" "$(printf '%s' "$out" | head -n1)"
    fail=1
  fi
}

echo "== Millia devcontainer sandbox =="
check act    act --version
check docker docker --version

if [ "$fail" -eq 0 ]; then
  echo "== ready: act + container builder present =="
else
  echo "== one or more tools missing (see above) ==" >&2
fi
exit "$fail"
