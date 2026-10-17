#ifndef STUDENT_DAEMON_LOGGER_H
#define STUDENT_DAEMON_LOGGER_H

void log_message(const char *fmt, ...)
    __attribute__((format(printf, 1, 2)));

#endif
