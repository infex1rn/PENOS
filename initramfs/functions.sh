# Shared initramfs functions
mount_dev() {
    mount -t proc proc /proc
    mount -t sysfs sysfs /sys
    mount -t devtmpfs devtmpfs /dev
}

find_squashfs() {
    # Logic to find squashfs moved here for modularity
    return 0
}
