#!/bin/bash

createnetwork() {
    echo "Creating Ashwin Blockchain network..."
    
}

mode=$1

case "$mode" in
    create)
        createnetwork
    ;;
    *)
        echo "default"
    ;;
esac

#shift $((OPTIND -1))

