#!/bin/bash

ABCCONFIG=~/.ashwinblockchainconfig
COUCHDBPORT=5984

#Beacon file to handle the connection of peers to the network

#########################################################

#Beacon setup function

beaconSetup(){
    NETWORK=$1
    if [ -z ${NETWORK+x} ]; then #Checking if the variable ADMIN is unset
        echo "Error: Please provide a valid Network name."
        exit 1
    fi
    echo "Setting up Ashwin Blockchain Permissioned Network Beacon..."
    echo "Creating required setup for the new \"$NETWORK\" network"
    echo "Creating ledgers"
    {
        curl -X PUT localhost:$COUCHDBPORT/ashwinblokchain_$NETWORK -o .response.txt
    }&> /dev/null
    
    CREATEDBOP=$(cat .response.txt | jq ".ok")
    if [ "$CREATEDBOP" = "true" ]; then
        echo "Ledger created successfully."
    else
        echo "Error while creating ledger. Check the name or replace the network name."
        cat .response.txt
        rm .response.txt
        exit 1
    fi
    
}

#########################################################

#Function to add admin certificate from the CA to the Beacon

beaconAdminCert(){
    echo "Updating admin certificate to the Beacon..."
    ADMIN=$1
    if [ -z ${ADMIN+x} ]; then #Checking if the variable ADMIN is unset
        echo "Error: Please provide a valid Admin Certificate file."
        exit 1
    fi
    
    mkdir -p $ABCCONFIG/admin/
    cp $ADMIN $ABCCONFIG/admin/admin.crt

    echo ""
    echo "New admin certificate \"$ADMIN\" added to the node successfully."
}

##########################################################

#Function to register a new member node.

beaconAddMember(){
    echo "Adding new member to the permissioned Ashwin Blockchain Network..."
    MEMBERCERT=$1
    MEMBERHOST=$2
    if [ -z ${MEMBERCERT+x} ]; then #Checking if the member cert is provided.
        echo "Error: Please provide a valid Member Certificate file."
        exit 1
    fi
    
    if [ -z ${MEMBERHOST+x} ]; then #Checking if the member host is provided.
        echo "Error: Please provide a valid Member host address"
        exit 1
    fi

    #Operation to add the member to the Beacon list of CouchDB Replication
    {
        openssl verify -CAfile $ABCCONFIG/admin/admin.crt $MEMBERCERT
    }
    &> /dev/null
    if [ $? -eq 1 ]; then
        echo "Error: An error occured. Please check the inputs."
    else
        echo "Member certificate verifed."
    fi
}

##########################################################

#User input recorded from the terminal to start the Beacon module.

if [ -z ${1+x} ]; then # Check if the operation mode is set
    echo "Error: Please provide the operation mode for the Beacon"
    exit 1
fi

mode=$1

case "$mode" in
    setup)
        beaconSetup $2
    ;;
    admincert)
        beaconAdminCert $2
    ;;
    addmember)
        beaconAddMember $2 $3
    ;;
    *)
        echo "Please check the option selected."
    ;;
esac