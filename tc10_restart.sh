#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/test_common.sh"
reset_runtime; start_daemon
pid1=$(cat "$PID_FILE")
kill -TERM "$pid1"
for _ in {1..30}; do [[ ! -e "$PID_FILE" ]] && break; sleep 0.1; done
start_daemon
pid2=$(cat "$PID_FILE")
[[ "$pid1" != "$pid2" ]] || fail TC10
kill -0 "$pid2" 2>/dev/null || fail TC10
pass TC10
cleanup_daemon
