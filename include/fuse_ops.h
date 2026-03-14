/*
 * CougFS: FUSE Integration
 *
 * Maps FUSE callbacks to CougFS operations so the filesystem
 * can be mounted and accessed using standard Linux tools.
 */

#ifndef FUSE_OPS_H
#define FUSE_OPS_H

/* Register all FUSE operations and start the FUSE event loop.
 * argc/argv should contain FUSE mount options and mountpoint. */
int cougfs_fuse_main(int argc, char *argv[], const char *disk_path);

#endif /* FUSE_OPS_H */
