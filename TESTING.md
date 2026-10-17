# Testing guide

Run all tests from the repository root:

```bash
make test
```

The scripts are:

| Test | Purpose |
|---|---|
| TC01 | Clean compile |
| TC02 | Launch returns promptly |
| TC03 | No controlling terminal |
| TC04 | PID file contains a live daemon PID |
| TC05 | Periodic log entries |
| TC06 | SIGHUP is logged and daemon survives |
| TC07 | SIGTERM triggers graceful shutdown |
| TC08 | PID file removed on shutdown |
| TC09 | Second instance rejected |
| TC10 | Clean restart works |
| TC11 | PID path failure is handled predictably |

## Manual test commands

```bash
make clean && make
./student_daemon
PID=$(cat /tmp/student_daemon.pid)
ps -o pid,ppid,pgid,sid,tty,stat,cmd -p "$PID"
tail /tmp/student_daemon.log
kill -HUP "$PID"
sleep 1
tail -n 5 /tmp/student_daemon.log
kill -TERM "$PID"
sleep 1
test ! -e /tmp/student_daemon.pid && echo "PID cleanup OK"
```

## Caution

The tests use fixed `/tmp` paths. Do not run the suite concurrently with another instance or on a shared environment where those paths belong to another experiment. Review the test scripts before running them.
