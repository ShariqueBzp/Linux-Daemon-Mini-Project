#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/test_common.sh"
reset_runtime; start_daemon
pid=$(cat "$PID_FILE")
kill -TERM "$pid"
for _ in {1..30}; do [[ ! -e "$PID_FILE" ]] && break; sleep 0.1; done
[[ ! -e "$PID_FILE" ]] || fail TC08
pass TC08
