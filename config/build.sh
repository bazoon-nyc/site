#!/bin/bash

SCRIPTPATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source $SCRIPTPATH/containers.sh
source $SCRIPTPATH/utils.sh

bn_build_base

bn_build_backend

bn_build_webserver
