#!/usr/bin/env sh
#
# SABnzbd service

# import DroboApps framework functions
. /etc/service.subr

framework_version="2.1"
name="sabnzbd"
version="0.7.20-1"
description="SABnzbd is a Usenet binary newsreader"
depends="python2"
webui="WebUI"

prog_dir="$(dirname "$(realpath "${0}")")"
daemon="${DROBOAPPS_DIR}/python2/bin/python"
conffile="${prog_dir}/data/sabnzbd.ini"
tmp_dir="/tmp/DroboApps/${name}"
pidfile="${tmp_dir}/pid.txt"
logfile="${tmp_dir}/log.txt"
statusfile="${tmp_dir}/status.txt"
errorfile="${tmp_dir}/error.txt"
nicelevel=19

# backwards compatibility
if [ -z "${FRAMEWORK_VERSION:-}" ]; then
  framework_version="2.0"
  . "${prog_dir}/libexec/service.subr"
fi

start() {
  local PORT=""
  if [ ! -f "${conffile}" ]; then PORT=":8081"; fi
  HOME="${prog_dir}/data" \
  PATH="${prog_dir}/libexec:${DROBOAPPS_DIR}/git/bin:${PATH}" \
  PYTHONPATH="${prog_dir}/lib/python2.7/site-packages" \
  "${daemon}" "${prog_dir}/app/SABnzbd.py" --server 0.0.0.0${PORT} --config-file "${conffile}" --pidfile "${pidfile}" --browser 0 --daemon
  sleep 1
  renice "${nicelevel}" $(cat "${pidfile}")
}

# boilerplate
if [ ! -d "${tmp_dir}" ]; then mkdir -p "${tmp_dir}"; fi
exec 3>&1 4>&2 1>> "${logfile}" 2>&1
STDOUT=">&3"
STDERR=">&4"
echo "$(date +"%Y-%m-%d %H-%M-%S"):" "${0}" "${@}"
set -o errexit  # exit on uncaught error code
set -o nounset  # exit on unset variable
set -o xtrace   # enable script tracing

main "${@}"
