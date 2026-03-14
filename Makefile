# CougFS Makefile
# WSU CPTS 360

CC      = gcc
CFLAGS  = -Wall -Wextra -Werror -std=c11 -g -I./include -D_POSIX_C_SOURCE=200809L -D_GNU_SOURCE
LDFLAGS = -lpthread

# Source files
SRC     = src/disk.c src/bitmap.c src/inode.c src/dir.c src/file.c \
          src/fs.c src/journal.c src/concurrency.c src/fuse_ops.c \
          src/shell.c src/main.c
OBJ     = $(SRC:.c=.o)
TARGET  = cougfs

# Test files
TEST_SRC = tests/test_main.c
TEST_OBJ = $(TEST_SRC:.c=.o)
TEST_BIN = test_cougfs

# Core objects (everything except main.o, for linking with tests)
CORE_OBJ = src/disk.o src/bitmap.o src/inode.o src/dir.o src/file.o \
           src/fs.o src/journal.o src/concurrency.o src/fuse_ops.o src/shell.o

# FUSE support (optional)
ifdef ENABLE_FUSE
CFLAGS  += -DENABLE_FUSE $(shell pkg-config --cflags fuse)
LDFLAGS += $(shell pkg-config --libs fuse)
endif

.PHONY: all clean test format run

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

# Run tests
test: $(TEST_BIN)
	./$(TEST_BIN)

$(TEST_BIN): $(CORE_OBJ) $(TEST_OBJ)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

# Format a new disk image and run the shell
format:
	./$(TARGET) format disk.img

run: $(TARGET)
	@if [ ! -f disk.img ]; then ./$(TARGET) format disk.img; fi
	./$(TARGET) mount disk.img

clean:
	rm -f $(OBJ) $(TEST_OBJ) $(TARGET) $(TEST_BIN) disk.img test_disk.img

# Valgrind memory check
valgrind: $(TARGET)
	valgrind --leak-check=full --show-reachable=yes ./$(TARGET) format disk.img
