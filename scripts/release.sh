#!/bin/bash
VERSION=$(cat meta/VERSION)
echo "Releasing PENOS v${VERSION}..."
git tag -a "v${VERSION}" -m "Release v${VERSION}"
git push origin "v${VERSION}"
echo "Ready for R2 upload."
