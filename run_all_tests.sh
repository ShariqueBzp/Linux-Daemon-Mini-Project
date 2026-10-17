#!/usr/bin/env bash
set -uo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"
scripts=(tc01_compile.sh tc02_parent_exit.sh tc03_detach.sh tc04_pid_file.sh tc05_logging.sh tc06_sighup.sh tc07_sigterm.sh tc08_pid_cleanup.sh tc09_duplicate.sh tc10_restart.sh tc11_failures.sh)
passed=0
failed=0
for script in "${scripts[@]}"; do
    echo "==============================================================="
    echo "Running $script"
    if bash "tests/$script"; then ((passed+=1)); else ((failed+=1)); echo "$script FAILED"; fi
done
echo "==============================================================="
echo "Summary: $passed passed, $failed failed"
[[ $failed -eq 0 ]]
