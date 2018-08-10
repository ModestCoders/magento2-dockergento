#!/usr/bin/env bash

usage()
{
    echo "usage: watch -path <path_to_sync>"
}

args="$@"

if [[ ${args} != *"-path "* ]]; then
  usage
  exit 1
fi

su -c "unison watch $args" -s /bin/sh app