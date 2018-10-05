#!/usr/bin/env bash
set -eu

${COMMANDS_DIR}/exec.sh sh -c "cd ${MAGENTO_DIR} && rm -rf var/cache/* generated/* pub/static/* var/view_preprocessed/* var/page_cache/* var/generation/* dev/tests/integration/tmp/*"