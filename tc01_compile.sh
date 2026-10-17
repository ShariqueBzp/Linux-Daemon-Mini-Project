#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
make -C "$ROOT_DIR" clean
if make -C "$ROOT_DIR" 2>&1 | tee /tmp/student_daemon_build.log; then
  if grep -E 'warning:|error:' /tmp/student_daemon_build.log; then echo "TC01 FAIL"; exit 1; fi
  test -x "$ROOT_DIR/student_daemon"
  echo "TC01 PASS"
else echo "TC01 FAIL"; exit 1; fi
