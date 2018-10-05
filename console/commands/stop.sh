#!/usr/bin/env bash
set -eu

${DOCKER_COMPOSE} stop "$@"