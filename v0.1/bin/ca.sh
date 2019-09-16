#!/bin/bash

ABCCONFIG=~/.ashwinblockchainconfig

caSetup(){
    CANAME=$1
    if [ -z ${CANAME+x} ]; then #Checking if the variable CNAME is unset
    echo "Error: Please provide a name for the CA."
    exit 1
    fi

    #Check if CA name already exists
     if [ -d $ABCCONFIG/ca/$CANAME ]; then 
    echo "Error: CA \"$CANAME\" already exists"
    exit 1
    fi

    #Create a directory in the name of the CA
    echo "Setting up CA \"$CANAME\""
    {
        mkdir -p $ABCCONFIG/ca/$CANAME
        openssl genrsa -out $ABCCONFIG/ca/$CANAME/$CANAME.pem
    }&> /dev/null

    openssl req -x509 -key $ABCCONFIG/ca/$CANAME/$CANAME.pem -new -out $ABCCONFIG/ca/$CANAME/$CANAME.crt -days 365
}

if [ -z ${1+x} ]; then # Check if the operation mode is set
    echo "Error: Please provide the operation mode for the CA"
    exit 1
fi

mode=$1

case "$mode" in
    setup)
        caSetup $2
    ;;
    2|3)
        echo "case 2 or 3"
    ;;
    *)
        echo "default"
    ;;
esac
