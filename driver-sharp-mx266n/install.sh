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

install_software() {
  package_name="$1"
  
  if apt list --installed "$package_name" 2>/dev/null | grep -q "^$package_name/"; then
    echo "info: $package_name is already installed."
    return 0
  fi
  
  if "apt -y install" "$package_name" >/dev/null 2>&1; then
    echo "info: $package_name is installed."
  else
    echo "error: Installation of $package_name failed, please check your network."
    exit 1
  fi
}

download_files() {
  local download_count=0

  for relative_path in "${!FILES[@]}"; do
    local full_path="${FILES[$relative_path]}$relative_path"
    local target_dir=$(dirname "$full_path")
    mkdir -p "$target_dir"

    if curl -fsS -o "$full_path" "${BASE_LINK}$relative_path"; then
      ((download_count++))
    else
      echo "error: Failed to download $relative_path"
      return 1
    fi
  done

  if ((download_count == 5)); then
    echo 'info: files download'
    chmod 755 "/usr/lib/cups/filter/sv2epjl"
  fi

  return 0
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
  install_software 'curl'

  case "$1" in
    "install")
      download_files || remove_driver
      ;;
    "remove")
      remove_driver
      ;;
    *)
      echo "error: invalid argument $1"
      return 1
      ;;
  esac
  
}

main "$@"
