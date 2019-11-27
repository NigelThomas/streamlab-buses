# Dockerfile

# Base the image on standard SQLstream image
# This project needs the PostgreSQL database and pre-loaded test data included with the complete image
FROM sqlstream/complete:release

# Use jq to manipulate JSON files such as the slab file
RUN apt-get update &&\
    apt-get install -y jq

# This environment variable can be set when building the image
ARG PROJECT_NAME_ARG=myproject
ENV PROJECT_NAME=${PROJECT_NAME_ARG}

# get the project slab file
RUN mkdir -p /home/sqlstream/${PROJECT_NAME_ARG}/dashboards &&\
    chown -R sqlstream:sqlstream /home/sqlstream/${PROJECT_NAME_ARG}

COPY --chown=sqlstream:sqlstream ${PROJECT_NAME_ARG}.slab /home/sqlstream/${PROJECT_NAME_ARG}/
COPY --chown=sqlstream:sqlstream listPumps.* /home/sqlstream/${PROJECT_NAME_ARG}/

# copy s-Dashboard dashboards if any
#COPY --chown=sqlstream:sqlstream dashboards/*.json /home/sqlstream/${PROJECT_NAME_ARG}/dashboards/

# not included in this simple example:
# copy jndi properties files to the $SQLSTREAM_HOME/plugin/jndi directory
# copy Kerberos principals etc to the image

# copy the setup and startup and other scripts from the Dockerfile directory
COPY --chown=sqlstream:sqlstream *.sh /home/sqlstream/${PROJECT_NAME}/

# make the setup executable
RUN chmod +x /home/sqlstream/${PROJECT_NAME_ARG}/*.sh 

# the base image already EXPOSEs required ports - add EXPOSE here if you need to change, extend or reduce the list
EXPOSE 80 5560 5580 5595

# when the container starts, we want to start the project pumps and then tail the s-Server trace log
ENTRYPOINT PROJECT_NAME=${PROJECT_NAME} time /home/sqlstream/${PROJECT_NAME}/startup.sh &&\
           tail -f /var/log/sqlstream/Trace.log.0

