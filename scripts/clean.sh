#!/bin/bash
set -e

# Load version
VERSION=$(cat meta/VERSION)
echo "Cleaning PENOS v${VERSION} build artifacts..."

sudo rm -rf build/
rm -f out/penos.iso
rm -f out/penos.iso.xz
rm -f out/sha256

echo "Clean complete."
