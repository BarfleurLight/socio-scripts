#!/usr/bin/env bash


check_if_running_as_root() {
  if [[ "$(id -u)" -eq 0 ]]; then
    return 0
  else
    echo "error: You must run this script as root!"
    return 1
  fi
}

main() { 
  check_if_running_as_root || return 1
}

main "$@"