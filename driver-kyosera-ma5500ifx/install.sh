#!/usr/bin/env bash


DOWNLOAD_LINK="https://scripts.obrishti.ru/ma5500ifx/Kyosera_MA5500ifx.zip"

declare -A FILES=(
  ["kyofilter_H"]="755 /usr/lib/cups/filter"
  ["kyofilter_kpsl_H"]="755 /usr/lib/cups/filter"
  ["kyofilter_pdf_H"]="755 /usr/lib/cups/filter"
  ["kyofilter_pre_H"]="755 /usr/lib/cups/filter"
  ["kyofilter_ras_H"]="755 /usr/lib/cups/filter"
  ["Kyocera_ECOSYS_MA5500ifx"]="644 /usr/share/cups/model/"
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



main() { 

}

main "$@"