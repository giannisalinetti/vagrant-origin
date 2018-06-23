#!/bin/bash

INVENTORY='inventory/singlemaster'

if [ $1 == "community" ]; then
    BASEDIR=/root
    ansible-playbook -i ${INVENTORY} $BASEDIR/openshift-ansible/playbooks/prerequisites.yml
    if [ $? -ne 0 ]; then
        printf 'Error during OCP 3.9 prerequisites configuration.\f'
        exit 1
    fi
  
    ansible-playbook -i ${INVENTORY} $BASEDIR/openshift-ansible/playbooks/deploy_cluster.yml
    if [ $? -ne 0 ]; then
        printf 'Error during OCP 3.9 cluster deployment.\f'
        exit 1
    fi
fi

if [ $1 == "atomic" ]; then
    ansible-playbook -i ${INVENTORY} /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml
    if [ $? -ne 0 ]; then
        printf 'Error during OCP 3.9 prerequisites configuration.\f'
        exit 1
    fi
  
    ansible-playbook -i ${INVENTORY} /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml
    if [ $? -ne 0 ]; then
        printf 'Error during OCP 3.9 cluster deployment.\f'
        exit 1
    fi
fi

exit 0
