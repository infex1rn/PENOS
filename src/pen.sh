#!/bin/bash
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

UPDATE_SERVER="https://update.pen.indevstudio.dev/release/v1"
VERSION_FILE="/etc/penos-version"
UPDATE_DIR="/storage/update"
CURRENT_VERSION=$(cat $VERSION_FILE 2>/dev/null || echo "unknown")

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
