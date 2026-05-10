# ARCHITECTURE OF PENOS

PENOS is a layered Linux distribution optimized for virtualized ARM64 environments.

## Layer 1: Bootloader (GRUB EFI)
- The ISO uses a FAT-formatted EFI partition (`efiboot.img`).
- `BOOTAA64.EFI` is generated via `grub-mkstandalone`.

## Layer 2: Initramfs (Early Boot)
- A minimal cpio archive containing busybox and the `init` script.
- Handles discovery and mounting of the system SquashFS.
- Prioritizes `/storage/update/penos.squashfs` if present.

## Layer 3: System Image (SquashFS)
- A read-only XZ-compressed Alpine RootFS.
- Contains the core OS, Starship prompt, and developer tools.

## Layer 4: Persistence (qcow2)
- Mounted at `/storage`.
- Linked to `/root/storage` for user data survival.
