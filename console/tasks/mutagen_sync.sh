#!/usr/bin/env bash
set -euo pipefail

if ! which mutagen >/dev/null; then
  printf "${RED}mutagen not found${COLOR_RESET}\n"
  printf " Execute ${GREEN}brew install havoc-io/mutagen/mutagen${COLOR_RESET} in order to install it.\n"
  exit 1
fi

PHP_CONTAINER_ID=$(${DOCKER_COMPOSE} ps -q ${SERVICE_PHP})
SYNC_NAME="dockergento"
CODE_SYNC_ALPHA="$(pwd -P)/$MAGENTO_DIR"
CODE_SYNC_BETA="docker://$PHP_CONTAINER_ID$WORKDIR_PHP/$MAGENTO_DIR"

mutagen_sync_start() {
  mutagen_sync_terminate

  mutagen sync create -c "${CONFIG_DIR}/mutagen/mutagen.yml" \
    --label "${SYNC_NAME}=${COMPOSE_PROJECT_NAME}" \
    "${CODE_SYNC_ALPHA}" "${CODE_SYNC_BETA}"

  printf " > waiting for initial synchronization to complete"
  while ! mutagen sync list --label-selector "${SYNC_NAME}=${COMPOSE_PROJECT_NAME}" |
    grep -i 'watching for changes' >/dev/null; do
    if mutagen sync list --label-selector "${SYNC_NAME}=${COMPOSE_PROJECT_NAME}" |
      grep -i 'Last error' >/dev/null; then
      MUTAGEN_ERROR=$(mutagen sync list --label-selector "${SYNC_NAME}=${COMPOSE_PROJECT_NAME}" |
        sed -n 's/Last error: \(.*\)/\1/p')
      printf >&2 "\033[31m\nMutagen encountered an error during sync: ${MUTAGEN_ERROR}\n\033[0m"
      exit 1
    fi
    printf .
    sleep 1
  done

  printf "\n";
}

mutagen_sync_terminate() {
  mutagen sync terminate --label-selector "${SYNC_NAME}=${COMPOSE_PROJECT_NAME}"
}

case "$1" in
start)
  mutagen_sync_start
  ;;
stop)
  mutagen_sync_terminate
  ;;
esac
