# Dockerfile

# Base the image on standard SQLstream image
# This project needs the PostgreSQL database and pre-loaded test data included with the complete image
FROM sqlstream/complete:release

# We use jq to manipulate JSON files such as the slab file
# We use git to get sqlstream-docker-utils

RUN apt-get update &&\
    apt-get install -y jq git

# These environment variables can be set when building the image
ARG PROJECT_NAME_ARG=myproject
ENV PROJECT_NAME=${PROJECT_NAME_ARG}

# set up the project directory
RUN mkdir -p /home/sqlstream/${PROJECT_NAME_ARG}/dashboards &&\
    chown -R sqlstream:sqlstream /home/sqlstream/${PROJECT_NAME_ARG}

# get the slab file(s)
COPY --chown=sqlstream:sqlstream *.slab /home/sqlstream/${PROJECT_NAME_ARG}/

# copy s-Dashboard dashboards if any
#COPY --chown=sqlstream:sqlstream dashboards/*.json /home/sqlstream/${PROJECT_NAME_ARG}/dashboards/

# not included in this simple example:
# copy jndi properties files to the $SQLSTREAM_HOME/plugin/jndi directory
# copy Kerberos principals etc to the image

# copy any scripts from the Dockerfile directory
# these scripts can override standard scripts from sqlstream-docker-utils

COPY --chown=sqlstream:sqlstream *.sh /home/sqlstream/${PROJECT_NAME}/

WORKDIR /home/sqlstream

# the base image already EXPOSEs required ports - add EXPOSE here if you need to change, extend or reduce the list
EXPOSE 80 5560 5580 5595

# when the container starts, we want to start the project pumps and then tail the s-Server trace log
# note late binding to get latest version of sqlstream-docker-utils

ENTRYPOINT export PATH=/home/sqlstream/${PROJECT_NAME}:/home/sqlstream/sqlstream-docker-utils:$PATH &&\
           git clone https://github.com/NigelThomas/sqlstream-docker-utils.git &&\
           cd /home/sqlstream/${PROJECT_NAME} &&\
           echo "Loading project ${PROJECT_NAME}" &&\
           PROJECT_NAME=${PROJECT_NAME} time startup.sh &&\
           tail -f /var/log/sqlstream/Trace.log.0

