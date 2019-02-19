#!/usr/bin/env bash
set -euo pipefail

${COMMANDS_DIR}/exec.sh n98-magerun2 --root-dir=${MAGENTO_DIR} "$@"