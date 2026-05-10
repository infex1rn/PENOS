#!/bin/bash
echo "Building PENOS in Docker container..."
docker build -t penos-builder .
docker run --privileged -v $(pwd):/home/ubuntu/PENOS penos-builder ./scripts/build_iso.sh
