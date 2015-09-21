#!/bin/bash

SCRIPTPATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
PROJECTNAME="videowall"

source $SCRIPTPATH/containers.sh
source $SCRIPTPATH/utils.sh

stop_remove $PROJECTNAME-postgres
bn_run_postgres

stop_remove $PROJECTNAME-site
bn_run_site

stop_remove $PROJECTNAME-webserver
bn_run_webserver
