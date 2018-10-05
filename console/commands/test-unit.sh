#!/usr/bin/env bash
set -eu

${COMMANDS_DIR}/exec.sh ${BIN_DIR}/phpunit --config ${MAGENTO_DIR}/dev/tests/unit/phpunit.xml "$@"