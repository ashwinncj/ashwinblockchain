#!/bin/bash

ABCCONFIG=~/.ashwinblockchainconfig

#Function to create a new network on Ashwin Blockchain

networkCreate(){
     echo "Creating a new network on Ashwin Blockchain..."
    NETWORK=$1
    if [ -z ${NETWORK+x} ]; then #Checking if the variable NETWORK is unset
        echo "Error: Please provide a valid Network name"
        exit 1
    fi

    #Check if Network already exists
     if [ -d $ABCCONFIG/network/$NETWORK ]; then 
        echo "Error: Network \"$MEMBER\" already exists!"
        exit 1
    fi

    mkdir -p $ABCCONFIG/network/$NETWORK
}

#User input recorded from the terminal to start the CA module.

if [ -z ${1+x} ]; then # Check if the operation mode is set
    echo "Error: Please provide the operation mode for the Network"
    exit 1
fi

mode=$1

case "$mode" in
    setup)
        networkCreate $2
    ;;
    *)
        echo "Please check the option selected."
    ;;
esac