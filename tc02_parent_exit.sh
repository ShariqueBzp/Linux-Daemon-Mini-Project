#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/test_common.sh"
reset_runtime
start=$(date +%s)
start_daemon
elapsed=$(( $(date +%s) - start ))
(( elapsed <= 2 )) || fail TC02
pass TC02
cleanup_daemon
