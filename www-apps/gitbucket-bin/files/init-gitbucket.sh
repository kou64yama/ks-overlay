#!/sbin/runscript

extra_commands="forcestop"

: ${LONG_NAME:="${RC_SVCNAME}"}
: ${PIDFILE:=/run/${RC_SVCNAME}.pid}

##########  Helper functions  ##########

init_defaults() {
	: ${gitbucket_war:=/usr/lib/gitbucket-bin/gitbucket.war}
	: ${gitbucket_user:=git}
	: ${gitbucket_hostname:=localhost}
	: ${gitbucket_port:=8080}
	: ${gitbucket_context_path:=/}
	: ${gitbucket_data_dir:=/var/lib/git}
	: ${jmx_ssl:=enable}
	: ${java_opts:=-XX:+UseConcMarkSweepGC}
}

init_env() {
	export JAVA_HOME=`java-config ${gitbucket_jvm:+--select-vm ${gitbucket_jvm}} --jre-home`
}

init_command_args() {
	command=${JAVA_HOME}/bin/java

	if [ "${jmx_ssl}" = "disable" ]; then
		java_opts+=" -Dcom.sun.management.jmxremote.ssl=false"
	fi
	if [ -r "${jmx_passwd_file}" ]; then
		java_opts+=" -Dcom.sun.management.jmxremote.password.file=${jmx_passwd_file}"
	fi
	if [ -r "${jmx_access_file}" ]; then
		java_opts+=" -Dcom.sum.management.jmxremote.access.file=${jmx_access_file}"
	fi
	if [ -n "${rmi_hostname}" ]; then
		java_opts+=" -Djava.rmi.server.hostname=${rmi_hostname}"
	fi

	# JVM memory parameters
        java_opts+="
		${java_min_heap_size:+ -Xms${java_min_heap_size}M}
		${java_max_heap_size:+ -Xmx${java_max_heap_size}M}
		${java_min_perm_size:+ -XX:PermSize=${java_min_perm_size}m}
		${java_max_perm_size:+ -XX:MaxPermSize=${java_max_perm_size}m}
		${java_min_new_size:+ -XX:NewSize=${java_min_new_size}m}
		${java_max_new_size:+ -XX:MaxNewSize=${java_max_new_size}m}"
	
	gitbucket_opts="
		--host=${gitbucket_hostname}
		--port=${gitbucket_port}
		--prefix=${gitbucket_context_path}
		--gitbucket.home=${gitbucket_data_dir}"

	# Complete list of arguments for startup script
	command_args="
		-server
		${java_opts}
		-jar ${gitbucket_war}
		${gitbucket_opts}"
}

check_paths() {
	if [ ! -d "${gitbucket_data_dir}" ]; then
		eerror '$gitbucket_data_dir does not exist or not a directory!'; eend 1
	fi
}

init_vars() {
	init_defaults
	init_env
	init_command_args
	check_paths
}

##########  Runscript functions  ##########

depend() {
	use net
}

start_pre() {
	init_vars
}

start() {
	ebegin "Starting ${LONG_NAME}"

	start-stop-daemon --start \
		--quiet --background \
		--chdir "${gitbucket_data_dir}" \
		--user "${gitbucket_user}" \
		--make-pidfile --pidfile ${PIDFILE} \
		--exec ${command} -- ${command_args}
	eend $?
}

stop() {
	ebegin "Stopping ${LONG_NAME}"
	
	start-stop-daemon --stop \
		--quiet --retry=60 \
		--pidfile ${PIDFILE}
	eend $?
}

forcestop() {
	ebegin "Forcing ${LONG_NAME} to stop"

	start-stop-daemon --stop \
		--quiet --retry=60 \
		--pidfile ${PIDFILE} \
		--signal=9
	
	if service_started "${RC_SVCNAME}"; then
		make_service_stopped "${RC_SVCNAME}"
	fi

	eend $?
}
