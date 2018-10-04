#!/usr/bin/env bash
set -eu

${COMMANDS_DIR}/exec.sh sh -c "cd ${MAGENTO_DIR}/dev/tests/integration && ${WORKDIR_PHP}/${BIN_DIR}/phpunit --config phpunit.xml $@"