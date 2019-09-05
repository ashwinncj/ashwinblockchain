#!/bin/bash

echo "Installing AshwinBlockchain v0.1..."
echo "Checking node packages and updating modules"
cd src/ && npm install > /dev/null 2>&1
echo "Updated node modules."
echo "Installed AshwinBlockchain !"
