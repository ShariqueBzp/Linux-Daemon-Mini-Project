#define _POSIX_C_SOURCE 200809L
#include "pidlock.h"
#include "config.h"

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <sys/file.h>
#include <unistd.h>

static int g_fd = -1;

int pidlock_acquire(void)
{
    g_fd = open(PID_FILE, O_RDWR | O_CREAT, 0640);
    if (g_fd < 0)
        return -1;

    if (flock(g_fd, LOCK_EX | LOCK_NB) < 0) {
        int saved_errno = errno;
        close(g_fd);
        g_fd = -1;
        if (saved_errno == EWOULDBLOCK || saved_errno == EAGAIN)
            return 1;
        errno = saved_errno;
        return -1;
    }
    return 0;
}

int pidlock_write(void)
{
    if (g_fd < 0) {
        errno = EBADF;
        return -1;
    }
    if (ftruncate(g_fd, 0) < 0)
        return -1;
    if (lseek(g_fd, 0, SEEK_SET) < 0)
        return -1;

    char buf[32];
    int n = snprintf(buf, sizeof(buf), "%ld\n", (long)getpid());
    if (n <= 0 || (size_t)n >= sizeof(buf)) {
        errno = EOVERFLOW;
        return -1;
    }

    ssize_t written = write(g_fd, buf, (size_t)n);
    if (written != n)
        return -1;
    return fsync(g_fd);
}

void pidlock_release(void)
{
    if (g_fd < 0)
        return;

    /* Keep the lock held while removing the path to reduce startup races. */
    (void)unlink(PID_FILE);
    close(g_fd);
    g_fd = -1;
}
