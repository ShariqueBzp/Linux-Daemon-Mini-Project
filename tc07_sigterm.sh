#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/test_common.sh"
reset_runtime; start_daemon
pid=$(cat "$PID_FILE")
kill -TERM "$pid"
for _ in {1..30}; do kill -0 "$pid" 2>/dev/null || break; sleep 0.1; done
! kill -0 "$pid" 2>/dev/null || fail TC07
grep -q "SIGTERM received" "$LOG_FILE" || fail TC07
grep -q "Daemon stopped" "$LOG_FILE" || fail TC07
pass TC07
