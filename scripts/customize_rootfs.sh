#!/bin/sh
set -e

# Setup repositories
echo "http://dl-cdn.alpinelinux.org/alpine/v3.19/main" > /etc/apk/repositories
echo "http://dl-cdn.alpinelinux.org/alpine/v3.19/community" >> /etc/apk/repositories

# Update and install packages - The "Good Stuff"
apk update
apk add bash openrc busybox curl git nano openssh-client htop blkid linux-virt squashfs-tools e2fsprogs \
    fzf bat eza zoxide neofetch ncurses sudo util-linux grub-efi grub

# Set bash as default shell for root
sed -i 's/\/bin\/ash/\/bin\/bash/g' /etc/passwd

# Install Starship Prompt (Visual Overhaul)
curl -sS https://starship.rs/install.sh | sh -s -- -y
echo 'eval "$(starship init bash)"' >> /root/.bashrc
echo 'eval "$(zoxide init bash)"' >> /root/.bashrc

# Modern Aliases for "Animations" and Speed
cat << 'EOF' >> /root/.bashrc
alias ls='eza --icons --group-directories-first'
alias cat='bat --style=plain --paging=never'
alias top='htop'
alias cd='z'
alias help='pen help'

# Custom Login "Animation" / Splash
clear
neofetch
echo -e "\e[1;34m»»» PENOS v0.1 DEV EDITION ACTIVATED «««\e[0m"
EOF

# Colorized "pen" wrapper with feedback
cat << 'EOF' > /usr/local/bin/pen
#!/bin/bash
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

case "$1" in
    install)
        shift
        echo -e "${BLUE} Installing packages...${NC}"
        apk add "$@"
        ;;
    remove)
        shift
        echo -e "${BLUE}﫭 Removing packages...${NC}"
        apk del "$@"
        ;;
    update)
        echo -e "${BLUE}累 Updating system...${NC}"
        apk update && apk upgrade
        ;;
    *)
        echo -e "${GREEN}PENOS PORTABLE TERMINAL${NC}"
        echo "Usage: pen [install|remove|update] [packages]"
        ;;
esac
EOF
chmod +x /usr/local/bin/pen


# Persistence setup script
cat << 'EOF' > /usr/local/bin/mount-persistence
#!/bin/bash
# Find the vdb disk (usually the second disk in UTM)
DISK="/dev/vdb"
MOUNT_POINT="/storage"

if [ -b "$DISK" ]; then
    mkdir -p $MOUNT_POINT
    # Check if it has a filesystem, if not format it ext4
    if ! blkid $DISK > /dev/null; then
        echo "Formatting $DISK as ext4..."
        mkfs.ext4 $DISK
    fi
    mount $DISK $MOUNT_POINT
    echo "Persistent storage mounted at $MOUNT_POINT"
else
    echo "Persistent storage disk not found."
fi
EOF
chmod +x /usr/local/bin/mount-persistence

# Create OpenRC service for persistence
cat << 'EOF' > /etc/init.d/penos-persistence
#!/sbin/openrc-run

description="Mount PENOS persistent storage"

depend() {
    need devfs
    after devfs
}

start() {
    ebegin "Mounting PENOS persistence"
    /usr/local/bin/mount-persistence
    eend $?
}
EOF
chmod +x /etc/init.d/penos-persistence
rc-update add penos-persistence default

# Clean up
rm -rf /var/cache/apk/*
