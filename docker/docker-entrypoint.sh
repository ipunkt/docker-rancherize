#!/bin/sh

export PATH=$PATH:/opt/rancherize/vendor/bin/

USER_ID=${USER_ID:-}
GROUP_ID=${GROUP_ID:-}

if [ ! -z "$USER_ID" -a ! -z "$GROUP_ID" ] ; then
   export USER="user"
	if id "${USER}" > /dev/null 2>&1 ; then
		deluser "${USER}"
	fi

	if grep -q -E "^${USER}:" /etc/group ; then
		delgroup "${USER}"
	fi
   addgroup -g "${GROUP_ID}" "${USER}"
   adduser -D -H -u "${USER_ID}" -G "${USER}" "${USER}"

	chgrp ${USER} /var/run/docker.sock
	chmod g+x /var/run/docker.sock
	chmod g+r /var/run/docker.sock
	chmod g+w /var/run/docker.sock

fi

if [ "$1" != "init" ] && type "$1" >/dev/null ; then
	exec "$@"
	exit $?
fi


exec su-exec ${USER} rancherize $@
