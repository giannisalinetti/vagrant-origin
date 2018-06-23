#!/bin/bash

KEY_DIR=keys


#####################################################################
# Get machines list (Vagrant reports only the first ocp-cluster
#####################################################################
MACHINES=$(ls .vagrant/machines)

#####################################################################
# Execute vagrant destroy 
#####################################################################
for m in $MACHINES; do
    vagrant destroy $m
    err=$?; if [ $err -ne 0 ]; then
        echo "Error removing vagrant machine $m: $err"
        exit 1
    fi
done

#####################################################################
# SSH keys removal
#####################################################################
rm -rf $KEY_DIR/*
err=$?; if [ $err -ne 0 ]; then
    echo "Cannot remove generate SSH keys: $err"
    exit 1
fi

exit 0
