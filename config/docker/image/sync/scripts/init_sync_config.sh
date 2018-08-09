#!/usr/bin/env bash
set -eo pipefail

log_heading() {
  echo ""
  echo "==> $*"
}

log_info() {
  echo "-----> $*"
}

log_error_exit() {
  echo " !  Error:"
  echo " !     $*"
  echo " !     Aborting!"
  exit 1
}

: ${SYNC_SOURCE_BASE_PATH:="/sync"}
: ${SYNC_DESTINATION_BASE_PATH:="/var/www/html"}
: ${SYNC_PREFER:="newer"}
: ${SYNC_SILENT:="0"}
: ${SYNC_MAX_INOTIFY_WATCHES:=''}
: ${SYNC_EXTRA_UNISON_PROFILE_OPTS:=''}
: ${SYNC_NODELETE_SOURCE:="0"}

log_heading "Configuration:"
log_info "SYNC_SOURCE_BASE_PATH:        $SYNC_SOURCE_BASE_PATH"
log_info "SYNC_DESTINATION_BASE_PATH:   $SYNC_DESTINATION_BASE_PATH"

[ -d "$SYNC_SOURCE_BASE_PATH" ] || log_error_exit "Source directory does not exist!"
[ -d "$SYNC_DESTINATION_BASE_PATH" ] || log_error_exit "Destination directory does not exist!"
[[ "$SYNC_SOURCE_BASE_PATH" != "$SYNC_DESTINATION_BASE_PATH" ]] || log_error_exit "Source and destination must be different directories!"

if [ -n "${SYNC_MAX_INOTIFY_WATCHES}" ]; then
  if [ -z "$(sysctl -p)" ]; then
    echo fs.inotify.max_user_watches=$SYNC_MAX_INOTIFY_WATCHES | tee -a /etc/sysctl.conf && sysctl -p
  else
    log_info "Looks like /etc/sysctl.conf already has fs.inotify.max_user_watches defined."
    log_info "Skipping this step."
  fi
fi

prefer="prefer=newer"
if [ -z "${SYNC_PREFER}" ]; then
  prefer="prefer=${SYNC_PREFER}"
fi

silent="silent=false"
if [[ "$SYNC_SILENT" == "1" ]]; then
  silent="silent=true"
fi

nodeletion=""
if [[ "$SYNC_NODELETE_SOURCE" == "1" ]]; then
  nodeletion="nodeletion=${SYNC_SOURCE_BASE_PATH}"
fi

echo "
# Sync roots
root = $SYNC_SOURCE_BASE_PATH
root = $SYNC_DESTINATION_BASE_PATH

# Sync options
auto=true
backups=false
batch=true
contactquietly=true
fastcheck=true
maxthreads=10
$prefer
$silent
$nodeletion

# Files to ignore
ignore = Path .git/*
ignore = Path .idea/*
ignore = Name *___jb_tmp___*
ignore = Name {.*,*}.sw[pon]

# Additional user configuration
$SYNC_EXTRA_UNISON_PROFILE_OPTS

" > /home/app/.unison/common

echo "
include common

" > /home/app/.unison/sync

echo "
repeat=watch
include common

" > /home/app/.unison/watch