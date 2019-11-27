#!/bin/bash

# Start the buses demo image
docker kill buses
docker rm buses
docker run -p 80:80 -p 5560:5560 -p 5580:5580 -p 5595:5595 -e PROJECT_NAME=buses -d --name buses -it nigelclthomas/buses
