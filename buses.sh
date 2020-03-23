#!/bin/bash
#
# start a development container, load all slab files from the current project

HERE=$(cd `dirname $0`; pwd)
BASE_IMAGE=sqlstream/streamlab-git-complete
BASE_IMAGE_LABEL=release
CONTAINER_NAME=buses

: ${LOAD_SLAB_FILES:=*.slab}


. $HERE/dockercommon.sh

