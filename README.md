# Linux-Daemon-Mini-Project
A robust, production-grade traditional Linux daemon written in C, featuring double-fork detachment, flock() single-instance locking, signal handling (SIGTERM/SIGHUP), and an automated 11-test suite.
# Linux Daemon Mini-Project (`student_daemon`)

[![Platform](https://img.shields.io/badge/Platform-Linux-blue.svg)](https://www.kernel.org/)
[![Language](https://img.shields.io/badge/Language-C-orange.svg)](https://en.wikipedia.org/wiki/C_(programming_language))
[![Tests Passed](https://img.shields.io/badge/Tests-11%2F11%20Passed-success.svg)]()

A robust, production-grade traditional UNIX daemon written in C for the Systems Programming Laboratory. It demonstrates background process detachment, safe single-instance locking via file descriptors, signal-driven control flows, timestamped logging, and automated shell-driven testing.

---

## 🚀 Key Features

* **Canonical Double-Fork Daemonization**: Detaches entirely from the controlling terminal and session leader.
* **Advisory Instance Locking**: Uses `flock()` on `/tmp/student_daemon.pid` to prevent accidental duplicate instances while gracefully handling stale PID files from crashes.
* **Signal Handling (`SIGTERM` & `SIGHUP`)**: 
  * `SIGTERM`: Triggers graceful cleanup, removes the PID file, and safely terminates.
  * `SIGHUP`: Triggers a configuration reload signal flag.
* **Timestamped Audit Logging**: Periodically appends structured, thread-safe logs (`Daemon alive`) to `/tmp/student_daemon.log`.
* **Automated Test Suite**: Includes 11 comprehensive shell script test drivers (`tc01` through `tc11`) verifying both success and failure paths.

---

## 📁 Project Architecture

```text
Linux-Daemon-Mini-Project/
├── Makefile
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
│   ├── test_common.sh
│   └── tc01_compile.sh to tc11_failures.sh
└── docs/
    ├── ARCHITECTURE.md
    ├── TESTING.md
    ├── VIVA.md
    └── original-pdfs/
