#!/usr/bin/env bash
set -euo pipefail

DOCKER_ROOT_COMMAND="${COMMANDS_DIR}/docker-compose.sh exec -T -u root"

prepare_container_to_change_user_ids ()
{
    SERVICE=$1
    if ! ${DOCKER_ROOT_COMMAND} ${SERVICE} sh -c "type usermod >/dev/null 2>&1" || \
       ! ${DOCKER_ROOT_COMMAND} ${SERVICE} sh -c "type groupmod >/dev/null 2>&1"; then
      if ${DOCKER_ROOT_COMMAND} ${SERVICE} sh -c "type apk /dev/null 2>&1"; then
        echo "Warning: installing shadow, this should be included in your image"
        ${DOCKER_ROOT_COMMAND} ${SERVICE} sh -c "apk add --no-cache shadow"
      else
        printf "${RED}Error: Commands usermod and groupmod are required.${COLOR_RESET}\n"
        exit 1
      fi
    fi
}

match_user_id_between_host_and_container ()
{
    SERVICE=$1
    CONTAINER_UID=$(${DOCKER_ROOT_COMMAND} ${SERVICE} sh -c "getent passwd ${USER_PHP} | cut -f3 -d:")
    HOST_UID=$(id -u "$USER")

    if [[ ${HOST_UID} == '0' ]]; then
        printf "${RED}Error: Something is wrong, HOST_UID cannot have id 0 (root).${COLOR_RESET}\n"
        exit 1
    fi

    if [ "${CONTAINER_UID}" != "${HOST_UID}" ]; then
        echo " > changing UID of ${USER_PHP} from ${CONTAINER_UID} to ${HOST_UID} in ${SERVICE} service"
        prepare_container_to_change_user_ids "${SERVICE}"
        ${DOCKER_ROOT_COMMAND} ${SERVICE} sh -c "usermod -u ${HOST_UID} -o ${USER_PHP}"
        ${DOCKER_ROOT_COMMAND} ${SERVICE} sh -c "find / -xdev -user '${CONTAINER_UID}' -exec chown -h '${USER_PHP}' {} \;"
    fi
}

match_group_id_between_host_and_container ()
{
    SERVICE=$1
    CONTAINER_GID=$(${DOCKER_ROOT_COMMAND} ${SERVICE} sh -c "getent group ${GROUP_PHP} | cut -f3 -d:")
    HOST_GID=$(id -g "$USER")

    if [[ ${HOST_GID} == '0' ]]; then
        printf "${RED}Error: Something is wrong, HOST_UID cannot have id 0 (root).${COLOR_RESET}\n"
    fi

    if [ "${CONTAINER_GID}" != "${HOST_GID}" ]; then
        echo " > changing GID of ${USER_PHP} from ${CONTAINER_GID} to ${HOST_GID} in ${SERVICE} service"
        prepare_container_to_change_user_ids "${SERVICE}"
        ${DOCKER_ROOT_COMMAND} ${SERVICE} sh -c "groupmod -g ${HOST_GID} -o ${GROUP_PHP}"
        ${DOCKER_ROOT_COMMAND} ${SERVICE} sh -c "find / -xdev -user '${CONTAINER_GID}' -exec chgrp -h '${USER_PHP}' {} \;"
    fi
}

for SERVICE in ${SERVICES_WITH_LINUX_PERMISSIONS_ISSUES}
do
    match_user_id_between_host_and_container "${SERVICE}"
    match_group_id_between_host_and_container "${SERVICE}"
done
