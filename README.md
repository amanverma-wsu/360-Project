# CougFS: A User-Space Unix-Like File System

**WSU CPTS 360 - Systems Programming**

A complete, production-oriented Unix-like file system implemented in C that runs entirely in user space using a virtual disk image file (`disk.img`).

## Features

- **Superblock management** and filesystem initialization
- **Inode table** implementation with file metadata tracking
- **Block allocation/deallocation** using bitmaps
- **File operations**: create, read, write, delete, truncate, seek
- **Directory operations**: create, list, navigate, remove
- **Thread-safe concurrent access** using POSIX reader/writer locks
- **Crash recovery** using write-ahead journaling
- **FUSE integration** for mounting with standard Linux tools
- **Interactive shell** with Unix-like commands

## Building

```bash
make            # Build the main binary
make test       # Build and run tests
make clean      # Remove build artifacts
```

### With FUSE support (optional)

```bash
sudo apt-get install libfuse-dev
make ENABLE_FUSE=1
```

## Usage

### Format a new filesystem
```bash
./cougfs format disk.img
```

### Mount and use interactive shell
```bash
./cougfs mount disk.img
```

### Mount via FUSE (if compiled with FUSE support)
```bash
mkdir /tmp/cougfs
./cougfs fuse disk.img /tmp/cougfs
# Use standard tools: ls, cp, cat, etc.
fusermount -u /tmp/cougfs
```

## Shell Commands

| Command | Description |
|---------|-------------|
| `ls [path]` | List directory contents |
| `cd [path]` | Change directory |
| `pwd` | Print working directory |
| `mkdir <name>` | Create directory |
| `rmdir <name>` | Remove empty directory |
| `touch <name>` | Create empty file |
| `cat <name>` | Display file contents |
| `write <name> <text>` | Write text to file |
| `rm <name>` | Delete file |
| `stat <name>` | Show file/directory info |
| `truncate <name> <size>` | Truncate file to size |
| `info` | Show filesystem info |
| `help` | Show available commands |
| `quit` | Exit shell |

## Disk Layout

| Blocks | Purpose |
|--------|---------|
| 0 | Superblock |
| 1 | Inode bitmap |
| 2 | Data block bitmap |
| 3-10 | Inode table (256 inodes) |
| 11-18 | Journal area |
| 19-4095 | Data blocks |

## Architecture

```
include/            Header files
  cougfs.h          Core data structures (superblock, inode, dir entry)
  disk.h            Disk I/O layer
  bitmap.h          Block/inode bitmap operations
  inode.h           Inode operations
  dir.h             Directory operations
  file.h            File operations
  fs.h              Filesystem init/mount
  journal.h         Journaling/crash recovery
  concurrency.h     Thread-safe locking
  fuse_ops.h        FUSE integration

src/                Implementation files
tests/              Test suite
```

## Technical Stack

- **Language**: C (C11)
- **OS**: Linux
- **Compiler**: GCC
- **Libraries**: POSIX system calls, pthread, FUSE (optional)
- **Tools**: Make, Valgrind, GDB, GitHub Actions

## Team

| Name | Role |
|------|------|
| Aman Verma | Core FS Engine |
| Tony Cao | Concurrency Layer |
| Srishanth Reddy Surakanti | Journaling |
| Alan Qiu | FUSE Integration |
