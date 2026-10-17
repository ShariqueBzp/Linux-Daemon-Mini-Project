CC       := gcc
CFLAGS   := -Wall -Wextra -Wpedantic -O2 -std=c11 -Iinclude
TARGET   := student_daemon
SOURCES  := src/main.c src/daemonize.c src/logger.c src/pidlock.c src/signals.c
OBJECTS  := $(SOURCES:.c=.o)

.PHONY: all clean test
all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) $(CFLAGS) $(OBJECTS) -o $@

src/%.o: src/%.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJECTS) $(TARGET)

test: $(TARGET)
	chmod +x tests/*.sh
	./tests/run_all_tests.sh
