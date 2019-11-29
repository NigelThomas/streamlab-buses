#¡/bin/bash
docker kill buses
docker rm buses
docker build -t nigelclthomas/buses --build-arg PROJECT_NAME_ARG=buses .
