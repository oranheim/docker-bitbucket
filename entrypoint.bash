#!/bin/bash
set -e

if [[ "$PATH" == ?(*:)"$JAVA_HOME/bin"?(:*) ]]; then
    export JAVA_HOME=/opt/jdk
    export PATH=$PATH:$JAVA_HOME/bin
    export BITBUCKET_HOME=/opt/atlassian-home
fi

# allow the container to be started with `--user`
if [ "$1" = 'bin/start-bitbucket.sh' -a "$(id -u)" = '0' ]; then
    if [ ! -f $BITBUCKET_INST/conf/server.xml ]; then /configure; fi
    rm -f $BITBOCKET_HOME/.jira-home.lock
    chown -R $UID:$UID $BITBUCKET_INST
    chown -R $UID:$GID $BITBOCKET_HOME
    exec gosu $UID "$BASH_SOURCE" "$@"
fi

umask 0027
exec "$@"
