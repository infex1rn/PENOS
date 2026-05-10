#!/bin/bash
set -e

# Configuration
ALPINE_VERSION="3.19.1"
ALPINE_ARCH="aarch64"
ROOTFS_URL="https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION%.*}/releases/${ALPINE_ARCH}/alpine-minirootfs-${ALPINE_VERSION}-${ALPINE_ARCH}.tar.gz"

WORKDIR="$(pwd)/build"
OUTDIR="$(pwd)/out"
ROOTFS_DIR="${WORKDIR}/rootfs"
ISO_DIR="${WORKDIR}/iso"

# Create directories
mkdir -p "${WORKDIR}" "${OUTDIR}" "${ROOTFS_DIR}" "${ISO_DIR}"

# Download Alpine Mini RootFS
download_rootfs() {
    if [ ! -f "${WORKDIR}/alpine-minirootfs.tar.gz" ]; then
        echo "Downloading Alpine Mini RootFS..."
        curl -L "${ROOTFS_URL}" -o "${WORKDIR}/alpine-minirootfs.tar.gz"
    fi
}

# Extract RootFS
extract_rootfs() {
    echo "Extracting RootFS..."
    sudo tar -xzf "${WORKDIR}/alpine-minirootfs.tar.gz" -C "${ROOTFS_DIR}"
}

# Setup QEMU for ARM64 customization
setup_qemu() {
    echo "Setting up QEMU for ARM64..."
    sudo apt update && sudo apt install -y qemu-user-static
    sudo cp /usr/bin/qemu-aarch64-static "${ROOTFS_DIR}/usr/bin/"
}

# Main execution
download_rootfs
extract_rootfs
setup_qemu

# Customize RootFS
echo "Customizing RootFS..."
sudo cp /etc/resolv.conf "${ROOTFS_DIR}/etc/resolv.conf"
sudo cp scripts/customize_rootfs.sh "${ROOTFS_DIR}/customize.sh"
sudo chmod +x "${ROOTFS_DIR}/customize.sh"
sudo chroot "${ROOTFS_DIR}" /bin/sh /customize.sh
sudo rm "${ROOTFS_DIR}/customize.sh"

create_squashfs() {
    echo "Creating squashfs image..."
    sudo apt install -y squashfs-tools
    sudo rm -f "${WORKDIR}/penos.squashfs"
    sudo mksquashfs "${ROOTFS_DIR}" "${WORKDIR}/penos.squashfs" -comp xz -e usr/bin/qemu-aarch64-static
}

# Prepare ISO structure
prepare_iso() {
    echo "Preparing ISO structure..."
    mkdir -p "${ISO_DIR}/boot/grub"
    sudo cp "${WORKDIR}/penos.squashfs" "${ISO_DIR}/"
    
    # Copy kernel from rootfs
    KERNEL_PATH=$(ls "${ROOTFS_DIR}/boot/vmlinuz-virt")
    sudo cp "${KERNEL_PATH}" "${ISO_DIR}/boot/vmlinuz"
    
    # Create a simple initramfs
    echo "Creating custom initramfs..."
    INITRAMFS_WORKDIR="${WORKDIR}/initramfs_content"
    rm -rf "${INITRAMFS_WORKDIR}"
    mkdir -p "${INITRAMFS_WORKDIR}"
    cd "${INITRAMFS_WORKDIR}"
    mkdir -p bin dev proc sys mnt/iso root
    # Copy busybox
    cp "${ROOTFS_DIR}/bin/busybox" bin/
    ln -sf busybox bin/sh
    ln -sf busybox bin/mount
    ln -sf busybox bin/switch_root
    
    cat << 'EOF' > init
#!/bin/sh
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev

echo "Checking for PENOS persistence and updates..."
# Try to mount the persistent storage disk (/dev/vdb)
mkdir -p /mnt/storage
if mount /dev/vdb /mnt/storage 2>/dev/null; then
    if [ -f /mnt/storage/update/penos.squashfs ]; then
        echo ">>> OTA Update Found: Loading system from persistent storage..."
        if mount -t squashfs -o loop /mnt/storage/update/penos.squashfs /root; then
            echo "Update mounted successfully."
            # Move the storage mount to the new rootfs so it's ready after switch_root
            mkdir -p /root/storage
            mount --move /mnt/storage /root/storage
            echo "Switching to updated rootfs..."
            exec switch_root /root /sbin/init
        else
            echo "!!! ERROR: Failed to mount update. Falling back to ISO..."
        fi
    fi
    umount /mnt/storage
fi

echo "Searching for PENOS squashfs on ISO..."
# Fallback: Search for the device with penos.squashfs (ISO)
for dev in /dev/sr0 /dev/vda; do
    if mount -r $dev /mnt/iso 2>/dev/null; then
        if [ -f /mnt/iso/penos.squashfs ]; then
            echo "Found base system on $dev"
            break
        fi
        umount /mnt/iso
    fi
done

if [ ! -f /mnt/iso/penos.squashfs ]; then
    echo "!!! CRITICAL ERROR: Could not find any PENOS system image!"
    sh
fi

mount -t squashfs -o loop /mnt/iso/penos.squashfs /root

echo "Switching to base rootfs..."
exec switch_root /root /sbin/init
EOF
    chmod +x init
    find . | cpio -H newc -o | gzip > "${ISO_DIR}/boot/initramfs"
    cd -

    # Create GRUB configuration
    cat << 'EOF' > "${ISO_DIR}/boot/grub/grub.cfg"
set default=0
set timeout=1

menuentry "PENOS" {
    linux /boot/vmlinuz quiet
    initrd /boot/initramfs
}
EOF
}

create_iso() {
    echo "Creating ISO image..."
    # We need mtools and xorriso on the host
    sudo apt install -y mtools xorriso
    
    # Create EFI boot image using chroot (since it has the ARM64 grub modules)
    sudo cp "${ISO_DIR}/boot/grub/grub.cfg" "${ROOTFS_DIR}/tmp/grub.cfg"
    sudo chroot "${ROOTFS_DIR}" grub-mkstandalone -O arm64-efi -o /tmp/bootaa64.efi "boot/grub/grub.cfg=/tmp/grub.cfg"
    sudo cp "${ROOTFS_DIR}/tmp/bootaa64.efi" "${ISO_DIR}/boot/grub/bootaa64.efi"
    
    # Create a small FAT image for EFI
    mkdir -p "${WORKDIR}/efi_img/EFI/BOOT"
    cp "${ISO_DIR}/boot/grub/bootaa64.efi" "${WORKDIR}/efi_img/EFI/BOOT/BOOTAA64.EFI"
    dd if=/dev/zero of="${WORKDIR}/efiboot.img" bs=1M count=10
    mkfs.vfat "${WORKDIR}/efiboot.img"
    mcopy -i "${WORKDIR}/efiboot.img" -s "${WORKDIR}/efi_img/EFI" ::
    
    # Copy efiboot.img to ISO dir so xorriso can find it
    cp "${WORKDIR}/efiboot.img" "${ISO_DIR}/boot/grub/efiboot.img"

    xorriso -as mkisofs \
        -R -l \
        -eltorito-boot boot/grub/efiboot.img \
        -no-emul-boot \
        -append_partition 2 0xef "${WORKDIR}/efiboot.img" \
        -partition_offset 16 \
        -o "${OUTDIR}/penos.iso" \
        "${ISO_DIR}"
}

create_squashfs
prepare_iso
create_iso

echo "PENOS ISO created at ${OUTDIR}/penos.iso"
