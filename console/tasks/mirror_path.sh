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
