#!/bin/bash
set -euo pipefail

usage() {
  printf "${YELLOW}Usage:${COLOR_RESET}\n"
  echo "  create-project"
  echo ""
  printf "${YELLOW}Description:${COLOR_RESET}\n"
  echo "  This command creates a new magento project from scratch"
}

if [ "$#" != 0 ] && [ "$1" == "--help" ]; then
  usage
  exit 0
fi

overwrite_file_consent() {
  TARGET_FILE=$1

  if [[ -f "${TARGET_FILE}" ]]; then
    read -p "overwrite ${TARGET_FILE}? (y/n [n])? " ANSWER_OVERWRITE_TARGET
    if [ "${ANSWER_OVERWRITE_TARGET}" != "y" ]; then
      printf "${RED} Setup interrupted. This commands needs to overwrite this file.${COLOR_RESET}\n"
      exit 1
    fi
  fi
}

overwrite_file_consent "${COMPOSER_DIR}/composer.json"
overwrite_file_consent ".gitignore"

AVAILABLE_MAGENTO_EDITIONS="community enterprise"
DEFAULT_MAGENTO_EDITION="community"

read -p "Magento edition (community/enterprise [$DEFAULT_MAGENTO_EDITION]): " MAGENTO_EDITION

if [[ $MAGENTO_EDITION == '' ]]; then
  MAGENTO_EDITION=$DEFAULT_MAGENTO_EDITION
fi

if ! $(${TASKS_DIR}/in_list.sh "${MAGENTO_EDITION}" "${AVAILABLE_MAGENTO_EDITIONS}") ; then
  printf "${RED} Setup interrupted. Invalid edition '${MAGENTO_EDITION}' ${COLOR_RESET}\n"
  exit 1
fi

read -p "Magento version: " MAGENTO_VERSION

${TASKS_DIR}/start_service_if_not_running.sh ${SERVICE_APP}

CREATE_PROJECT_TMP_DIR="dockergento-create-project-tmp"
${COMMANDS_DIR}/exec.sh sh -c "rm -rf ${CREATE_PROJECT_TMP_DIR}/*"
${COMMANDS_DIR}/exec.sh composer create-project --no-install --repository=https://repo.magento.com/ magento/project-${MAGENTO_EDITION}-edition ${CREATE_PROJECT_TMP_DIR} ${MAGENTO_VERSION}

echo " > Copying project files into host"
${COMMANDS_DIR}/exec.sh sh -c "cat ${CREATE_PROJECT_TMP_DIR}/composer.json > ${COMPOSER_DIR}/composer.json"
CONTAINER_ID=$(${DOCKER_COMPOSE} ps -q ${SERVICE_PHP})
docker cp ${CONTAINER_ID}:${WORKDIR_PHP}/${CREATE_PROJECT_TMP_DIR}/.gitignore .gitignore
${COMMANDS_DIR}/exec.sh sh -c "rm -rf ${CREATE_PROJECT_TMP_DIR}"

echo ""

COMPOSER_EDITION_NEEDED=false
if [[ "${MAGENTO_DIR}" != "${COMPOSER_DIR}" ]]; then
  COMPOSER_EDITION_NEEDED=true
  printf "${YELLOW}Warning:${COLOR_RESET} magento dir is not the same as composer dir\n"
  echo "  Magento dir: '${MAGENTO_DIR}'"
  echo "  Composer dir: '${COMPOSER_DIR}'"
fi

if [[ "${MAGENTO_DIR}/vendor/bin" != "${BIN_DIR}" ]]; then
  COMPOSER_EDITION_NEEDED=true
  printf "${YELLOW}Warning:${COLOR_RESET} bin dir is not inside magento dir\n"
  echo "  Magento dir: '${MAGENTO_DIR}'"
  echo "  Bin dir: '${BIN_DIR}'"
fi

if [[ ${COMPOSER_EDITION_NEEDED} == true ]]; then
  printf "${YELLOW}Edit ${COMPOSER_DIR}/composer.json accordingly and execute:\n"
  echo ""
  echo "  dockergento composer install"
  echo ""
  exit 0
fi

${COMMANDS_DIR}/composer.sh install
