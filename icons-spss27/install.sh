#!/usr/bin/env bash

DOWNLOAD_LINK="https://scripts.obrishti.ru/icons-spss-27/spss-icons.zip"

SPSS_DIR="/opt/IBM/SPSS/Statistics/27"

declare -A FILES=(
  ["lservrc"]="$SPSS_DIR/bin/"
  ["desktop-icon.svg"]="$SPSS_DIR/"
  ["SPSS.desktop"]="/usr/share/applications/"
  ["x-spss-sps.xml"]="/usr/share/mime/packages/"
  ["x-spss-spv.xml"]="/usr/share/mime/packages/"
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
      remove_files
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

install_files() {
  for size in 16x16 32x32; do
    for file in "$TMP_DIRECTORY/$size"/*; do
      install -Dm 644 "$file" "/usr/share/icons/hicolor/$size/mimetypes/$(basename "$file")" || return 1
    done
  done

  for src in "${!FILES[@]}"; do
    install -Dm 644 "$TMP_DIRECTORY/$src" "${FILES[$src]}/$src" || return 1
  done
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

main() { 
  check_if_running_as_root || return 1
  select_parameters "$@" || return 1
  check_install_spss || return 1

  TMP_DIRECTORY="$(mktemp -d)"
  ZIP_FILE="${TMP_DIRECTORY}/spss-icons.zip"

  download_and_unzip || remove_files
  install_files || remove_files

  update-mime-database /usr/share/mime ||
  echo "error: Update mime"
 
  update-icon-caches /usr/share/icons/hicolor ||
  gtk-update-icon-cache /usr/share/icons/hicolor ||
  echo "error: Update icons cache"
 
  echo "Icons installed"
  echo "To activate, run: sudo /opt/IBM/SPSS/Statistics/27/open.sh"
}

main "$@"