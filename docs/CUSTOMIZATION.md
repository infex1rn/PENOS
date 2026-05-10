# CUSTOMIZING PENOS

You can create your own PENOS flavors by modifying the rootfs.

1. Run `./scripts/build_iso.sh` up to the customization step.
2. Modify `scripts/customize_rootfs.sh` to add your packages.
3. Re-run the build.

Alternatively, to modify the existing ISO:
1. Extract with `xorriso`.
2. Unsquash the `penos.squashfs`.
3. Chroot and modify.
4. Re-squash and re-master.
