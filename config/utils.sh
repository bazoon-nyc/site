#!/bin/bash

# Open new terminal with new instance of container's shell.
open_shell() {
    # @param $1: name of container.
    if [ `docker ps | grep $1 | wc -l` -ne 0 ]; then
        docker exec -i -t $1 bash
    fi
}


# Stop and remove a container.
stop_remove() {
    # @param $1: name of container.
    if [ `docker ps | grep $1 | wc -l` -ne 0 ]; then
        docker stop $1
    fi
    if [ `docker ps -a | grep $1 | wc -l` -ne 0 ]; then
        docker rm $1
    fi
    sleep 2
}


# Remove all containers that are not running.
remove_exited() {
    docker ps -a | awk 'NR > 1 {print $1}' | xargs docker rm
}