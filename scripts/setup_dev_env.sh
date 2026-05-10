#!/bin/bash
echo "Setting up host machine for PENOS development..."
sudo apt update
sudo apt install -y $(cat meta/dependencies.txt)
echo "Setup finished."
