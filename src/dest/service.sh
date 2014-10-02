#!/usr/bin/env sh
#
# SABnzbd service

# import DroboApps framework functions
. /etc/service.subr

# DroboApp framework version
framework_version="2.0"

# app description
name="sabnzbd"
version="0.7.18"
description="Usenet downloader"

# framework-mandated variables
pidfile="/tmp/DroboApps/${name}/pid.txt"
logfile="/tmp/DroboApps/${name}/log.txt"
statusfile="/tmp/DroboApps/${name}/status.txt"
errorfile="/tmp/DroboApps/${name}/error.txt"

# app-specific variables
prog_dir=$(dirname $(readlink -fn ${0}))
python="${DROBOAPPS_DIR}/python2/bin/python"
conffile="${prog_dir}/data/sabnzbd.ini"

# script hardening
set -o errexit  # exit on uncaught error code
set -o nounset  # exit on unset variable
set -o pipefail # propagate last error code on pipe

# ensure log folder exists
logfolder="$(dirname ${logfile})"
[[ ! -d "${logfolder}" ]] && mkdir -p "${logfolder}"

# redirect all output to logfile
exec 3>&1 1>> "${logfile}" 2>&1

# log current date, time, and invocation parameters
echo $(date +"%Y-%m-%d %H-%M-%S"): ${0} ${@}

# enable script tracing
set -o xtrace

start() {
  local PORT=""
  [[ ! -f "${conffile}" ]] && PORT=":8081"
  rm -f "${pidfile}"
  PATH="${prog_dir}/libexec:${DROBOAPPS_DIR}/git/bin:${PATH}" PYTHONPATH="${prog_dir}/lib/python2.7/site-packages" "${python}" "${prog_dir}/app/SABnzbd.py" --server 0.0.0.0${PORT} --config-file "${conffile}" --pidfile "${pidfile}" --daemon
}

_service_start() {
  set +e
  set +u
  start_service
  set -u
  set -e
}

_service_stop() {
  /sbin/start-stop-daemon -K -x "${python}" -p "${pidfile}" -v || echo "${name} is not running" >&3
}

_service_restart() {
  service_stop
  sleep 3
  service_start
}

_service_status() {
  status >&3
}

_service_help() {
  echo "Usage: $0 [start|stop|restart|status|update]" >&3
  set +e
  exit 1
}

case "${1:-}" in
  start|stop|restart|status|update) _service_${1} ;;
  *) _service_help ;;
esac
