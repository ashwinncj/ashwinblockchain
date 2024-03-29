#!/bin/bash

ABCCONFIG=~/.ashwinblockchainconfig

caSetup(){
    CANAME=$1
    if [ -z ${CANAME+x} ]; then #Checking if the variable CNAME is unset
        echo "Error: Please provide a name for the CA."
        exit 1
    fi

    #Check if CA name already exists
     if [ -d $ABCCONFIG/membership/$CANAME ]; then 
    echo "Error: CA \"$CANAME\" already exists"
    exit 1
    fi

    #Create a directory in the name of the CA
    echo "Setting up CA \"$CANAME\""
    {
        mkdir -p $ABCCONFIG/membership/$CANAME
        openssl genrsa -out $ABCCONFIG/membership/$CANAME/$CANAME.pem
    }&> /dev/null

    openssl req -x509 -key $ABCCONFIG/membership/$CANAME/$CANAME.pem -new -out $ABCCONFIG/membership/$CANAME/$CANAME.crt -days 365
    
    if [ $? -eq 1 ]; then
        echo "Error: An error occured. Please check the inputs."
    else
        echo ""
        echo "New CA \"$CANAME\" added."
    fi
}

#Function for requesting certificate from the CA
caRequest(){

    echo "Generating CSR to sign from CA..."
    MEMBER=$1
    if [ -z ${MEMBER+x} ]; then #Checking if the variable MEMBER is unset
        echo "Error: Please provide a name for the requesting member."
        exit 1
    fi

    #Check if member already exists
     if [ -d $ABCCONFIG/membership/$MEMBER ]; then 
        echo "Error: Network member \"$MEMBER\" already exists"
        exit 1
    fi

    #Create a directory in the name of the member
    echo "Setting up network member \"$MEMBER\""
    {
        mkdir -p $ABCCONFIG/membership/$MEMBER
        openssl genrsa -out $ABCCONFIG/membership/$MEMBER/$MEMBER.pem
    }&> /dev/null

    openssl req -key $ABCCONFIG/membership/$MEMBER/$MEMBER.pem -new -out $MEMBER.csr
    echo ""
    echo "Certificate Signing Request (CSR) for \"$MEMBER\" has been output in the present directory as \"$MEMBER.csr\" . Please send the file to CA to sign and obtain the certificate to join Ashwin Blockchain Network."
}

#Function to sign the CSR from using the CA keys
caSign(){

    echo "Signing CSR by CA..."
CANAME=$1
    if [ -z ${CANAME+x} ]; then #Checking if the variable CNAME is unset
        echo "Error: Please provide a name for the CA."
        exit 1
    fi

    #Check if CA exists
     if [ ! -d $ABCCONFIG/membership/$CANAME ]; then 
        echo "Error: CA \"$CANAME\" does not exist. Please check the CA name"
        exit 1
    fi

    MEMBER=$2
    MEMBERCERT=${2%%.*}
    if [ -z ${MEMBER+x} ]; then #Checking if the variable MEMBER is unset
        echo "Error: Please provide a valid CSR file to obtain the certificate."
        exit 1
    fi

    openssl x509 -in $MEMBER -req -CA $ABCCONFIG/membership/$CANAME/$CANAME.crt -CAkey $ABCCONFIG/membership/$CANAME/$CANAME.pem -CAcreateserial -out $MEMBERCERT.crt -days 365

    if [ -f ./$MEMBERCERT.crt ]; then
        echo ""
        echo "Certificate for \"$MEMBER\" is output in the present directory as \"$MEMBERCERT.crt\" . Send the certificate file to the member to enable them to join the Ashwin Blockchain network."        
    else
        echo ""
        echo "There seems to be an error. Please check with the manual for the usage."
    fi
}

#Function to update the certificate issued by the CA.
caUpdateCert(){
    echo "Updating the certificate issued by the CA..."
    MEMBER=$1
    if [ -z ${MEMBER+x} ]; then #Checking if the variable MEMBER is unset
        echo "Error: Please provide a name for the requesting member."
        exit 1
    fi

    #Check if member exists
     if [ ! -d $ABCCONFIG/membership/$MEMBER ]; then 
        echo "Error: Network member \"$MEMBER\" does not exist!"
        exit 1
    fi

    cp $2 $ABCCONFIG/membership/$MEMBER/
    echo "Member certificate \"$2\" updated and copied to the configuration folder."

}

#Function to add admin certificate to the member node

caAdminCert(){
    echo "Updating admin certificate to the node..."
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

#Function to output admin certificate to the folder

caoutputadmincert(){
    echo "Getting CA Admin Certificate..."
    CANAME=$1
    if [ -z ${CANAME+x} ]; then #Checking if the variable CNAME is unset
        echo "Error: Please provide a name to output CA Admin Cert."
        exit 1
    fi

    #Check if CA exists
     if [ ! -d $ABCCONFIG/membership/$CANAME ]; then 
        echo "Error: CA \"$CANAME\" does not exist. Please check the CA name"
        exit 1
    fi

    cp $ABCCONFIG/membership/$CANAME/$CANAME.crt ./
    echo "CA admin cert for \"$CANAME\" has been output in the present folder as \"$CANAME.crt\" ."
}




#User input recorded from the terminal to start the CA module.

if [ -z ${1+x} ]; then # Check if the operation mode is set
    echo "Error: Please provide the operation mode for the CA"
    exit 1
fi

mode=$1

case "$mode" in
    setup)
        caSetup $2
    ;;
    request)
        caRequest $2
    ;;
    sign)
        caSign $2 $3
    ;;
    updatecert)
        caUpdateCert $2 $3
    ;;
    admincert)
        caAdminCert $2
    ;;
    outputadmincert)
        caoutputadmincert $2
    ;;
    *)
        echo "Please check the option selected."
    ;;
esac
