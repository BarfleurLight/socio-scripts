#!/usr/bin/env bash


DOWNLOAD_LINK="https://scripts.obrishti.ru/icons-spss-27/spss-icons.zip"
SPSS_DIR="/opt/IBM/SPSS/Statistics/27/"

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

check_install_spss() {
  if [ -d "$SPSS_DIR" ]; then
    return 0
  else
    echo "error: SPSS 27 not install!"
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

download_and_unzip() {
  if ! curl -fsS -o "$ZIP_FILE" "$DOWNLOAD_LINK"; then
    echo 'error: Download failed! Please check your network or try again.'
    return 1
  fi

  if ! unzip -q "$ZIP_FILE" -d "$TMP_DIRECTORY"; then
    echo "error: $TMP_DIRECTORY"
    return 1
  fi
}

install_icons() {
  :
}

remove_files() {
  :
}

main() { 

  check_if_running_as_root || return 1
  select_parameters "$@" || return 1
  check_install_spss || return 1

  TMP_DIRECTORY="$(mktemp -d)"
  ZIP_FILE="${TMP_DIRECTORY}/spss-icons.zip"

  download_and_unzip || remove_files

  


  
}

main "$@"