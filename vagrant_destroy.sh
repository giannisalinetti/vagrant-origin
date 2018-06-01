#!/bin/bash

KEY_DIR=keys

#####################################################################
# Execute vagrant destroy 
#####################################################################
vagrant destroy
err=$?; if [ $err -ne 0 ]; then
    echo "Error during vagrant machines startup process: $err"
    exit 1
fi

#####################################################################
# SSH keys removal
#####################################################################
rm -rf $KEY_DIR/*
err=$?; if [ $err -ne 0 ]; then
    echo "Cannot remove generate SSH keys: $err"
    exit 1
fi

exit 0
