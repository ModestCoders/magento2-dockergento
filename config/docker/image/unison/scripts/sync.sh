#!/usr/bin/env bash

usage()
{
    echo "usage: sync -path <path_to_sync>"
}

args="$@"

if [[ ${args} != *"-path "* ]]; then
  usage
  exit 1
fi

su -c "unison sync $args" -s /bin/sh app