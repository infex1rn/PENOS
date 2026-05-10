#!/bin/bash
if [ -f "out/penos.iso" ]; then
    sha256sum "out/penos.iso" > "out/sha256"
    echo "Checksum generated: $(cat out/sha256)"
else
    echo "ISO not found in out/"
fi
