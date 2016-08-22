FROM descoped/atlassian-base
MAINTAINER Ove Ranheim <oranheim@gmail.com>

# Install Bitbucket
ENV BITBUCKET_VERSION 4.8.5

ENV BITBUCKET_INST=/opt/bitbucket
ENV BITBOCKET_HOME=/var/atlassian-home

ENV UID=bitbucket
ENV GID=atlassian

ADD configure.bash /configure
RUN chmod +x /configure

RUN curl -Lks http://www.atlassian.com/software/stash/downloads/binary/atlassian-bitbucket-$BITBUCKET_VERSION.tar.gz -o /root/bitbucket.tar.gz \
    && useradd -r --create-home --home-dir $BITBUCKET_INST --groups $GID --shell /bin/bash $UID \
    && tar zxf /root/bitbucket.tar.gz --strip=1 -C $BITBUCKET_INST \
    && rm /root/bitbucket.tar.gz \
    && mv $BITBUCKET_INST/conf/server.xml $BITBUCKET_INST/conf/server-backup.xml

# Launching Bitbucket
WORKDIR $BITBUCKET_INST
VOLUME $BITBOCKET_HOME

COPY entrypoint.bash /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 7990 7999
CMD ["bin/start-bitbucket.sh", "-fg"]
