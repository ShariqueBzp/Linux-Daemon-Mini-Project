#ifndef STUDENT_DAEMON_PIDLOCK_H
#define STUDENT_DAEMON_PIDLOCK_H

/* 0 = acquired, 1 = another instance holds the lock, -1 = error. */
int pidlock_acquire(void);
int pidlock_write(void);
void pidlock_release(void);

#endif
