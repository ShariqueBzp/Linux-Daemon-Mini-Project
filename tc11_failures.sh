#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/test_common.sh"
reset_runtime
mkdir "$PID_FILE"
set +e
output=$("$ROOT_DIR/student_daemon" 2>&1)
rc=$?
set -e
rmdir "$PID_FILE"
[[ $rc -ne 0 ]] || fail TC11
grep -q "cannot open PID file" <<<"$output" || fail TC11
pass TC11
