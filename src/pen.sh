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
