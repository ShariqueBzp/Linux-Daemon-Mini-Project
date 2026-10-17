#define _POSIX_C_SOURCE 200809L
#include "daemonize.h"

#include <fcntl.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

int daemonize(void)
{
    pid_t pid = fork();
    if (pid < 0)
        return -1;
    if (pid > 0)
        _exit(EXIT_SUCCESS);

    if (setsid() < 0)
        return -1;

    pid = fork();
    if (pid < 0)
        return -1;
    if (pid > 0)
        _exit(EXIT_SUCCESS);

    umask(027);
    if (chdir("/") < 0)
        return -1;

    int fd = open("/dev/null", O_RDWR);
    if (fd < 0)
        return -1;

    for (int target = STDIN_FILENO; target <= STDERR_FILENO; ++target) {
        if (dup2(fd, target) < 0) {
            if (fd > STDERR_FILENO)
                close(fd);
            return -1;
        }
    }
    if (fd > STDERR_FILENO)
        close(fd);

    return 0;
}
