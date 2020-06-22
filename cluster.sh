#!/bin/bash

set -e

me=$(basename "$0")

if [[ ! $1 =~ ^(create|destroy|status|start|suspend)$ ]]; then
echo "Usage: $(basename $0) <create|destroy|status|start|suspend>"
exit 1
fi

cd $(realpath $0 | sed -r "s/(^.*\/)$me$/\1/")


if [[ $1 == 'create' ]]; then
    echo "Enter number of nodes in cluster(1-10): "
    read node_num
    
    if [[ $node_num -lt 1 || $node_num -gt 10 ]]; then
        echo "Number of nodes can't be less then 1 and more then 10. Exiting..."
        exit 1
    fi

    [[ -n $node_num ]] && echo $node_num > .node_num
    echo -e 'y' | ssh-keygen -t rsa -f ./ansible/project.key -q -P ""
    vagrant up
    image=$(docker image ls -q ansible:latest)
    [[ -z $image ]] && docker build -t ansible:latest .
    docker run --rm -ti -v $PWD/ansible:/ansible $image ansible-playbook -i hosts setup-kube.yml
    ls ~/.kube || mkdir ~/.kube
    ln -sf $PWD/config ~/.kube/config
    date > .cluster_created
fi

if [[ $1 == 'destroy' ]]; then
    [[ -f .cluster_created ]] || ( echo "Cluster was not created. Exiting..."; exit 1 )
    vagrant destroy -f
    rm -f ./.node_num
    rm -f ~/.kube/config
    rm -f .cluster_created
fi

if [[ $1 == 'status' ]]; then
    vagrant status
fi

if [[ $1 == 'start' ]]; then
    [[ -f .cluster_created ]] && vagrant up
    [[ -f .cluster_created ]] || ( echo "Cluster is not created. Exiting..."; exit 1 )
fi

if [[ $1 == 'suspend' ]]; then
    [[ -f .cluster_created ]] && vagrant suspend
    [[ -f .cluster_created ]] || ( echo "Cluster is not created. Exiting..."; exit 1 )
fi
