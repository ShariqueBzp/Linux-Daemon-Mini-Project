# Viva questions and short answers

1. **What is a daemon process?**  
   A background process that performs a service without depending on an interactive terminal.

2. **Why is `fork()` used?**  
   To create a child process so the original parent can exit and return control to the shell.

3. **What does `setsid()` do?**  
   It creates a new session and makes the caller its session and process-group leader, detaching it from the controlling terminal.

4. **Why use a second `fork()`?**  
   The final process is no longer a session leader, which helps prevent it from acquiring a controlling terminal.

5. **Why redirect file descriptors 0, 1, and 2?**  
   They represent standard input, output, and error. Redirecting them to `/dev/null` prevents dependence on the terminal.

6. **What is a PID file?**  
   A file that records a process ID so tools can identify the running daemon.

7. **Why is a PID file alone insufficient for locking?**  
   A stale PID file can remain after abnormal termination. An advisory lock can coordinate instances even when the file already exists.

8. **What is `flock()` used for here?**  
   It obtains a non-blocking exclusive advisory lock so a second cooperating instance is rejected.

9. **What is the difference between `SIGTERM` and `SIGHUP` in this project?**  
   `SIGTERM` requests shutdown; `SIGHUP` requests a reload-style action.

10. **Why should a signal handler do very little?**  
    Many library functions are not async-signal-safe. This project only sets `volatile sig_atomic_t` flags in handlers.

11. **Why use `sigaction()`?**  
    It provides more explicit and reliable control over signal-handler behavior than the older `signal()` interface.

12. **How can you check terminal detachment?**  
    Inspect the process using `ps`; the TTY column should normally show `?`.

13. **How do you stop the daemon?**  
    `kill -TERM "$(cat /tmp/student_daemon.pid)"`.

14. **What happens on a duplicate launch?**  
    The second process cannot obtain the exclusive lock and exits with an error.

15. **Is double-forking always the preferred modern approach?**  
    No. On systems using `systemd`, services commonly remain in the foreground and let the service manager supervise them.
