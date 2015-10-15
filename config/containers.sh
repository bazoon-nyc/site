#!/bin/bash

# set -o xtrace (Show verbose command output for debugging.)
# set +o xtrace (To revert to normal.)

# Set registry and project name.
REGISTRY="agolub"
PROJECTNAME="bn"

# This file sits in the config directory, set absolute path.
CONFDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
ROOTDIR=`dirname $CONFDIR`

# Set image versions.
VER_BASE="latest"
VER_BACKEND="latest"
VER_WEBSERVER="latest"


#--------------------------------------------------------------------------------#
# Development related build scripts.
#--------------------------------------------------------------------------------#

# Project specific base image.
bn_build_base() {
    FROM_IMAGE=ubuntu
    NAME=$PROJECTNAME-base
    VERSION=$VER_BASE

    build $NAME $VERSION $FROM_IMAGE
}

# Backend image.
bn_build_backend() {
    FROM_IMAGE=$PROJECTNAME-base
    NAME=$PROJECTNAME-backend
    VERSION=$VER_BACKEND

    build $NAME $VERSION $FROM_IMAGE
}

# Webserver image.
bn_build_webserver() {
    FROM_IMAGE=$PROJECTNAME-base
    NAME=$PROJECTNAME-webserver
    VERSION=$VER_WEBSERVER

    build $NAME $VERSION $FROM_IMAGE
}


#--------------------------------------------------------------------------------#
# Development related Docker run scripts.
#--------------------------------------------------------------------------------#

# Create project base container that
# all other containers will be based off of.
bn_run_base() {
    NAME=$PROJECTNAME-base

    docker run \
        -d \
        -h $NAME \
        --name $NAME \
        $REGISTRY/$PROJECTNAME-base:$VER_BASE
}

# Create postgresql container.
bn_run_postgres() {
    NAME=$PROJECTNAME-postgres

    docker run --name $NAME -e POSTGRES_PASSWORD=postgres -d postgres
}

# Create backend container.
bn_run_backend() {
    NAME=$PROJECTNAME-backend

    mkdir -p $ROOTDIR/logs

    docker run \
        --link $PROJECTNAME-postgres:postgres \
        -v $ROOTDIR/src:/app \
        -v $ROOTDIR/logs:/logs \
        -h $NAME \
        -p 9000:9000 \
        --name $NAME \
        -d \
        -i \
        -t \
        $REGISTRY/$PROJECTNAME-backend:$VER_BACKEND
}

# Create the nginx container to proxy TCP
# traffic to the uWSGI server running on the
# backend container.  And also proxy HTTP traffic
# to the frontend container's port 3000.
bn_run_webserver() {
    NAME=$PROJECTNAME-webserver

    docker run \
        --link $PROJECTNAME-backend:backend \
        --volumes-from $PROJECTNAME-backend \
        --name $NAME \
        -p 80:80 \
        -d \
        $REGISTRY/$PROJECTNAME-webserver:$VER_WEBSERVER
}


#--------------------------------------------------------------------------------#
# Utilities and helpers.
#--------------------------------------------------------------------------------#

# Build a docker image.
build() {
    sed -i '' 's/:VERSION/:'"$2"'/g' $CONFDIR/$1/Dockerfile
    sed -i '' 's/REGISTRY/'"$REGISTRY"'/g' $CONFDIR/$1/Dockerfile
    sed -i '' 's/FROM_IMAGE/'"$3"'/g' $CONFDIR/$1/Dockerfile

    cd $CONFDIR/$1
    docker build -t $REGISTRY/$1:$2 .

    sed -i '' 's/:'"$2"'/:VERSION/g' $CONFDIR/$1/Dockerfile
    sed -i '' 's/'"$REGISTRY"'/REGISTRY/g' $CONFDIR/$1/Dockerfile
    sed -i '' 's/'"$3"'/FROM_IMAGE/g' $CONFDIR/$1/Dockerfile
}

# Stop and remove all videowall containers.
stop_remove_all() {
    stop_remove $PROJECTNAME-base

    stop_remove $PROJECTNAME-backend
    stop_remove $PROJECTNAME-postgres
    stop_remove $PROJECTNAME-webserver
}
