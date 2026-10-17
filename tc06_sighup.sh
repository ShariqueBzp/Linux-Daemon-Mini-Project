#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/test_common.sh"
reset_runtime; start_daemon
pid=$(cat "$PID_FILE")
kill -HUP "$pid"
sleep 1
grep -q "SIGHUP received" "$LOG_FILE" || fail TC06
kill -0 "$pid" 2>/dev/null || fail TC06
pass TC06
cleanup_daemon
