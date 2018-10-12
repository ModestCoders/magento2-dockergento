#!/usr/bin/env bash
set -euo pipefail

remove_magento_dir_prefix()
{
    PATH_TO_MIRROR=$1
    echo "${PATH_TO_MIRROR#"${MAGENTO_DIR}/"}"
}

remove_magento_slash_at_end()
{
    PATH_TO_MIRROR=$1
    echo "${PATH_TO_MIRROR%/}"
}

add_magento_dir_prefix()
{
    PATH_TO_MIRROR=$1
    echo "${MAGENTO_DIR}/${PATH_TO_MIRROR}"
}

sanitize_mirror_path()
{
    PATH_TO_MIRROR=$1

    PATH_TO_MIRROR=$(remove_magento_dir_prefix "${PATH_TO_MIRROR}")
    PATH_TO_MIRROR=$(remove_magento_slash_at_end "${PATH_TO_MIRROR}")
    PATH_TO_MIRROR=$(add_magento_dir_prefix "${PATH_TO_MIRROR}")

    echo ${PATH_TO_MIRROR}
}

validate_mirror_path()
{
    PATH_TO_MIRROR=$1
    for ALLOWED_PATH in ${MIRROR_PATHS_ALLOWED}
    do
        if [[ ${PATH_TO_MIRROR} == "${MAGENTO_DIR}/${ALLOWED_PATH}" \
           || ${PATH_TO_MIRROR} == "${MAGENTO_DIR}/${ALLOWED_PATH}"* ]]
        then
            return 0
        fi
    done

    printf "${RED}Mirror path is not valid.${COLOR_RESET}\n"
    echo ""
    echo " Valid values are: '${MIRROR_PATHS_ALLOWED}'"
    echo ""
    exit 1
}