#!/usr/bin/env bash


DOWNLOAD_LINK="https://scripts.obrishti.ru/ma5500ifx/Kyosera_MA5500ifx.zip"

declare -A FILES=(
  ["kyofilter_H"]="755 /usr/lib/cups/filter"
  ["kyofilter_kpsl_H"]="755 /usr/lib/cups/filter"
  ["kyofilter_pdf_H"]="755 /usr/lib/cups/filter"
  ["kyofilter_pre_H"]="755 /usr/lib/cups/filter"
  ["kyofilter_ras_H"]="755 /usr/lib/cups/filter"
  ["Kyocera_ECOSYS_MA5500ifx.ppd"]="644 /usr/share/cups/model/"
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

select_parameters() {
  case "$1" in
    "install")
      return 0
      ;;
    "remove")
      remove_files
      ;;
    *)
      echo "error: invalid argument $1"
      return 1
      ;;
  esac
}

remove_files() {
  delete_files=("$TMP_DIRECTORY")

  for src in "${!FILES[@]}"; do
    delete_files+=("${FILES[$src]}$src")
  done

  if ! rm -rf "${delete_files[@]}"; then
    echo 'error: Files not exist.'
    exit 1
  fi

  echo "info: All failes remove"
  exit 0
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

install_files() {
  for src in "${!FILES[@]}"; do
    arr=(${FILES[$src]})
    install -Dm "${arr[0]}" "$TMP_DIRECTORY/$src" "${arr[1]}/$src" || return 1
  done
}

main() { 
  check_if_running_as_root || return 1
  select_parameters "$@" || return 1

  TMP_DIRECTORY="$(mktemp -d)"
  ZIP_FILE="${TMP_DIRECTORY}/Kyosera_MA5500ifx.zip"
  
  download_and_unzip || remove_files
  install_files || remove_files

  echo "Driver install!"
  echo "Reboot the system"
}

main "$@"
