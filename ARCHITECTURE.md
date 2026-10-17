# Architecture and module responsibilities

## Execution flow

1. `main()` acquires the PID-file lock before detaching. This allows duplicate-start and PID-path errors to be printed to the terminal.
2. `daemonize()` performs the traditional double-fork sequence, creates a new session, sets the file-creation mask, changes directory, and redirects standard descriptors.
3. `pidlock_write()` writes the final daemon PID while the lock remains held.
4. `signals_install()` installs `sigaction()` handlers for `SIGTERM` and `SIGHUP`.
5. The main loop processes reload requests, appends a heartbeat log entry, and sleeps in one-second slices so shutdown can be noticed promptly.
6. On `SIGTERM`, the loop exits, writes shutdown messages, unlinks the PID file, closes the lock descriptor, and exits.

## Module map

| File | Responsibility |
|---|---|
| `include/config.h` | Runtime paths, heartbeat interval, log buffer size |
| `src/main.c` | Startup orchestration and main loop |
| `src/daemonize.c` / `.h` | Process detachment |
| `src/logger.c` / `.h` | Timestamped append-only log records |
| `src/pidlock.c` / `.h` | PID file and advisory `flock()` lock |
| `src/signals.c` / `.h` | Signal flags and `sigaction()` setup |
| `tests/*.sh` | Acceptance checks |

## Daemonization concepts

- First `fork()`: the original parent exits.
- `setsid()`: creates a new session and detaches from the controlling terminal.
- Second `fork()`: the final daemon is not a session leader, reducing the possibility of acquiring a controlling terminal.
- `umask(027)`: establishes a restrictive inherited file-creation mask.
- `chdir("/")`: avoids retaining a mounted or otherwise inconvenient working directory.
- `dup2()` with `/dev/null`: prevents the daemon from relying on the launching terminal.

## Signal-safety design

The handlers only modify `volatile sig_atomic_t` flags. Logging and cleanup happen in ordinary program flow, not in the asynchronous signal handlers.
