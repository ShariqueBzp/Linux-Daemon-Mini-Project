#define _POSIX_C_SOURCE 200809L
#include "config.h"
#include "daemonize.h"
#include "logger.h"
#include "pidlock.h"
#include "signals.h"

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main(void)
{
    /* Acquire the lock before detaching so startup errors reach the terminal. */
    int rc = pidlock_acquire();
    if (rc == 1) {
        fprintf(stderr, "student_daemon: already running.\n");
        return EXIT_FAILURE;
    }
    if (rc < 0) {
        fprintf(stderr, "student_daemon: cannot open PID file: %s\n", strerror(errno));
        return EXIT_FAILURE;
    }

    if (daemonize() < 0) {
        int saved_errno = errno;
        pidlock_release();
        errno = saved_errno;
        return EXIT_FAILURE;
    }

    if (pidlock_write() < 0) {
        log_message("pidlock_write() failed: %s", strerror(errno));
        pidlock_release();
        return EXIT_FAILURE;
    }

    if (signals_install() < 0) {
        log_message("signals_install() failed: %s", strerror(errno));
        pidlock_release();
        return EXIT_FAILURE;
    }

    log_message("Daemon started");

    while (signals_running()) {
        if (signals_take_reload())
            log_message("SIGHUP received - configuration reload requested");

        log_message("Daemon alive");
        for (int i = 0; i < SLEEP_INTERVAL && signals_running(); ++i) {
            sleep(1);
            /* Handle SIGHUP promptly even when it arrives during the wait. */
            if (signals_take_reload())
                log_message("SIGHUP received - configuration reload requested");
        }
    }

    log_message("SIGTERM received - Daemon shutting down");
    pidlock_release();
    log_message("Daemon stopped");
    return EXIT_SUCCESS;
}
