#define _POSIX_C_SOURCE 200809L
#include "signals.h"

#include <signal.h>
#include <string.h>

static volatile sig_atomic_t g_running = 1;
static volatile sig_atomic_t g_reload_requested = 0;

static void on_sigterm(int sig)
{
    (void)sig;
    g_running = 0;
}

static void on_sighup(int sig)
{
    (void)sig;
    g_reload_requested = 1;
}

int signals_install(void)
{
    struct sigaction sa;
    memset(&sa, 0, sizeof(sa));
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = 0;

    sa.sa_handler = on_sigterm;
    if (sigaction(SIGTERM, &sa, NULL) < 0)
        return -1;

    sa.sa_handler = on_sighup;
    if (sigaction(SIGHUP, &sa, NULL) < 0)
        return -1;

    return 0;
}

int signals_running(void)
{
    return g_running != 0;
}

int signals_take_reload(void)
{
    if (g_reload_requested) {
        g_reload_requested = 0;
        return 1;
    }
    return 0;
}
