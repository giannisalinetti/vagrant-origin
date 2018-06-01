#!/bin/bash

if [ $1 == '-h' ] || [ $1 == '--help' ]; then
    echo "Usage: vagrant_up.sh <MASTERS> <INFRA> <NODES>"
    exit 0
fi

#####################################################################
# Check the correct number of parameters
#####################################################################
if [ $# != 3 ]; then
    echo "Error: Invalid number of parameters"
    echo "Usage: vagrant_up.sh <MASTERS> <INFRA> <NODES>"
    exit 1
fi

#####################################################################
# Check masters count
#####################################################################
if [ $1 == 0 ] || [ $(($1 % 2)) == 0 ]; then
    echo "Error: there should be at least 2n+1 Master node with n >= 0"
    exit 1
fi


#####################################################################
# SSH keys generation 
#####################################################################
KEY_DIR=keys
PRIVATE_KEY=$KEY_DIR/ocplab_rsa

if [ ! -d $KEY_DIR ]; then
    mkdir $KEY_DIR
    err=$?; if [ $err -ne 0 ]; then
        echo "Cannot create directory $KEY_DIR: $err"
        exit 1
    fi
fi

if [ ! -r $PRIVATE_KEY ]; then
    ssh-keygen -P '' -f $PRIVATE_KEY
    err=$?; if [ $err -ne 0 ]; then
        echo "Error during SSH keys creation: $err"
        exit 1
    fi
fi


#####################################################################
# Start the vagrant machines using the provided parameters
#####################################################################
MASTERS=$1 INFRA=$2 APPS=$3 vagrant up --destroy-on-error
err=$?; if [ $err -ne 0 ]; then
    echo "Error during vagrant machines startup process: $err"
    exit 1
fi

exit 0
