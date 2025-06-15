#!/usr/bin/env bash


BASE_LINK="https://scripts.obrishti.ru/icons-spss-27/"

curl() {
  $(type -P curl) -L -q --retry 5 --retry-delay 10 --retry-max-time 60 "$@"
}

check_if_running_as_root() {
  if [[ "$(id -u)" -eq 0 ]]; then
    return 0
  else
    echo "error: You must run this script as root!"
    return 1
  fi
}

select_parameters() {
  case "$1" in
    "install")
      return 0
      ;;
    "remove")
      remove_icons
      ;;
    *)
      echo "error: invalid argument $1"
      return 1
      ;;
  esac
}

check_install_spss() {
  :
}

download_zip() {
  :
}

decompression() {
  :
}

install_icons() {
  :
}

remove_icons() {
  :
}

main() { 

  check_if_running_as_root || return 1
  select_parameters "$@" || return 1
  
}

main "$@"