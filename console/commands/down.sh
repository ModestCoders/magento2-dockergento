#!/usr/bin/env bash
set -euo pipefail

${DOCKER_COMPOSE} down "$@"