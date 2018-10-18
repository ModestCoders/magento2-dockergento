#!/usr/bin/env bash
set -euo pipefail

${COMMANDS_DIR}/exec.sh php ${MAGENTO_DIR}/bin/magento "$@"