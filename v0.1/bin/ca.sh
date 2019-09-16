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

#Function for requesting certificate from the CA
caRequest(){

    echo "Generating CSR to sign from CA..."
    MEMBER=$1
    if [ -z ${MEMBER+x} ]; then #Checking if the variable MEMBER is unset
        echo "Error: Please provide a name for the requesting member."
        exit 1
    fi

    #Check if member already exists
     if [ -d $ABCCONFIG/member/$MEMBER ]; then 
        echo "Error: Network member \"$MEMBER\" already exists"
        exit 1
    fi

    #Create a directory in the name of the member
    echo "Setting up network member \"$MEMBER\""
    {
        mkdir -p $ABCCONFIG/member/$MEMBER
        openssl genrsa -out $ABCCONFIG/member/$MEMBER/$MEMBER.pem
    }&> /dev/null

    openssl req -key $ABCCONFIG/member/$MEMBER/$MEMBER.pem -new -out $MEMBER.csr
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
     if [ ! -d $ABCCONFIG/ca/$CANAME ]; then 
        echo "Error: CA \"$CANAME\" does not exist. Please check the CA name"
        exit 1
    fi

    MEMBER=$2
    MEMBERCERT=${2%%.*}
    if [ -z ${MEMBER+x} ]; then #Checking if the variable MEMBER is unset
        echo "Error: Please provide a valid CSR file to obtain the certificate."
        exit 1
    fi

    openssl x509 -in $MEMBER -req -CA $ABCCONFIG/ca/$CANAME/$CANAME.crt -CAkey $ABCCONFIG/ca/$CANAME/$CANAME.pem -CAcreateserial -out $MEMBERCERT.crt -days 365

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

    #Check if member already exists
     if [ ! -d $ABCCONFIG/member/$MEMBER ]; then 
        echo "Error: Network member \"$MEMBER\" does not exist!"
        exit 1
    fi

    cp $2 $ABCCONFIG/member/$MEMBER/
    echo "Member certificate \"$2\" updated and copied to the configuration folder."

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
    *)
        echo "Please check the option selected."
    ;;
esac
