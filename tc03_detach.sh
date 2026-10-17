#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/test_common.sh"
reset_runtime; start_daemon
pid=$(cat "$PID_FILE")
tty=$(ps -o tty= -p "$pid" | xargs)
[[ "$tty" == "?" ]] || fail TC03
sid=$(ps -o sid= -p "$pid" | xargs)
[[ "$sid" =~ ^[0-9]+$ ]] || fail TC03
pass TC03
cleanup_daemon
