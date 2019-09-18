#!/bin/bash

#Beacon file to handle the connection of peers to the network

#########################################################

#Beacon setup function

beaconSetup(){

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
        beaconSetup
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