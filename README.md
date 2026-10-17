# Linux Daemon Mini-Project — `student_daemon`

A modular Linux systems-programming mini-project written in C. It demonstrates the traditional UNIX daemonization sequence, timestamped file logging, PID-file locking, POSIX signal handling, graceful shutdown, cleanup, and restart behavior.

## Project goals

- Detach from the launching terminal and continue in the background.
- Use the traditional `fork()` → `setsid()` → `fork()` daemonization sequence.
- Redirect standard input, output, and error to `/dev/null`.
- Record a PID in `/tmp/student_daemon.pid`.
- Prevent a second instance with an advisory `flock()` lock.
- Append timestamped events to `/tmp/student_daemon.log`.
- Handle `SIGHUP` as a reload request and `SIGTERM` as a graceful shutdown request.
- Remove the PID file on clean shutdown.
- Provide shell-based acceptance tests.

## Concepts demonstrated

`fork`, process hierarchy, sessions and session IDs, process groups, controlling terminals, file descriptors, `open`, `dup2`, `umask`, `chdir`, `flock`, PID files, `sigaction`, `volatile sig_atomic_t`, timestamps, `write`, `sleep`, Makefiles, Bash test automation, and Linux process-inspection commands.

## Repository structure

```text
Linux-Daemon-Mini-Project/
├── include/
│   └── config.h
├── src/
│   ├── main.c
│   ├── daemonize.c
│   ├── daemonize.h
│   ├── logger.c
│   ├── logger.h
│   ├── pidlock.c
│   ├── pidlock.h
│   ├── signals.c
│   └── signals.h
├── tests/
│   ├── run_all_tests.sh
│   ├── tc01_compile.sh
│   ├── tc02_parent_exit.sh
│   ├── tc03_detach.sh
│   ├── tc04_pid_file.sh
│   ├── tc05_logging.sh
│   ├── tc06_sighup.sh
│   ├── tc07_sigterm.sh
│   ├── tc08_pid_cleanup.sh
│   ├── tc09_duplicate.sh
│   ├── tc10_restart.sh
│   └── tc11_failures.sh
├── docs/
│   ├── ARCHITECTURE.md
│   ├── TESTING.md
│   ├── VIVA.md
├── Makefile
├── .gitignore
├── LICENSE
└── README.md
```

## Requirements

- Linux (or WSL 2 running a Linux distribution)
- GCC
- GNU Make
- Bash and standard Linux utilities (`ps`, `grep`, `sleep`, `kill`, `tail`, `awk`)

## Build

```bash
make clean
make
```

The compiler flags enable common warnings (`-Wall -Wextra -Wpedantic`) and use C11. A successful build should finish without warnings or errors.

## Run and inspect

Start the daemon:

```bash
./student_daemon
```

The command should return promptly. The daemon runs independently in the background.

Read its PID and inspect process/session information:

```bash
cat /tmp/student_daemon.pid
ps -o pid,ppid,pgid,sid,tty,stat,cmd -p "$(cat /tmp/student_daemon.pid)"
```

A `TTY` value of `?` indicates that the process has no controlling terminal.

Watch the log:

```bash
tail -f /tmp/student_daemon.log
```

Send a reload request:

```bash
kill -HUP "$(cat /tmp/student_daemon.pid)"
```

Request graceful shutdown:

```bash
kill -TERM "$(cat /tmp/student_daemon.pid)"
```

After shutdown, the PID file should be removed. The log file is intentionally retained for inspection.

## Automated tests

Run the test suite from the repository root:

```bash
make test
```

The suite checks compilation, prompt return, terminal detachment, PID correctness, periodic logging, SIGHUP handling, SIGTERM shutdown, PID cleanup, duplicate-instance rejection, restart, and selected failure paths.

> Tests create and remove `/tmp/student_daemon.pid` and `/tmp/student_daemon.log`. Run them only when you do not have another copy of this demo running. The scripts are designed for a local Linux/WSL development environment.

## Runtime files

| Path | Purpose |
|---|---|
| `/tmp/student_daemon.pid` | PID file and advisory lock |
| `/tmp/student_daemon.log` | Timestamped event log |

The PID file is transient runtime state and should not be committed to Git.

## Signal behavior

- `SIGHUP`: sets a flag in the signal handler; the main loop logs a reload-request message.
- `SIGTERM`: sets a stop flag; the main loop logs shutdown, removes the PID file, and exits.

The handlers intentionally do not perform file I/O. They only update `volatile sig_atomic_t` flags; normal work happens in the main loop.

## Design notes and limitations

- This is an educational daemonization example, not a production service manager.
- The program uses traditional double-fork daemonization. On modern Linux systems, a `systemd`-managed foreground service is often preferable.
- The lock is advisory and works when other cooperating instances use the same lock file.
- Runtime paths are fixed under `/tmp` for classroom convenience. A real service should use an appropriate service-owned runtime/log directory and restrictive permissions.
- If startup fails after detachment, errors may only be visible in the log when logging is already available.
- The automated suite is intended for a disposable development environment; review scripts before running them on a shared machine.

## Learning outcomes

After studying this project, a learner should be able to explain the daemonization sequence, inspect process/session metadata, describe advisory locking, distinguish signal handlers from main-loop work, and demonstrate predictable startup and shutdown behavior.

## Reference documents

The `docs/original-pdfs/` directory contains the supplied project procedure and solution/report PDFs as reference material. The implementation in this repository is organized into maintainable source files and shell tests.

## License

MIT — see [LICENSE](LICENSE).
