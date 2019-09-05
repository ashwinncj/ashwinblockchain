#!/bin/bash

echo "Starting AshwinBlockchain..."
# echo "Checking node packages and updating modules"
# cd src/ && npm install > /dev/null 2>&1
echo "Attempting to bring up AshwinBlockchain servers"
docker-compose up -d
