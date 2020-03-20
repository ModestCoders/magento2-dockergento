#!/usr/bin/env bash
set -euo pipefail

DOCKERGENTO_CONFIG_DIR="config/dockergento"

copy_with_consent()
{
    SOURCE_PATH=$1
    TARGET_PATH=$2
    if [[ -e "${TARGET_PATH}" ]]; then
        read -p "overwrite ${TARGET_PATH}? (y/n [n])? " ANSWER_OVERWRITE_TARGET
        if [ "${ANSWER_OVERWRITE_TARGET}" != "y" ]; then
            printf "${RED} Setup interrupted. '${TARGET_PATH}' exists. Please remove it and try again.${COLOR_RESET}\n"
            exit 1
        fi
    fi
    echo " > cp ${SOURCE_PATH} -> ${TARGET_PATH}"
    mkdir -p $(dirname ${TARGET_PATH})
    cp -Rf ${SOURCE_PATH} ${TARGET_PATH}
}

sanitize_path()
{
    PATH_TO_SANITIZE=$1

    SANITIZED_PATH=${PATH_TO_SANITIZE#/}
    SANITIZED_PATH=${SANITIZED_PATH#./}
    SANITIZED_PATH=${SANITIZED_PATH%/}
    echo "${SANITIZED_PATH}"
}

sed_in_file()
{
    SED_REGEX=$1
    TARGET_PATH=$2
    if [[ "${MACHINE}" == "mac" ]]; then
        sed -i '' "${SED_REGEX}" "${TARGET_PATH}"
    else
        sed -i "${SED_REGEX}" "${TARGET_PATH}"
    fi
}

printf "${GREEN}Setting up dockergento config files${COLOR_RESET}\n"
copy_with_consent "${DOCKERGENTO_DIR}/${DOCKERGENTO_CONFIG_DIR}/" "${DOCKERGENTO_CONFIG_DIR}"
copy_with_consent "${DOCKERGENTO_DIR}/docker-compose/docker-compose.sample.yml" "${DOCKER_COMPOSE_FILE}"
copy_with_consent "${DOCKERGENTO_DIR}/docker-compose/docker-compose.dev.linux.sample.yml" "${DOCKER_COMPOSE_FILE_LINUX}"
copy_with_consent "${DOCKERGENTO_DIR}/docker-compose/docker-compose.dev.mac.sample.yml" "${DOCKER_COMPOSE_FILE_MAC}"
#copy_with_consent "${DOCKERGENTO_DIR}/docker-compose/docker-compose.dev.windows.sample.yml" "${DOCKER_COMPOSE_FILE_WINDOWS}"

read -p "Magento root dir: [${MAGENTO_DIR}] " ANSWER_MAGENTO_DIR
MAGENTO_DIR=${ANSWER_MAGENTO_DIR:-${MAGENTO_DIR}}

if [ "${MAGENTO_DIR}" != "." ]; then
	printf "${GREEN}Setting custom magento dir: '${MAGENTO_DIR}'${COLOR_RESET}\n"
    MAGENTO_DIR=$(sanitize_path "${MAGENTO_DIR}")
    printf "${YELLOW}"
    echo "------ ${DOCKER_COMPOSE_FILE} ------"
	sed_in_file "s#/html/var/composer_home#/html/${MAGENTO_DIR}/var/composer_home#gw /dev/stdout" "${DOCKER_COMPOSE_FILE}"
	echo "--------------------"
    echo "------ ${DOCKER_COMPOSE_FILE_MAC} ------"
	sed_in_file "s#/app:#/${MAGENTO_DIR}/app:#gw /dev/stdout" "${DOCKER_COMPOSE_FILE_MAC}"
	sed_in_file "s#/vendor#/${MAGENTO_DIR}/vendor#gw /dev/stdout" "${DOCKER_COMPOSE_FILE_MAC}"
    echo "--------------------"
#    echo "------ ${DOCKER_COMPOSE_FILE_WINDOWS} ------"
#	sed_in_file "s#/app:#/${MAGENTO_DIR}/app:#gw /dev/stdout" "${DOCKER_COMPOSE_FILE_WINDOWS}"
#	sed_in_file "s#/html/app#/html/${MAGENTO_DIR}/app#gw /dev/stdout" "${DOCKER_COMPOSE_FILE_WINDOWS}"
#	sed_in_file "s#/vendor#/${MAGENTO_DIR}/vendor#gw /dev/stdout" "${DOCKER_COMPOSE_FILE_WINDOWS}"
#    echo "--------------------"
    echo "------ ${DOCKERGENTO_CONFIG_DIR}/nginx/conf/default.conf ------"
    sed_in_file "s#/var/www/html#/var/www/html/${MAGENTO_DIR}#gw /dev/stdout" "${DOCKERGENTO_CONFIG_DIR}/nginx/conf/default.conf"
    echo "--------------------"
    printf "${COLOR_RESET}"
fi

read -p "Composer dir: [${COMPOSER_DIR}] " ANSWER_COMPOSER
COMPOSER_DIR=${ANSWER_COMPOSER:-"."}

if [ "${COMPOSER_DIR}" != "." ]; then
    printf "${GREEN}Setting custom composer paths: '${COMPOSER_DIR}'${COLOR_RESET}\n"
    COMPOSER_DIR=$(sanitize_path "${COMPOSER_DIR}")
    printf "${YELLOW}"
    echo "------ ${DOCKER_COMPOSE_FILE_MAC} ------"
	sed_in_file "s#/composer.json#/${COMPOSER_DIR}/composer.json#gw /dev/stdout" "${DOCKER_COMPOSE_FILE_MAC}"
	sed_in_file "s#/composer.lock#/${COMPOSER_DIR}/composer.lock#gw /dev/stdout" "${DOCKER_COMPOSE_FILE_MAC}"
    echo "--------------------"
#    echo "------ ${DOCKER_COMPOSE_FILE_WINDOWS} ------"
#	sed_in_file "s#/composer.json#/${COMPOSER_DIR}/composer.json#gw /dev/stdout" "${DOCKER_COMPOSE_FILE_WINDOWS}"
#	sed_in_file "s#/composer.lock#/${COMPOSER_DIR}/composer.lock#gw /dev/stdout" "${DOCKER_COMPOSE_FILE_WINDOWS}"
#    echo "--------------------"
    printf "${COLOR_RESET}\n"
fi

if [ ! -f "${COMPOSER_DIR}/composer.json" ]; then
    printf "${GREEN}Creating non existing '${COMPOSER_DIR}/composer.json'${COLOR_RESET}\n"
    mkdir -p ${COMPOSER_DIR}
    echo "{}" > ${COMPOSER_DIR}/composer.json
fi
if [ ! -f "${COMPOSER_DIR}/composer.lock" ]; then
    printf "${GREEN}Creating non existing '${COMPOSER_DIR}/composer.lock'${COLOR_RESET}\n"
    echo "{}" > ${COMPOSER_DIR}/composer.lock
fi

read -p "Composer bin dir: [${BIN_DIR}] " ANSWER_BIN_DIR
BIN_DIR=${ANSWER_BIN_DIR:-${BIN_DIR}}

printf "${GREEN}Setting bind configuration for files in git repository${COLOR_RESET}\n"
add_git_bind_paths_in_file()
{
    GIT_FILES=$1
    FILE_TO_EDIT=$2
    SUFFIX_BIND_PATH=$3

    BIND_PATHS=""
    while read FILENAME_IN_GIT; do
        if [[ "${MAGENTO_DIR}" == "${FILENAME_IN_GIT}" ]] || \
            [[ "${MAGENTO_DIR}" == "${FILENAME_IN_GIT}/"* ]] || \
            [[ "${FILENAME_IN_GIT}" == "vendor" ]] || \
            [[ "${FILENAME_IN_GIT}" == "${DOCKER_COMPOSE_FILE%.*}"* ]]; then
            continue
        fi
        NEW_PATH="./${FILENAME_IN_GIT}:/var/www/html/${FILENAME_IN_GIT}"
        BIND_PATH_EXISTS=$(grep -q -e "${NEW_PATH}" ${FILE_TO_EDIT} && echo true || echo false)
        if [ "${BIND_PATH_EXISTS}" == true ]; then
            continue
        fi
        if [ "${BIND_PATHS}" != "" ]; then
            BIND_PATHS="${BIND_PATHS}\\
      " # IMPORTANT: This must be a new line with 6 indentation spaces.
        fi
        BIND_PATHS="${BIND_PATHS}- ${NEW_PATH}${SUFFIX_BIND_PATH}"

    done <<< "${GIT_FILES}"

    printf "${YELLOW}"
    echo "------ ${FILE_TO_EDIT} ------"
    sed_in_file "s|# {FILES_IN_GIT}|${BIND_PATHS}|w /dev/stdout" "${FILE_TO_EDIT}"
    echo "--------------------"
    printf "${COLOR_RESET}"
}

if [[ -f ".git/HEAD" ]]; then
    GIT_FILES=$(git ls-files | awk -F / '{print $1}' | uniq)
    if [[ "${GIT_FILES}" != "" ]]; then
        add_git_bind_paths_in_file "${GIT_FILES}" "${DOCKER_COMPOSE_FILE_MAC}" ":delegated"
#        add_git_bind_paths_in_file "${GIT_FILES}" "${DOCKER_COMPOSE_FILE_WINDOWS}" ""
    else
        echo " > Skipped. There are no files added in this repository"
    fi
else
    echo " > Skipped. This is not a git repository"
fi

echo "PHP version:"
DEFAULT_PHP_VERSION="7.1"
AVAILABLE_PHP_VERSIONS="7.0 7.1 7.2 7.3"
select PHP_VERSION in ${AVAILABLE_PHP_VERSIONS}; do
    if $(${TASKS_DIR}/in_list.sh "${PHP_VERSION}" "${AVAILABLE_PHP_VERSIONS}"); then
        break
    fi
    if $(${TASKS_DIR}/in_list.sh "${REPLY}" "${AVAILABLE_PHP_VERSIONS}"); then
        PHP_VERSION=${REPLY}
        break
    fi
    echo "invalid option '${REPLY}'"
done

printf "${GREEN}Setting php version: '${PHP_VERSION}'${COLOR_RESET}\n"
if [ "${PHP_VERSION}" != "${DEFAULT_PHP_VERSION}" ]; then
    printf "${YELLOW}"
    echo "------ ${DOCKER_COMPOSE_FILE} ------"
	sed_in_file "s#php:${DEFAULT_PHP_VERSION}#php:${PHP_VERSION}#gw /dev/stdout" "${DOCKER_COMPOSE_FILE}"
	sed_in_file "s#php${DEFAULT_PHP_VERSION}#php${PHP_VERSION}#gw /dev/stdout" "${DOCKER_COMPOSE_FILE}"
    echo "--------------------"
    printf "${COLOR_RESET}\n"
fi

read -p "[OPTIONAL] Docker compose project name: [${COMPOSER_PROJECT_NAME-}]" ANSWER_PROJECT_NAME
PROJECT_NAME=${ANSWER_PROJECT_NAME-}
if [[ ! -z "${PROJECT_NAME}" ]];then
    printf "${GREEN}Setting custom project name: '${PROJECT_NAME}'\n"
    printf "This will serve as docker object (container, volume, network) prefix.\n"
    printf "${COLOR_RESET}"
    COMPOSE_PROJECT_NAME="${PROJECT_NAME}"
fi

printf "${GREEN}Saving custom properties file: '${DOCKERGENTO_CONFIG_DIR}/properties'${COLOR_RESET}\n"
cat << EOF > ./${DOCKERGENTO_CONFIG_DIR}/properties
MAGENTO_DIR="${MAGENTO_DIR}"
COMPOSER_DIR="${COMPOSER_DIR}"
BIN_DIR="${BIN_DIR}"
COMPOSE_PROJECT_NAME="${COMPOSE_PROJECT_NAME}"
EOF

# Stop running containers in case that setup was executed in an already running project
${COMMANDS_DIR}/stop.sh

echo ""
printf "${YELLOW}-------- IMPORTANT INFO: -----------${COLOR_RESET}\n"
echo ""
echo "   Docker bind paths were automatically added here:"
echo ""
echo "      * ${DOCKER_COMPOSE_FILE_MAC}"
#echo "     * ${DOCKER_COMPOSE_FILE_WINDOWS}"
echo ""
echo "   Please check that they are right or edit them accordingly."
echo "   Be aware that vendor cannot be bound for performance reasons."
echo ""
printf "${YELLOW}-------------------------------------${COLOR_RESET}\n"

echo ""
printf "${GREEN}Dockergento set up successfully!${COLOR_RESET}\n"
echo ""
