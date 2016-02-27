FROM docker-atlassian-base
MAINTAINER Ove Ranheim <oranheim@gmail.com>

# Install Stash

ENV BITBUCKET_VERSION 4.3.2
RUN curl -Lks http://www.atlassian.com/software/stash/downloads/binary/atlassian-bitbucket-${BITBUCKET_VERSION}.tar.gz -o /root/bitbucket.tar.gz
RUN /usr/sbin/useradd --create-home --home-dir /opt/bitbucket --groups atlassian --shell /bin/bash bitbucket
RUN tar zxf /root/bitbucket.tar.gz --strip=1 -C /opt/bitbucket
RUN sed -i -e "s/^#!\/bin\/sh/#!\/bin\/bash/" /opt/bitbucket/bin/catalina.sh
RUN mv /opt/bitbucket/conf/server.xml /opt/bitbucket/conf/server-backup.xml
RUN chown -R bitbucket:bitbucket /opt/bitbucket

ENV CONTEXT_PATH ROOT
ADD launch.bash /launch
RUN chmod +x /launch

# Launching Stash

WORKDIR /opt/bitbucket
VOLUME /opt/atlassian-home
EXPOSE 7990 7999
USER bitbucket
CMD ["/launch"]
