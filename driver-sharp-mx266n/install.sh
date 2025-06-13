#!/usr/bin/env bash


BASE_LINK="https://scripts.obrishti.ru/mx266n/"

declare -A FILES=(
  ["filter/sv2epjl"]="/usr/lib/cups/"
  ["mime/sv2ecnv.convs"]="/usr/share/cups/"
  ["mime/sv2etyp.types"]="/usr/share/cups/"
  ["Sharp-UD-Color-PCL6.ppd"]="/usr/share/cups/model/"
  ["Sharp-UD-Mono-PCL6.ppd"]="/usr/share/cups/model/"
)

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

remove_driver() {

  delete_files=()
  for relative_path in "${!FILES[@]}"; do
    delete_files+=("${FILES[$relative_path]}$relative_path")
  done
    
  if ! rm -rf "${delete_files[@]}"; then
    echo 'error: Files not exist.'
    exit 1
  fi

  echo "info: All failes remove"
  exit 0
}

main() { 
  check_if_running_as_root || return 1

}

main "$@"