#!/bin/sh
### BEGIN INIT INFO
# Provides:          audisp-tacplus
# Required-Start:    auditd
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: sends tacacs+ server accounting records
# Description:       When configured, parses audit records for
#                    exec and exit system calls from processes
#                    with auid and session matching tacacs user logins.
#                    This init.d file exists solely to add the
#                    tacacs audit rules; the plugin daemon itself is
#                    started automatically by audisp
### END INIT INFO

# Author: Dave Olson <olson@cumulusnetworks.com>

# PATH should only include /usr/* if it runs after the mountnfs.sh script
PATH=/sbin:/bin
DESC="tacplus audisp daemon"
SCRIPTNAME=/etc/init.d/"$NAME"
NAME=audisp-tacplus
DAEMON=/sbin/audisp-tacplus
DAEMON_ARGS=""

# Exit if the package is not installed
[ -x "$DAEMON" ] || exit 0

# Load the VERBOSE setting and other rcS variables
. /lib/init/vars.sh

# Define LSB log_* functions.
# Depend on lsb-base (>= 3.2-14) to ensure that this file is present
# and status_of_proc is working.
. /lib/lsb/init-functions

#
# Function that loads the tacplus audit rules
#
do_start()
{
	local tacplus_rules=/etc/audisp/plugins.d/audisp-tacplus.rules
	if [ -f $tacplus_rules ]
	then
		/sbin/auditctl -R $tacplus_rules >/dev/null
	fi
    return 0
}

#
# There is no action on stop
#
do_stop()
{
    return 0
}

#
# On reload, just run the start action, which may fail
# if the rules are still active (haven't been changed
# manually or removed with auditctl -D)
#
do_reload() {
    do_start
}

case "$1" in
  start)
	[ "$VERBOSE" != no ] && log_daemon_msg "Starting $DESC" "$NAME"
	do_start
	case "$?" in
		0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
		2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
	esac
	;;
  stop)
	[ "$VERBOSE" != no ] && log_daemon_msg "Stopping $DESC" "$NAME"
	do_stop
	case "$?" in
		0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
		2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
	esac
	;;
  status)
	# no action
	;;
  reload|force-reload)
	log_daemon_msg "Reloading $DESC" "$NAME"
	do_reload
	log_end_msg $?
	;;
  restart|force-reload)
	#
	# If the "reload" option is implemented then remove the
	# 'force-reload' alias
	#
	log_daemon_msg "Restarting $DESC" "$NAME"
	do_stop
	case "$?" in
	  0|1)
		do_start
		case "$?" in
			0) log_end_msg 0 ;;
			1) log_end_msg 1 ;; # Old process is still running
			*) log_end_msg 1 ;; # Failed to start
		esac
		;;
	  *)
		# Failed to stop
		log_end_msg 1
		;;
	esac
	;;
  *)
	echo "Usage: $SCRIPTNAME {start|stop|restart|reload|force-reload}" >&2
	exit 3
	;;
esac

:
