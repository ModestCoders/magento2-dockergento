#!/usr/bin/env bash
set -eu

${COMMANDS_DIR}/exec.sh php ${MAGENTO_DIR}/bin/magento "$@"