#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

SCRIPT_DIR=$(dirname "$(realpath "${BASH_SOURCE}")")

. ${SCRIPT_DIR}/env.sh

build-mirror() {
  install -D -m 644 "repo/${APP_NAME}/${APP_NAME}-${APP_VERSION}.repo" "/etc/yum.repos.d/${APP_NAME}-${APP_VERSION}.repo"
}

build-galera-419() {
  echo "Build galera-4 for MySQL ..."
  APP_NAME="${GALERA4_APP_NAME}"
  APP_VERSION="26.4.19"

  build-mirror

  APP_NAME="${MYSQL_WSREP_80_APP_NAME}"
  APP_VERSION="8.0.37"

  build-mirror
}

build-galera-latest() {
  echo "Build galera-4 latest for MySQL ..."
  APP_NAME="${GALERA4_APP_NAME}"
  APP_VERSION="${LATEST_GALERA_4_VERSION}"

  build-mirror

  APP_NAME="${MYSQL_WSREP_80_APP_NAME}"
  APP_VERSION="${LATEST_MYSQL_WSREP_80_VERSION}"

  build-mirror
}

build-galera-4() {
  build-galera-latest
  build-galera-419
}

build-mirrorall() {
  echo "Build mirror all ..."
  build-galera-4
}

main() {
  case "${1-}" in
  mirror)
    build-mirror
    ;;
  galera4)
    build-galera-4
    ;;
  mirrorall)
    build-mirrorall
    ;;
  *)
    build-mirrorall
    ;;
  esac
}

main "$@"
