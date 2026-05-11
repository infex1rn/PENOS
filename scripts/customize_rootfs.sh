#!/bin/sh
set -e

# Setup repositories
echo "http://dl-cdn.alpinelinux.org/alpine/v3.19/main" > /etc/apk/repositories
echo "http://dl-cdn.alpinelinux.org/alpine/v3.19/community" >> /etc/apk/repositories

# Update and install packages - The "Good Stuff" (Optimized for size)
apk update
apk add bash openrc busybox curl git nano openssh-client htop blkid linux-virt squashfs-tools e2fsprogs \
    fzf neofetch ncurses sudo util-linux

# Remove documentation and other bloat to stay under 100MB
rm -rf /usr/share/man/*
rm -rf /usr/share/doc/*
rm -rf /usr/share/info/*
rm -rf /usr/share/icons/*
rm -rf /usr/lib/modules/*/kernel/drivers/net/wireless
rm -rf /usr/lib/modules/*/kernel/drivers/gpu

# Copy PENOS System Features
cp -r /tmp/system/bin/* /usr/local/bin/
chmod +x /usr/local/bin/pen*
mkdir -p /etc/penos
cp -r /tmp/system/etc/* /etc/penos/
cp /tmp/system/skel/.bashrc /root/
cp /tmp/system/skel/.nanorc /root/
cp /tmp/system/skel/.vimrc /root/

# Install Starship Prompt (Visual Overhaul)
curl -sS https://starship.rs/install.sh | sh -s -- -y

# Configure Shell
sed -i 's|/bin/sh|/bin/bash|g' /etc/passwd

# Auto-login configuration
sed -i 's|tty1::respawn:/sbin/getty 38400 tty1|tty1::respawn:/sbin/getty --autologin root --noclear 38400 tty1|g' /etc/inittab

# Set hostname
echo "penos" > /etc/hostname

# Link storage
mkdir -p /storage
ln -sf /storage /root/storage

# Create OpenRC service for persistence
cat << 'EOF' > /etc/init.d/penos-persistence
#!/sbin/openrc-run
description="Mount PENOS persistent storage"
depend() { need devfs; after devfs; }
start() {
    ebegin "Mounting PENOS persistence"
    /usr/local/bin/pen-mount || /bin/true
    eend $?
}
EOF
chmod +x /etc/init.d/penos-persistence
rc-update add penos-persistence default

# Clean up
rm -rf /var/cache/apk/*
rm -rf /tmp/system
