#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/test_common.sh"
reset_runtime; start_daemon
pid=$(cat "$PID_FILE")
[[ "$pid" =~ ^[0-9]+$ ]] || fail TC04
kill -0 "$pid" 2>/dev/null || fail TC04
cmd=$(ps -p "$pid" -o comm= | xargs)
[[ "$cmd" == "student_daemon" ]] || fail TC04
pass TC04
cleanup_daemon
