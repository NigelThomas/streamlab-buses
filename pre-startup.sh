#!/bin/bash
#
# Script executed (if present) before starting the pumps in a project

# include standard monitor app
. add_monitor.sh

echo ...  execute project specific startup for buses
$SQLSTREAM_HOME/demo/data/buses/start.sh


