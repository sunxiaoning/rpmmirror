#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

SCRIPT_DIR=$(dirname "$(realpath "${BASH_SOURCE}")")

. ${SCRIPT_DIR}/env.sh

install-mirror() {
  APP_DEST_DIR=${REPO_LOCAL_ROOT_PATH}/${APP_NAME}/${APP_VERSION}

  echo "Install App: ${APP_NAME} to ${APP_DEST_DIR} ..."
  mkdir -p ${APP_DEST_DIR}

  yum clean all
  yum makecache
  yum -y remove ${APP_NAME}
  yum autoremove
  yumdownloader --resolve --destdir=${APP_DEST_DIR} ${APP_NAME}-${APP_VERSION}
  createrepo ${APP_DEST_DIR}

  rm -f /etc/yum.repos.d/${APP_NAME}-${APP_VERSION}.repo
}

install-galera-419() {
  dnf -y module disable mysql mariadb

  echo "Install galera-4 for MySQL ..."
  APP_NAME="${GALERA4_APP_NAME}"
  APP_VERSION="26.4.19"
  install-mirror

  APP_NAME="${MYSQL_WSREP_80_APP_NAME}"
  APP_VERSION="8.0.37"

  install-mirror

  dnf -y module enable mysql mariadb
}

install-galera-latest() {
  dnf -y module disable mysql mariadb

  echo "Install galera-4 for MySQL ..."
  APP_NAME="${GALERA4_APP_NAME}"
  APP_VERSION="${LATEST_GALERA_4_VERSION}"
  install-mirror

  APP_NAME="${MYSQL_WSREP_80_APP_NAME}"
  APP_VERSION="${LATEST_MYSQL_WSREP_80_VERSION}"

  install-mirror

  dnf -y module enable mysql mariadb
}

install-galera-4() {
  install-galera-latest
  install-galera-419
}

install-mirrorall() {
  echo "Install mirror all ..."
  install-galera-4
}

main() {
  case "${1-}" in
  mirror)
    install-mirror
    ;;
  galera4)
    install-galera-4
    ;;
  mirrorall)
    install-mirrorall
    ;;
  *)
    install-mirrorall
    ;;
  esac
}

main "$@"
