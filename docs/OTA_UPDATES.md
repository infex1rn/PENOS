# PENOS OTA UPDATES

The system updates atomically using SquashFS image swapping.

## Server Layout
Updates are hosted on Cloudflare R2:
- `https://update.pen.indevstudio.dev/release/v1/version`
- `https://update.pen.indevstudio.dev/release/v1/sha256`
- `https://update.pen.indevstudio.dev/release/v1/penos.squashfs`

## Update Process
1. `pen update` checks the version file.
2. If remote > local, it downloads the squashfs to `/storage/update/penos.squashfs.tmp`.
3. It verifies the SHA256 sum.
4. On success, it renames the file to `penos.squashfs`.
5. On next boot, the `initramfs` prefers the file on `/storage`.
