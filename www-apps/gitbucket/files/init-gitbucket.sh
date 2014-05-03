#!/sbin/runscript

: ${gitbucket_pidfile:=/var/run/gitbucket.pid}
: ${gitbucket_war:=/usr/share/gitbucket/webapps/gitbucket.war}

: ${GITBUCKET_USER:=gitbucket}
: ${GITBUCKET_PORT:=8080}
: ${GITBUCKET_CONTEXT_PATH:=/}
: ${GITBUCKET_HOSTNAME:=127.0.0.1}
: ${GITBUCKET_DATA_DIR:=/var/lib/gitbucket}

depend() {
    need net
}

start() {
    local java=$(java-config --jre-home)/bin/java
    local gitbucket_opts=""

    gitbucket_opts="${gitbucket_opts} --port=${GITBUCKET_PORT}"
    gitbucket_opts="${gitbucket_opts} --prefix=${GITBUCKET_CONTEXT_PATH}"
    gitbucket_opts="${gitbucket_opts} --host=${GITBUCKET_HOSTNAME}"
    gitbucket_opts="${gitbucket_opts} --gitbucket.home=${GITBUCKET_DATA_DIR}"

    ebegin "Starting ${SVCNAME}"
    start-stop-daemon --start --quiet --background \
        --make-pidfile --pidfile ${gitbucket_pidfile} \
        --user ${GITBUCKET_USER} \
        --exec ${java} -- ${GITBUCKET_JAVA_OPTS} -jar ${gitbucket_war} \
        ${gitbucket_opts}
    eend $?
}

stop() {
    ebegin "Stopping ${SVCNAME}"
    start-stop-daemon --stop --quiet --pidfile ${gitbucket_pidfile}
    eend $?
}
