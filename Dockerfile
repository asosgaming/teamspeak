FROM  debian:jessie
MAINTAINER Reesey275 <reesey275@gmail.com>

ENV   TS_VERSION=3.0.13.6 \
      TS_FILENAME=teamspeak3-server_linux_amd64 \
      TS_USER=teamspeak \
      TS_GROUP=teamspeak \
      TS_HOME=/teamspeak \
      TS_DATA=/teamspeak/files


ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.docker.dockerfile="/Dockerfile" \
      org.label-schema.license="MIT" \
      org.label-schema.name="Docker Teamspeak" \
      org.label-schema.url="https://github.com/asosgaming/docker-teamspeak/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/asosgaming/docker-teamspeak.git" \
      org.label-schema.vcs-type="Git"

RUN   apt-get update && apt-get install wget mysql-common bzip2 nano libreadline5 -y \
      && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN   groupadd -g 4000 -r "$TS_GROUP" && \
      useradd -u 4000 -r -m -g "$TS_GROUP" -d "$TS_HOME" "$TS_USER" 
       

WORKDIR ${TS_HOME}

RUN  wget "http://dl.4players.de/ts/releases/${TS_VERSION}/${TS_FILENAME}-${TS_VERSION}.tar.bz2" -O ${TS_FILENAME}-${TS_VERSION}.tar.bz2 \
       && tar -xjf "${TS_FILENAME}-${TS_VERSION}.tar.bz2" \
       && rm ${TS_FILENAME}-${TS_VERSION}.tar.bz2 \
       && mv ${TS_FILENAME}/* ${TS_HOME} \
       && rm -r ${TS_HOME}/tsdns \
       && rm -r ${TS_FILENAME}

RUN  cp "$(pwd)/redist/libmariadb.so.2" $(pwd)

<<<<<<< HEAD
ADD entrypoint.sh ${TS_HOME}/entrypoint.sh
=======
RUN chown -R ${TS3_USER}:${TS3_GROUP} ${TS3_HOME} && chmod u+x /entrypoint.sh && chmod u+x ${TS3_HOME}/entrypoint.sh
>>>>>>> 7b81ba1... Changed Version to 1.0.0.4 with working configs for TS to connect to MySQL Server

RUN chown -R ${TS_USER}:${TS_USER} ${TS_HOME} && chmod +x entrypoint.sh 
	
USER  ${TS_USER}

VOLUME {"TS_DATA"}

EXPOSE 9987/udp
EXPOSE 10011
EXPOSE 30033

ENTRYPOINT ["./entrypoint.sh"]
