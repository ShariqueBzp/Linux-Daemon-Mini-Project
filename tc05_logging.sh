#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/test_common.sh"
reset_runtime; start_daemon
sleep 11
grep -q "Daemon started" "$LOG_FILE" || fail TC05
[[ $(grep -c "Daemon alive" "$LOG_FILE") -ge 2 ]] || fail TC05
pass TC05
cleanup_daemon
