#!/bin/bash

set -ue

#
# Logging
#
logging() {
  echo "$2"
  /usr/bin/logger -is -p "$1" -t "FI-BB" "$2"
}

#
# Install kcov
#
install_kcov() {
  logging "user.info" "${FUNCNAME[0]}"

  if type kcov >/dev/null 2>&1; then
    return
  fi
  sudo apt update
  sudo apt-get -y install binutils-dev libiberty-dev libcurl4-openssl-dev libelf-dev libdw-dev cmake gcc g++

  pushd /opt
  sudo sh -c "curl -sSL https://github.com/SimonKagstrom/kcov/archive/refs/tags/38.tar.gz | tar xz"
  sudo mkdir kcov-38/build
  cd kcov-38/build
  sudo cmake ..
  sudo make install
  popd
}

#
# Reset env
#
reset_env() {
  local
  FILE=docker-compose.yml

  if [ -e "${FILE}" ]; then
    set +e
    sudo docker compose -f "${FILE}" down --remove-orphans
    set -e
    sleep 10
    rm -f "${FILE}"
  fi

  sudo rm -fr config/ data/
  sudo rm -fr fiware
  sudo rm -fr fiware-*
  rm -f Makefile
  rm -f setup_ngsi_go.sh
  git checkout config.sh
}

#
# Wait for serive
#
wait() {
  logging "user.info" "${FUNCNAME[0]}"

  WAIT_TIME=300

  local host
  local ret

  host=$1
  ret=$2

  echo "Wait for ${host} to be ready (${WAIT_TIME} sec)" 1>&2

  for i in $(seq "${WAIT_TIME}")
  do
    # shellcheck disable=SC2086
    if [ "${ret}" == "$(curl ${host} -o /dev/null -w '%{http_code}\n' -s)" ]; then
      return
    fi
    sleep 1
  done

  logging "user.err" "${host}: Timeout was reached."
  exit 1
}

#
# setup
#
setup() {
  logging "user.info" "${FUNCNAME[0]}"

  LANG=C
  LC_TIME=C

  install_kcov

  if [ -d coverage ]; then
    rm -fr coverage
  fi

  mkdir coverage

  MOCK_DIR=${PWD}/.mock
  rm -fr "${MOCK_DIR}"
  mkdir "${MOCK_DIR}"

  if [ -e ~/.bashrc ]; then
    sed -i -e "/ngsi_bash_autocomplete/d" ~/.bashrc
  fi

  sudo rm -f /etc/redhat-release

  local ngsi_go_version
  ngsi_go_version=v0.11.0

  curl -sOL https://github.com/lets-fiware/ngsi-go/releases/download/${ngsi_go_version}/ngsi-${ngsi_go_version}-linux-amd64.tar.gz
  sudo tar zxf ngsi-${ngsi_go_version}-linux-amd64.tar.gz -C /usr/local/bin
  rm -f ngsi-${ngsi_go_version}-linux-amd64.tar.gz

  KCOV="/usr/local/bin/kcov --exclude-path=tests,.git,setup,coverage,.github,.vscode,examples,docs,.mock"

  reset_env
}

fisb_down() {
  logging "user.info" "${FUNCNAME[0]}"

  make down

  while [ "1" != "$(sudo docker ps | wc -l)" ]
  do
    sleep 1
  done

  sleep 5

  # make clean
  FORCE_CLEAN=true ./config/script/clean.sh
}

install_test1() {
  logging "user.info" "${FUNCNAME[0]}"

  sleep 5

  reset_env

  sed -i -e "s/^\(CYGNUS_MONGO=\).*/\1true/" config.sh
  sed -i -e "s/^\(CYGNUS_MYSQL=\).*/\1true/" config.sh
  sed -i -e "s/^\(CYGNUS_POSTGRES=\).*/\1true/" config.sh
  sed -i -e "s/^\(CYGNUS_ELASTICSEARCH=\).*/\1true/" config.sh
  sed -i -e "s/^\(COMET=\).*/\1true/" config.sh
  sed -i -e "s/^\(QUANTUMLEAP=\).*/\1true/" config.sh
  sed -i -e "s/^\(PERSEO=\).*/\1true/" config.sh
  sed -i -e "s/^\(WIRECLOUD=\).*/\1true/" config.sh
  sed -i -e "s/^\(IOTAGENT_UL=\).*/\1true/" config.sh
  sed -i -e "s/^\(IOTAGENT_HTTP=\).*/\1true/" config.sh
  sed -i -e "s/^\(IOTAGENT_MQTT=\).*/\1true/" config.sh
  sed -i -e "s/^\(NODE_RED=\).*/\1true/" config.sh
  sed -i -e "s/^\(START_CONTAINER=\).*/\1N/" config.sh

  ${KCOV} ./coverage ./setup-fiware.sh

  reset_env

  sleep 5
}

install_test2() {
  logging "user.info" "${FUNCNAME[0]}"

  sleep 5

  reset_env

  sed -i -e "s/^\(CYGNUS_MONGO=\).*/\1true/" config.sh
  sed -i -e "s/^\(CYGNUS_MYSQL=\).*/\1true/" config.sh
  sed -i -e "s/^\(CYGNUS_POSTGRES=\).*/\1Y/" config.sh
  sed -i -e "s/^\(CYGNUS_ELASTICSEARCH=\).*/\1true/" config.sh
  sed -i -e "s/^\(ELASTICSEARCH_PASSWORD=\).*/\1elasticsearch/" config.sh
  sed -i -e "s/^\(MYSQL_ROOT_PASSWORD=\).*/\1mysql/" config.sh
  sed -i -e "s/^\(POSTGRES_PASSWORD=\).*/\1postgres/" config.sh
  sed -i -e "s/^\(IOTAGENT_UL=\).*/\1false/" config.sh
  sed -i -e "s/^\(IOTAGENT_JSON=\).*/\1true/" config.sh
  sed -i -e "s/^\(START_CONTAINER=\).*/\1N/" config.sh

  ${KCOV} ./coverage ./setup-fiware.sh

  reset_env

  sleep 5
}

install_test_darwin_arm64() {
  logging "user.info" "${FUNCNAME[0]}"

  sleep 5

  reset_env

  echo -e "#!/bin/bash\nif [ \"\${1}\" = \"-m\" ]; then\necho \"arm64\"\nelif [ \"\${1}\" = \"-s\" ]; then\necho \"Darwin\"\nfi\n" >> "${MOCK_DIR}/uname"
  chmod +x "${MOCK_DIR}/uname"
  export FISB_TEST_UNAME_CMD=${MOCK_DIR}/uname

  echo -e "#!/bin/bash\nF=\${2/darwin/linux}\nF=\${F/arm64/amd64}\ncurl -sLO \$F\nif ! [ \"\${2}\" = \"\${F}\" ]; then\nmv \"\${F##*/}\" \"\${2##*/}\"\nfi" >> "${MOCK_DIR}/curl"
  chmod +x "${MOCK_DIR}/curl"
  export FISB_TEST_CURL_CMD=${MOCK_DIR}/curl

  echo -e "#!/bin/bash\necho \"192.168.0.1\"" >> "${MOCK_DIR}/ipconfig"
  chmod +x "${MOCK_DIR}/ipconfig"
  export FISB_TEST_IPCONFIG_CMD=${MOCK_DIR}/ipconfig

  export LOGGER=true

  sed -i -e "s/^\(WIRECLOUD=\).*/\1y/" config.sh
  sed -i -e "s/^\(START_CONTAINER=\).*/\1n/" config.sh

  ${KCOV} ./coverage ./setup-fiware.sh

  export FISB_TEST_UNAME_CMD=
  rm -f "${MOCK_DIR}/uname"

  export FISB_TEST_CURL_CMD=
  rm -f "${MOCK_DIR}/curl"

  export FISB_TEST_IPCONFIG_CMD=
  rm -f "${MOCK_DIR}/ipconfig"

  export LOGGER=false

  fisb_down

  reset_env

  sleep 5
}

install_no_config_sh() {
  logging "user.info" "${FUNCNAME[0]}"

  sleep 5

  reset_env

  rm -f config.sh

  ${KCOV} ./coverage ./setup-fiware.sh

  fisb_down

  reset_env

  sleep 5
}

error_test() {
  logging "user.info" "${FUNCNAME[0]}"

  sleep 5

  export ERR_CODE=0

  reset_env

  #
  # Unknown machine architecture
  #
  echo "*** Unknown machine architecture ***" 1>&2
  echo -e "#!/bin/bash\nif [ \"\${1}\" = \"-m\" ]; then\necho \"8086\"\nelif [ \"\${1}\" = \"-s\" ]; then\necho \"MS-DOS\"\nfi\n" > "${MOCK_DIR}/uname"
  chmod +x "${MOCK_DIR}/uname"
  export FISB_TEST_UNAME_CMD=${MOCK_DIR}/uname

  ${KCOV} ./coverage ./setup-fiware.sh

  rm -f "${MOCK_DIR}/uname"
  export FISB_TEST_UNAME_CMD=
  reset_env

  #
  # Unknown OS
  #
  echo "*** Unknown OS ***" 1>&2
  echo -e "#!/bin/bash\nif [ \"\${1}\" = \"-m\" ]; then\necho \"x86_64\"\nelif [ \"\${1}\" = \"-s\" ]; then\necho \"MS-DOS\"\nfi\n" > "${MOCK_DIR}/uname"
  chmod +x "${MOCK_DIR}/uname"
  export FISB_TEST_UNAME_CMD=${MOCK_DIR}/uname

  ${KCOV} ./coverage ./setup-fiware.sh

  rm -f "${MOCK_DIR}/uname"
  export FISB_TEST_UNAME_CMD=
  reset_env

  #
  # FIWARE instance already exists
  #
  echo "*** FIWARE instance already exists ***" 1>&2
  mkdir data

  ${KCOV} ./coverage ./setup-fiware.sh

  reset_env

  #
  # IoT Agent UL and IoT Agent JSON cannot be set up on the same instance.
  #
  echo "*** IoT Agent UL and IoT Agent JSON cannot be set up on the same instance. ***" 1>&2

  sed -i -e "s/^\(IOTAGENT_UL=\).*/\1true/" config.sh
  sed -i -e "s/^\(IOTAGENT_JSON=\).*/\1true/" config.sh

  ${KCOV} ./coverage ./setup-fiware.sh

  reset_env

  #
  # Docker not found
  #
  echo "*** Docker not found ***" 1>&2

  export FISB_TEST_DOCKER_CMD=rekcod

  ${KCOV} ./coverage ./setup-fiware.sh

  export FISB_TEST_DOCKER_CMD=
  reset_env

  #
  # Docker compose plugin not found
  #
  echo "*** Docker compose plugin not found ***" 1>&2

  echo -e "#!/bin/bash\necho '{\"ClientInfo\":{\"Plugins\":[{\"Name\":\"buildx\"}]}}'" > "${MOCK_DIR}/docker"
  chmod +x "${MOCK_DIR}/docker"
  export FISB_TEST_DOCKER_CMD=${MOCK_DIR}/docker

  ${KCOV} ./coverage ./setup-fiware.sh

  rm -f "${MOCK_DIR}/docker"
  export FISB_TEST_DOCKER_CMD=
  reset_env

  #
  # not support for arm64
  #
  echo "*** not support for arm64 ***" 1>&2

  echo -e "#!/bin/bash\nif [ \"\${1}\" = \"-m\" ]; then\necho \"arm64\"\nelif [ \"\${1}\" = \"-s\" ]; then\necho \"Darwin\"\nfi\n" >> "${MOCK_DIR}/uname"
  chmod +x "${MOCK_DIR}/uname"
  export FISB_TEST_UNAME_CMD=${MOCK_DIR}/uname

  sed -i -e "s/^\(CYGNUS_ELASTICSEARCH=\).*/\1true/" config.sh

  ${KCOV} ./coverage ./setup-fiware.sh

  rm -f "${MOCK_DIR}/uname"
  export FISB_TEST_UNAME_CMD=

  reset_env

  export ERR_CODE=
}

#
# main
#
main() {
  setup

  install_test1

  install_test2

  install_test_darwin_arm64
  
  install_no_config_sh

  error_test

  echo "Unit test has completed"
}

main "$@"
