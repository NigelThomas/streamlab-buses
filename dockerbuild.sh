#¡/bin/bash
docker kill nigelclthomas/buses
docker rm nigelclthomas/buses
docker build -t nigelclthomas/buses --build-arg PROJECT_NAME_ARG=buses .
