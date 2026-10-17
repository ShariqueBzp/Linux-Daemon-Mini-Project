#define _POSIX_C_SOURCE 200809L
#include "logger.h"
#include "config.h"

#include <fcntl.h>
#include <stdarg.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>

void log_message(const char *fmt, ...)
{
    int fd = open(LOG_FILE, O_WRONLY | O_CREAT | O_APPEND, 0640);
    if (fd < 0)
        return;

    char buf[LOG_BUF_SIZE];
    time_t now = time(NULL);
    struct tm tm_info;
    char timestamp[64] = "unknown-time";

    if (localtime_r(&now, &tm_info) != NULL)
        (void)strftime(timestamp, sizeof(timestamp), "%Y-%m-%d %H:%M:%S", &tm_info);

    int prefix_len = snprintf(buf, sizeof(buf), "%s | PID=%ld | ",
                              timestamp, (long)getpid());
    if (prefix_len < 0 || (size_t)prefix_len >= sizeof(buf)) {
        close(fd);
        return;
    }

    va_list ap;
    va_start(ap, fmt);
    int msg_len = vsnprintf(buf + prefix_len, sizeof(buf) - (size_t)prefix_len, fmt, ap);
    va_end(ap);

    if (msg_len < 0) {
        close(fd);
        return;
    }

    size_t used = (size_t)prefix_len + (size_t)msg_len;
    if (used >= sizeof(buf) - 1)
        used = sizeof(buf) - 2;
    buf[used++] = '\n';

    size_t offset = 0;
    while (offset < used) {
        ssize_t n = write(fd, buf + offset, used - offset);
        if (n <= 0)
            break;
        offset += (size_t)n;
    }
    close(fd);
}
