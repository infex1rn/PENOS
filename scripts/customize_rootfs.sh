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

# Set initial PENOS version
echo "0.1.0" > /etc/penos-version

# Colorized "pen" wrapper with production-grade update logic
cat << 'EOF' > /usr/local/bin/pen
#!/bin/bash
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

UPDATE_SERVER="https://update.pen.indevstudio.dev/release/v1"
VERSION_FILE="/etc/penos-version"
UPDATE_DIR="/storage/update"
CURRENT_VERSION=$(cat $VERSION_FILE)

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
        echo -e "${BLUE}累 Updating package index...${NC}"
        apk update && apk upgrade
        
        echo -e "${BLUE}累 Checking for PENOS system updates...${NC}"
        REMOTE_VERSION=$(curl -sSf "${UPDATE_SERVER}/version" 2>/dev/null)
        
        if [ -z "$REMOTE_VERSION" ]; then
            echo -e "${RED}Error: Could not reach update server.${NC}"
            exit 1
        fi

        if [ "$REMOTE_VERSION" == "$CURRENT_VERSION" ]; then
            echo -e "${GREEN}PENOS is already up to date ($CURRENT_VERSION).${NC}"
            exit 0
        fi

        echo -e "${BLUE}New version available: $REMOTE_VERSION (Current: $CURRENT_VERSION)${NC}"
        read -p "Do you want to update? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 0
        fi

        mkdir -p "$UPDATE_DIR"
        echo -e "${BLUE}Downloading update...${NC}"
        curl -L "${UPDATE_SERVER}/penos.squashfs" -o "${UPDATE_DIR}/penos.squashfs.tmp"
        
        echo -e "${BLUE}Verifying integrity...${NC}"
        REMOTE_HASH=$(curl -sSf "${UPDATE_SERVER}/sha256" | awk '{print $1}')
        LOCAL_HASH=$(sha256sum "${UPDATE_DIR}/penos.squashfs.tmp" | awk '{print $1}')

        if [ "$REMOTE_HASH" != "$LOCAL_HASH" ]; then
            echo -e "${RED}Verification FAILED! Checksum mismatch.${NC}"
            rm "${UPDATE_DIR}/penos.squashfs.tmp"
            exit 1
        fi

        echo -e "${GREEN}Verification successful. Applying update...${NC}"
        mv "${UPDATE_DIR}/penos.squashfs.tmp" "${UPDATE_DIR}/penos.squashfs"
        
        echo -e "${GREEN}Update applied! Please reboot to start using PENOS $REMOTE_VERSION.${NC}"
        ;;
    *)
        echo -e "${GREEN}PENOS PORTABLE TERMINAL${NC}"
        echo "Version: $CURRENT_VERSION"
        echo "Website: https://penos.indevstudio.dev"
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
