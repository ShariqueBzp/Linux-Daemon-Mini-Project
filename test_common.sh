#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PID_FILE=/tmp/student_daemon.pid
LOG_FILE=/tmp/student_daemon.log
cleanup_daemon() {
    if [[ -f "$PID_FILE" ]]; then
        local pid
        pid="$(cat "$PID_FILE" 2>/dev/null || true)"
        if [[ "$pid" =~ ^[0-9]+$ ]]; then
            kill -TERM "$pid" 2>/dev/null || true
            for _ in {1..30}; do
                kill -0 "$pid" 2>/dev/null || break
                sleep 0.1
            done
        fi
    fi
}
reset_runtime() {
    cleanup_daemon
    rm -f "$PID_FILE" "$LOG_FILE"
    sleep 0.2
}
start_daemon() {
    "$ROOT_DIR/student_daemon"
    for _ in {1..30}; do
        [[ -s "$PID_FILE" ]] && break
        sleep 0.1
    done
    [[ -s "$PID_FILE" ]]
}
pass() { echo "$1 PASS"; }
fail() { echo "$1 FAIL" >&2; exit 1; }
