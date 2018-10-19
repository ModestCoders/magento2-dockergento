#!/usr/bin/env bash
set -euo pipefail

read -p "Remove containers and volumes from all your projects (y/n [n])? " ANSWER
if [ "${ANSWER}" != "y" ]; then
  echo ""
  printf "> ${GREEN}Action interrupted${COLOR_RESET}\n"
  exit 0;
fi

${COMMANDS_DIR}/docker-stop-all.sh
printf "${GREEN}Removing all containers and volumes${COLOR_RESET}\n"
docker rm $(docker ps -qa) && docker volume rm $(docker volume ls -q)

read -p "Remove all images too (y/n [n])? " ANSWER_IMAGES
if [ "${ANSWER_IMAGES}" == "y" ]; then
  docker rmi -f $(docker images -q)
else
  printf "> ${GREEN} Images skipped${COLOR_RESET}\n"
fi