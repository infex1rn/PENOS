#!/bin/bash
echo "Verifying build environment for PENOS..."
while read -r dep; do
    if command -v "$dep" >/dev/null 2>&1; then
        echo "[OK] $dep is installed."
    else
        echo "[!!] $dep is MISSING."
    fi
done < meta/dependencies.txt
