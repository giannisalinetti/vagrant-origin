#!/bin/bash

vagrant halt
if [ $? -ne 0 ]; then
    echo "Error during vagrant machines shutdown process: $?"
    exit 1
fi

exit 0
