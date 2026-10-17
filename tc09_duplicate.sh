#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/test_common.sh"
reset_runtime; start_daemon
pid1=$(cat "$PID_FILE")
set +e
output=$("$ROOT_DIR/student_daemon" 2>&1)
rc=$?
set -e
[[ $rc -ne 0 ]] || fail TC09
grep -q "already running" <<<"$output" || fail TC09
[[ "$(cat "$PID_FILE")" == "$pid1" ]] || fail TC09
pass TC09
cleanup_daemon
