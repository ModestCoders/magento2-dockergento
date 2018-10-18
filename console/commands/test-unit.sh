#!/usr/bin/env bash
set -euo pipefail

${COMMANDS_DIR}/exec.sh ${BIN_DIR}/phpunit --config ${MAGENTO_DIR}/dev/tests/unit/phpunit.xml "$@"