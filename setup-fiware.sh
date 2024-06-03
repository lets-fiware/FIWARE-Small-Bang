#!/bin/bash

# MIT License
#
# Copyright (c) 2023-2024 Kazuhito Suda
#
# This file is part of FIWARE Small Bang
#
# https://github.com/lets-fiware/FIWARE-Small-Bang
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set -Ceuo pipefail

VERSION=0.5.0-next

#
# Syslog info
#
logging_info() {
  ${LOGGING_INFO} && echo "setup: $1" 1>&2
  ${LOGGER} && /usr/bin/logger -i -p "user.info" -t "FI-SB" "setup: $1"
  true
}

#
# Syslog err
#
logging_err() {
  echo "error: $1" 1>&2
  ${LOGGER} && /usr/bin/logger -i -p "user.err" -t "FI-SB" "setup error: $1"
  true
}

#
# Get IP address
#
get_ip_address() {
  logging_info "${FUNCNAME[0]}"

  if [ -z "${IP_ADDRESS}" ]; then
    if [ "${OS}" = "linux" ]; then
      IP_ADDRESS=$(hostname -I | awk '{ print $1 }')
    else
      IP_ADDRESS=$("${IPCONFIG_CMD}" getifaddr en0)
    fi
  fi
}

#
# Check data direcotry
#
check_data_direcotry() {
  logging_info "${FUNCNAME[0]}"

  if [ -d ./data ]; then
    echo "FIWARE instance already exists."
    echo "If you want to create new FIWARE instance, run 'make clean' before running setup-fiware.sh"
    exit "${ERR_CODE}"
  fi
}

#
# Check machine architecture
#
check_machine() {
  logging_info "${FUNCNAME[0]}"

  ARCH=$("${UNAME_CMD}" -m)

  if [ "${ARCH}" = "x86_64" ]; then
    ARCH=amd64
  elif [ "${ARCH}" = "arm64" ] || [ "${ARCH}" = "aarch64" ]; then
    ARCH=arm64
  else
    MSG="Error: ${ARCH} not supported"
    logging_err "${FUNCNAME[0]} ${MSG}"
    exit "${ERR_CODE}"
  fi

  OS=$("${UNAME_CMD}" -s)

  if [ "${OS:0:5}" = "Linux" ]; then
    OS=linux
  elif [ "${OS:0:6}" = "Darwin" ]; then
    OS=darwin
  else
    MSG="Error: ${OS} not supported"
    logging_err "${FUNCNAME[0]} ${MSG}"
    exit "${ERR_CODE}"
  fi

  return
}

#
# Check Docker
#
check_docker() {
  logging_info "${FUNCNAME[0]}"

  if ! type "${DOCKER_CMD}" >/dev/null 2>&1; then
    MSG="Error: docker not found"
    logging_err "${FUNCNAME[0]} ${MSG}"
    exit "${ERR_CODE}" 
  fi

  set +e
  found=$(sudo "${DOCKER_CMD}" info --format '{{json . }}' | ${GREP_CMD} -ic \"compose\")
  set -e
  if [ "${found}" -eq 0 ]; then
    MSG="Error: docker compose plugin not found"
    logging_err "${FUNCNAME[0]} ${MSG}"
    exit "${ERR_CODE}" 
  fi
}

#
# Init command
#
init_cmd() {
  logging_info "${FUNCNAME[0]}"

  SUDO=sudo
  UNAME_CMD="${FISB_TEST_UNAME_CMD:-uname}"
  CURL_CMD="${FISB_TEST_CURL_CMD:-curl}"
  GREP_CMD="${FISB_TEST_GREP_CMD:-grep}"
  DOCKER_CMD="${FISB_TEST_DOCKER_CMD:-docker}"
  DOCKER_COMPOSE="${SUDO} /usr/bin/docker compose"
  IPCONFIG_CMD="${FISB_TEST_IPCONFIG_CMD:-ipconfig}"
}

#
# Init directories
#
init_directories() {
  logging_info "${FUNCNAME[0]}"

  mkdir "${CONFIG_DIR}"
  mkdir "${DATA_DIR}"
}

#
# Check value
#
check_value() {
  logging_info "${FUNCNAME[0]}"

  local VAL
  eval "VAL=\${${1}}"
  # VAL=${VAL,,}
  VAL=$(echo "${VAL}" | tr '[:upper:]' '[:lower:]')

  if [ "${VAL}" = "false" ] || [ "${VAL}" = "true" ]; then
    eval "${1}=\${VAL}"
  elif [ "${VAL}" = "y" ]; then
    eval "${1}"=true
  else
    eval "${1}"=false
  fi
}

#
# Create config sh
#
create_config_sh() {
  logging_info "${FUNCNAME[0]}"

  cat <<'EOF' >> config.sh
#!/bin/bash

# Use Cygnus sink (true or false) Default: false
CYGNUS_MONGO=
CYGNUS_MYSQL=
CYGNUS_POSTGRES=
CYGNUS_ELASTICSEARCH=

# Set passowrd for database systems
ELASTICSEARCH_PASSWORD=
MYSQL_ROOT_PASSWORD=
POSTGRES_PASSWORD=

# Use STH-Comet (true or false) Default: false
COMET=

# Use Quantumleap (true or false) Default: false
QUANTUMLEAP=

# Use Perseo (true or false) Default: false
PERSEO=

# Use WireCloud (true or false) Default: false
WIRECLOUD=

# Use IoT Agent for UltraLight 2.0 (true or false) Default: false
IOTAGENT_UL=

# Use IoT Agent for JSON (true or false) Default: false
IOTAGENT_JSON=

# Specify transport protocol for IoT Agent (HTTP and/or MQTT)
# Use HTTP (true or false) Default: true
IOTAGENT_HTTP=

# Use MQTT (true or false) Default: false
IOTAGENT_MQTT=

# Use node-red (true or false) Default: false
NODE_RED=

# Start containers (true or false) Default: true
START_CONTAINER=
EOF
}

#
# Get config sh
#
get_config_sh() {
  logging_info "${FUNCNAME[0]}"

  if ! [ -e ./config.sh ]; then
    create_config_sh
  fi

  . ./config.sh

  IOTAGENT=false

  touch .install

  local NAME
  local VAL

  for NAME in CYGNUS_MONGO CYGNUS_MYSQL CYGNUS_POSTGRES CYGNUS_ELASTICSEARCH COMET QUANTUMLEAP PERSEO WIRECLOUD NODE_RED IOTAGENT_UL IOTAGENT_JSON IOTAGENT_MQTT
  do
    eval "VAL=\${${NAME}}"
    if [ -z "${VAL}" ]; then
      eval ${NAME}=false
    else
      check_value ${NAME}
    fi
  done

  if ${CYGNUS_MONGO} || ${CYGNUS_MYSQL} || ${CYGNUS_POSTGRES} || ${CYGNUS_ELASTICSEARCH}; then
    CYGNUS=true
  else
    CYGNUS=false
  fi

  if ${IOTAGENT_UL} && ${IOTAGENT_JSON}; then
    MSG="Error: IoT Agent UL and IoT Agent JSON cannot be set up on the same instance."
    logging_err "${FUNCNAME[0]} ${MSG}"
    exit "${ERR_CODE}" 
  fi

  if ${IOTAGENT_UL} || ${IOTAGENT_JSON}; then
    IOTAGENT=true
    if [ -z "${IOTAGENT_HTTP}" ]; then
      IOTAGENT_HTTP=true
    else
      check_value IOTAGENT_HTTP
    fi
    if "${IOTAGENT_UL}"; then
      IOTA_DEFAULT_RESOURCE=/iot/ul
    else
      IOTA_DEFAULT_RESOURCE=/iot/json
    fi
  else
    IOTAGENT_HTTP=false
  fi

  if [ -z "${MYSQL_ROOT_PASSWORD}" ]; then
    MYSQL_ROOT_PASSWORD=mysql
  fi

  if [ -z "${POSTGRES_PASSWORD}" ]; then
    POSTGRES_PASSWORD=postgres
  fi

  if [ -z "${ELASTICSEARCH_PASSWORD}" ]; then
    ELASTICSEARCH_PASSWORD=elasticsearch
  fi

  if [ -z "${START_CONTAINER}" ]; then
    START_CONTAINER=true
  else
    check_value START_CONTAINER
  fi
}

#
# Set amd64(x86_64) images
#
set_amd64_images() {
  IMAGE_ORION=telefonicaiot/fiware-orion:3.12.0
  IMAGE_WIRECLOUD=quay.io/fiware/wirecloud:1.3.1
  IMAGE_NGSIPROXY=quay.io/fiware/ngsiproxy:1.2.2
  IMAGE_COMET=telefonicaiot/fiware-sth-comet:2.11.0
  IMAGE_CYGNUS=telefonicaiot/fiware-cygnus:3.8.0
  IMAGE_IOTAGENT_UL=telefonicaiot/iotagent-ul:3.4.0
  IMAGE_IOTAGENT_JSON=telefonicaiot/iotagent-json:3.4.0
  IMAGE_QUANTUMLEAP=orchestracities/quantumleap:1.0.0
  IMAGE_PERSEO_CORE=telefonicaiot/perseo-core:1.13.0
  IMAGE_PERSEO_FE=telefonicaiot/perseo-fe:1.30.0
  IMAGE_ELASTICSEARCH=elasticsearch:2.4
}

#
# Set arm64 images
#
set_arm64_images() {
  IMAGE_ORION=letsfiware/orion:3.12.0
  IMAGE_WIRECLOUD=letsfiware/wirecloud:1.3.1
  IMAGE_NGSIPROXY=letsfiware/ngsiproxy:1.2.2
  IMAGE_COMET=letsfiware/sth-comet:2.11.0
  IMAGE_CYGNUS=letsfiware/fiware-cygnus:3.8.0
  IMAGE_IOTAGENT_UL=letsfiware/iotagent-ul:3.4.0
  IMAGE_IOTAGENT_JSON=letsfiware/iotagent-json:3.4.0
  IMAGE_QUANTUMLEAP=letsfiware/quantumleap:1.0.0
  IMAGE_PERSEO_CORE=letsfiware/perseo-core:1.13.0
  IMAGE_PERSEO_FE=letsfiware/perseo-fe:1.30.0
  IMAGE_ELASTICSEARCH=letsfiware/elasticsearch:2.4
}

#
# Set default values
#
set_default_values() {
  logging_info "${FUNCNAME[0]}"

  DOCKER_COMPOSE_YML=docker-compose.yml
  DOT_ENV=.env
  CONFIG_DIR=./config
  SCRIPT_DIR="${CONFIG_DIR}"/script
  DATA_DIR=./data
  MAKEFILE=Makefile

  rm -f "${DOT_ENV}"

  cat <<EOF > "${DOT_ENV}"
#
# .env file for FIWARE Small Bang
#
VERSION=${VERSION}
IP_ADDRESS=${IP_ADDRESS}
CONFIG_DIR=${CONFIG_DIR}
DATA_DIR=${DATA_DIR}
EOF

  IMAGE_MONGO=mongo:4.4

  IMAGE_NGINX=nginx:1.25
  IMAGE_MEMCACHED=memcached:1

  COMET_LOGOPS_LEVEL=INFO

  CYGNUS_LOG_LEVEL=INFO

  IOTA_UL_DEFAULT_RESOURCE=/iot/ul
  IOTA_UL_LOG_LEVEL=INFO
  IOTA_UL_TIMESTAMP=true
  IOTA_UL_AUTOCAST=true

  IOTA_JSON_DEFAULT_RESOURCE=/iot/json
  IOTA_JSON_LOG_LEVEL=INFO
  IOTA_JSON_TIMESTAMP=true
  IOTA_JSON_AUTOCAST=true

  IMAGE_MOSQUITTO=eclipse-mosquitto:1.6
  MOSQUITTO_LOG_TYPE=error,warning,notice,information

  QUANTUMLEAP_LOGLEVEL=INFO
  IMAGE_REDIS=redis:6
  IMAGE_CRATE=crate:4.6.6

  PERSEO_MAX_AGE=6000
  PERSEO_LOG_LEVEL=info

  IMAGE_MYSQL=mysql:8.1

  IMAGE_POSTGRES=postgres:15

  IMAGE_ELASTICSEARCH_DB=elasticsearch:7.17.13

  IMAGE_NODE_RED=letsfiware/node-red:v0.5.0-next

  MONGO_INSTALLED=false
  POSTGRES_INSTALLED=false

  if [ "${ARCH}" = "amd64" ]; then
    set_amd64_images
  else
    set_arm64_images
  fi
}

#
# Create collect.sh
#
create_collect_sh() {
  logging_info "${FUNCNAME[0]}"

  cat << 'EOF' > "${1}"
#!/bin/bash

set -eu

LANG=C
LC_TIME=C

check_cmd() {
  if type "$1" >/dev/null 2>&1; then
    FOUND=true
  else
    FOUND=false
  fi
}

#
# Check distribuiton
#
check_distro() {
  DISTRO="Unknown distro"

  ARCH=$(uname -m)
  OS=$(uname -s)

  if [ "${OS:0:5}" = "Linux" ]; then
    if [ -e /etc/redhat-release ]; then
      DISTRO=$(cat /etc/redhat-release)
    elif [ -e /etc/debian_version ] || [ -e /etc/debian_release ]; then

      if [ -e /etc/lsb-release ]; then
        ver="$(sed -n -e "/DISTRIB_RELEASE=/s/DISTRIB_RELEASE=\(.*\)/\1/p" /etc/lsb-release | awk -F. '{printf "%2d%02d", $1,$2}')"
        DISTRO="Ubuntu ${ver}"
      else
        DISTRO="not Ubuntu"
      fi
    else
      DISTRO="Unknown Linux"
    fi
  elif [ "${OS:0:6}" = "Darwin" ]; then
    OS=Darwin
  fi

  echo "OS: ${DISTRO}"
  echo "Arch: ${ARCH}"
}

check_docker() {
  echo -n "Docker: "
  if type docker >/dev/null 2>&1; then
    sudo docker --version
  else
    echo "not found"
  fi

  echo -n "Docker compose: "
  set +e
  found=$(sudo docker info --format '{{json . }}' | jq -r '.ClientInfo.Plugins | .[].Name' | grep -ic compose)
  set -e

  if [ "${found}" -eq 1 ]; then
    sudo docker compose version
  else
    echo "not found"
  fi
}

cd "$(dirname "$0")"
cd ../..

if [ ! -e .env ]; then
  echo ".env file not fuond"
  exit 1
fi

. ./.env

echo '```'
echo -n "Date: "
date
echo "Version: ${VERSION}"
check_distro
check_docker
uname -a
hostname -I
id
echo -n "Hash: "

check_cmd shasum
if "$FOUND"; then
  shasum -a 256 setup-fiware.sh
fi

check_cmd git
if "$FOUND" && [ -e .git ]; then
  echo "git-hash: "
  git log -n 3 --pretty=%H
fi

echo -n "Install: "
if [ -e .install ]; then
  echo "in progress"
else
  echo "completed"
fi

if [ -e docker-compose.yml ]; then
  echo -e "\nDocker containers: "
  docker compose ps
fi

if [ -e config.sh ]; then
  echo -e "\nconfig.sh: "
  cat config.sh
fi

echo -e '```'
EOF
  chmod +x "${1}"
}

#
# Create clean.sh
#
create_clean_sh() {
  logging_info "${FUNCNAME[0]}"

  cat << 'EOF' > "${1}"
#!/bin/bash
FORCE_CLEAN=${FORCE_CLEAN:-false}

if [ "${FORCE_CLEAN}" != "true" ]; then
  echo "!CAUTION! This command cleans up your FIWARE instance including your all data."
  # shellcheck disable=SC2162
  read -p "Are you sure you want to run it? (Y/n): " ans

  if [ "${ans}" != "Y" ]; then
    echo "Canceled"
    exit 1
  fi
fi

if [ -e docker-compose.yml ]; then
  set +e
  sudo docker compose down --remove-orphans
  set -e
  sleep 5
fi

for i in ./data ./config .env setup_ngsi_go.sh docker-compose.yml Makefile
do
  if [ -e "${i}" ]; then
    sudo rm -fr "${i}"
  fi
done
EOF
  chmod +x "${1}"
}

#
# Create info.sh
#
create_info_sh() {
  logging_info "${FUNCNAME[0]}"

  {
    echo "#!/bin/bash";
    echo "cat <<EOF";
    echo "Service URLs:";
    echo "  Orion: http://${IP_ADDRESS}:1026";
  } > "${1}"
  ${CYGNUS} && echo "  Cygnus: http://${IP_ADDRESS}:5080" >> "${1}"
  ${COMET} && echo "  Comet: http://${IP_ADDRESS}:8666" >> "${1}"
  ${WIRECLOUD} && {
    echo "  WireCloud: http://${IP_ADDRESS}";
    echo "  Ngsiproxy: http://${IP_ADDRESS}:3000";
  } >> "${1}"
  ${IOTAGENT} && echo "  IoT Agent: http://${IP_ADDRESS}:4041" >> "${1}"
  ${IOTAGENT_HTTP} && echo "    over HTTP: http://${IP_ADDRESS}:7896${IOTA_DEFAULT_RESOURCE}" >> "${1}"
  ${IOTAGENT_MQTT} && echo "    over MQTT: http://${IP_ADDRESS}:1883" >> "${1}"
  ${QUANTUMLEAP} && echo "  Quantumleap: http://${IP_ADDRESS}:8668" >> "${1}"
  ${PERSEO} && echo "  Perseo: http://${IP_ADDRESS}:9090" >> "${1}"
  ${NODE_RED} && echo "  Node-RED: http://${IP_ADDRESS}:1880" >> "${1}"
  {
    echo "Sanity check:";
    echo "  ngsi version --host orion.local";
  } >> "${1}"
  ${CYGNUS} && echo "  ngsi version --host cygnus.local" >> "${1}"
  ${COMET} && echo "  ngsi version --host comet.local" >> "${1}"
  ${WIRECLOUD} && echo "  ngsi version --host wirecloud.local" >> "${1}"
  ${IOTAGENT} && echo "  ngsi version --host iotagent.local" >> "${1}"
  ${QUANTUMLEAP} && echo "  ngsi version --host quantumleap.local" >> "${1}"
  ${PERSEO} && echo "  ngsi version --host perseo.local" >> "${1}"
  {
    echo "docs: https://fi-sb.letsfiware.jp/";
    echo "Please see the .env file for details.";
    echo "EOF";
  } >> "${1}"

  chmod +x "${1}"
}

#
# Create Makefile
#
create_makefile() {
  logging_info "${FUNCNAME[0]}"

  mkdir "${SCRIPT_DIR}"

  local CLEAN_SH
  CLEAN_SH="${SCRIPT_DIR}"/clean.sh
  create_clean_sh "${CLEAN_SH}"

  local COLLECT_SH
  COLLECT_SH="${SCRIPT_DIR}"/collect.sh
  create_collect_sh "${COLLECT_SH}"

  local INFO_SH
  INFO_SH="${SCRIPT_DIR}"/info.sh
  create_info_sh "${INFO_SH}"

  cat <<EOF > "${MAKEFILE}"
up:
	sudo docker compose up -d
down:
	sudo docker compose down
ps:
	sudo docker compose ps
clean:
	@${CLEAN_SH}
collect:
	@${COLLECT_SH}
info:
	@${INFO_SH}
EOF

  if "${WIRECLOUD}"; then
  cat <<EOF >> "${MAKEFILE}"
createsuperuser:
	sudo docker compose exec wirecloud python manage.py createsuperuser
EOF
  fi
}

#
# Init docker compose file
#
init_docker_compose_yml() {
  logging_info "${FUNCNAME[0]}"

  cat <<'EOF' > "${DOCKER_COMPOSE_YML}"
services:
EOF
}

#
# Add to docker_compose.yml
#
add_to_docker_compose_yml() {
  sed -i.bak -e "/${1}/s/^/ ${2}${SED_LF}/" "${DOCKER_COMPOSE_YML}"
}

#
# Setup mongo
#
setup_mongo() {
  logging_info "${FUNCNAME[0]}"

  if ${MONGO_INSTALLED}; then
    return
  fi
  MONGO_INSTALLED=true

  cat <<'EOF' >> "${DOCKER_COMPOSE_YML}"

  mongo:
    image: ${IMAGE_MONGO}
    command: --nojournal
    volumes:
      - ${CONFIG_DIR}/mongo/mongo-init.js:/docker-entrypoint-initdb.d/mongo-init.js:ro
      - ${DATA_DIR}/mongo-data:/data/db
    restart: always
    ports:
      - 27017:27017
EOF


  # create mongo-init.js
  local MONGO_DIR
  MONGO_DIR="${CONFIG_DIR}"/mongo
  mkdir "${MONGO_DIR}"
  cat << 'EOF' > "${MONGO_DIR}"/mongo-init.js
db = connect("localhost:27017/orion");
db.createCollection("entities");
db.entities.createIndex({"_id.servicePath": 1, "_id.id": 1, "_id.type": 1}, {unique: true});
db.entities.createIndex({"_id.type": 1});
db.entities.createIndex({"_id.id": 1});
EOF

  cat << EOF >> "${DOT_ENV}"

# MongoDB

IMAGE_MONGO=${IMAGE_MONGO}
EOF
}

#
# Setup orion
#
setup_orion() {
  logging_info "${FUNCNAME[0]}"

  cat <<'EOF' >> "${DOCKER_COMPOSE_YML}"

  orion:
    image: ${IMAGE_ORION}
    depends_on:
      - mongo
    entrypoint: ["sh", "-c", "rm /tmp/contextBroker.pid; /usr/bin/contextBroker -fg -multiservice -dbhost mongo"]
    restart: always
    ports:
      - 1026:1026
EOF

  cat << EOF >> "${DOT_ENV}"

# Orion

IMAGE_ORION=${IMAGE_ORION}
EOF

  setup_mongo
}

#
# Setup mysql
#
setup_mysql() {
  logging_info "${FUNCNAME[0]}"

  cat <<'EOF' >> "${DOCKER_COMPOSE_YML}"

  mysql:
    image: ${IMAGE_MYSQL}
    environment:
      - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
    volumes:
      - ${DATA_DIR}/mysql-data:/var/lib/mysql
    restart: always
    ports:
      - 3306:3306
EOF

  cat <<EOF >> "${DOT_ENV}"

# MySQL

IMAGE_MYSQL=${IMAGE_MYSQL}
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
EOF
}

#
# Setup postgress
#
setup_postgres() {
  logging_info "${FUNCNAME[0]}"

  if "${POSTGRES_INSTALLED}"; then
    return
  else
    POSTGRES_INSTALLED=true
  fi

  cat <<'EOF' >> "${DOCKER_COMPOSE_YML}"

  postgres:
    image: ${IMAGE_POSTGRES}
    environment:
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
    volumes:
      - ${DATA_DIR}/postgres-data:/var/lib/postgresql/data
    restart: always
    ports:
      - 5432:5432
EOF

  cat <<EOF >> "${DOT_ENV}"

# PostgreSQL

IMAGE_POSTGRES=${IMAGE_POSTGRES}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
EOF
}

#
# Setup elasticsearch
#
setup_elasticsearch() {
  logging_info "${FUNCNAME[0]}"

  cat <<'EOF' >> "${DOCKER_COMPOSE_YML}"

  elasticsearch-db:
    image: ${IMAGE_ELASTICSEARCH_DB}
    # __ELASTICSEARCH_PORTS__
    volumes:
      - ${DATA_DIR}/elasticsearch-db:/usr/share/elasticsearch/data
    environment:
      ES_JAVA_OPTS: ${ELASTICSEARCH_JAVA_OPTS}
      ELASTIC_PASSWORD: ${ELASTICSEARCH_PASSWORD}
      # Use single node discovery in order to disable production mode and avoid bootstrap checks.
      # see: https://www.elastic.co/guide/en/elasticsearch/reference/current/bootstrap-checks.html
      discovery.type: single-node
    healthcheck:
      test: curl http://localhost:9200 >/dev/null; if [[ $$? == 52 ]]; then echo 0; else echo 1; fi
      interval: 30s
      timeout: 10s
      retries: 5
    restart: always
    ports:
      - 9200:9200
EOF

  mkdir -p "${DATA_DIR}"/elasticsearch-db

  cat <<EOF >> "${DOT_ENV}"

# Elasticsearch

IMAGE_ELASTICSEARCH_DB=${IMAGE_ELASTICSEARCH_DB}
ELASTICSEARCH_JAVA_OPTS="-Xmx256m -Xms256m"
ELASTICSEARCH_PASSWORD=${ELASTICSEARCH_PASSWORD}
EOF
}

#
# Setup comet
#
setup_comet() {
  logging_info "${FUNCNAME[0]}"

  cat <<'EOF' >> "${DOCKER_COMPOSE_YML}"

  comet:
    image: ${IMAGE_COMET}
    init: true
    depends_on:
      # __COMET_DEPENDS_ON__
      - mongo
    networks:
      - default
    environment:
      - STH_HOST=0.0.0.0
      - STH_PORT=8666
      - DB_PREFIX=sth_
      - DB_URI=mongo:27017
      - LOGOPS_LEVEL=${COMET_LOGOPS_LEVEL}
    healthcheck:
      test: curl --fail -s http://comet:8666/version || exit 1
    ports:
      - 8666:8666
    restart: always
EOF

  if [ "${CYGNUS_MONGO}" = "true" ]; then
    add_to_docker_compose_yml "__COMET_DEPENDS_ON__" "     - cygnus"
  fi

  cat <<EOF >> "${DOT_ENV}"

# Comet

IMAGE_COMET=${IMAGE_COMET}
COMET_LOGOPS_LEVEL=${COMET_LOGOPS_LEVEL}
EOF
}

#
# Setup cygnus
#
setup_cygnus() {
  logging_info "${FUNCNAME[0]}"

  cat <<'EOF' >> "${DOCKER_COMPOSE_YML}"

  cygnus:
    image: ${IMAGE_CYGNUS}
    depends_on:
      # __CYGNUS_DEPENDS_ON__
    environment:
      - CYGNUS_API_PORT=5080
      # __CYGNUS_ENVIRONMENT__
      - CYGNUS_LOG_LEVEL=${CYGNUS_LOG_LEVEL}
    healthcheck:
      test: curl --fail -s http://cygnus:5080/v1/version || exit 1
    restart: always
    ports:
      - 5080:5080
      # __CYGNUS_PORTS__
EOF

  local sink
  sink=0

  if ${CYGNUS_MONGO}; then
    sink=$((sink+1))
    setup_mongo
    add_to_docker_compose_yml "__CYGNUS_DEPENDS_ON__" "     - mongo"
    add_to_docker_compose_yml "__CYGNUS_ENVIRONMENT__" "     - CYGNUS_MONGO_SERVICE_PORT=5051"
    add_to_docker_compose_yml "__CYGNUS_ENVIRONMENT__" "     - CYGNUS_MONGO_HOSTS=mongo:27017"
    add_to_docker_compose_yml "__CYGNUS_PORTS__" "     - 5051:5051"
  fi

  if ${CYGNUS_MYSQL}; then
    sink=$((sink+1))
    setup_mysql
    add_to_docker_compose_yml "__CYGNUS_DEPENDS_ON__" "     - mysql"
    add_to_docker_compose_yml "__CYGNUS_ENVIRONMENT__" "     - CYGNUS_MYSQL_SERVICE_PORT=5050"
    add_to_docker_compose_yml "__CYGNUS_ENVIRONMENT__" "     - CYGNUS_MYSQL_HOST=mysql"
    add_to_docker_compose_yml "__CYGNUS_ENVIRONMENT__" "     - CYGNUS_MYSQL_PORT=3306"
    add_to_docker_compose_yml "__CYGNUS_ENVIRONMENT__" "     - CYGNUS_MYSQL_USER=root"
    add_to_docker_compose_yml "__CYGNUS_ENVIRONMENT__" "     - CYGNUS_MYSQL_PASS=\${MYSQL_ROOT_PASSWORD}"
    add_to_docker_compose_yml "__CYGNUS_PORTS__" "     - 5050:5050"
  fi

  if ${CYGNUS_POSTGRES}; then
    sink=$((sink+1))
    setup_postgres
    add_to_docker_compose_yml "__CYGNUS_DEPENDS_ON__" "     - postgres"
    add_to_docker_compose_yml "__CYGNUS_ENVIRONMENT__" "     - CYGNUS_POSTGRESQL_SERVICE_PORT=5055"
    add_to_docker_compose_yml "__CYGNUS_ENVIRONMENT__" "     - CYGNUS_POSTGRESQL_HOST=postgres"
    add_to_docker_compose_yml "__CYGNUS_ENVIRONMENT__" "     - CYGNUS_POSTGRESQL_PORT=5432"
    add_to_docker_compose_yml "__CYGNUS_ENVIRONMENT__" "     - CYGNUS_POSTGRESQL_USER=postgres"
    add_to_docker_compose_yml "__CYGNUS_ENVIRONMENT__" "     - CYGNUS_POSTGRESQL_PASS=\${POSTGRES_PASSWORD}"
    add_to_docker_compose_yml "__CYGNUS_PORTS__" "     - 5055:5055"
  fi

  if ${CYGNUS_ELASTICSEARCH}; then
    sink=$((sink+1))
    setup_elasticsearch
    add_to_docker_compose_yml "__CYGNUS_DEPENDS_ON__" "     - elasticsearch-db"
    add_to_docker_compose_yml "__CYGNUS_ENVIRONMENT__" "     - CYGNUS_ELASTICSEARCH_HOST=elasticsearch-db:9200"
    add_to_docker_compose_yml "__CYGNUS_ENVIRONMENT__" "     - CYGNUS_ELASTICSEARCH_PORT=5058"
    add_to_docker_compose_yml "__CYGNUS_ENVIRONMENT__" "     - CYGNUS_ELASTICSEARCH_SSL=false"
    add_to_docker_compose_yml "__CYGNUS_PORTS__" "     - 5058:5058"
  fi

  if [ $sink -ge 2 ]; then
    add_to_docker_compose_yml "__CYGNUS_ENVIRONMENT__" "     - CYGNUS_MULTIAGENT=true"
  fi

  cat <<EOF >> "${DOT_ENV}"

# Cygnus

IMAGE_CYGNUS=${IMAGE_CYGNUS}
CYGNUS_LOG_LEVEL=${CYGNUS_LOG_LEVEL}
EOF
}

#
# mosquitto
#
setup_mosquitto() {
  logging_info "${FUNCNAME[0]}"

  cat <<'EOF' >> "${DOCKER_COMPOSE_YML}"

  mosquitto:
    image: ${IMAGE_MOSQUITTO}
    volumes:
      - ${CONFIG_DIR}/mosquitto/mosquitto.conf:/mosquitto/config/mosquitto.conf
      - ${DATA_DIR}/mosquitto:/mosquitto/data
    restart: always
    ports:
      - 1883:1883
EOF

  local MOSQUITTO_DIR

  MOSQUITTO_DIR="${CONFIG_DIR}"/mosquitto
  mkdir -p "${MOSQUITTO_DIR}"

  cat <<EOF >> "${DOT_ENV}"

# Mosquitto

IMAGE_MOSQUITTO=${IMAGE_MOSQUITTO}
MQTT_1883=true
MQTT_TLS=false
MQTT_PORT=1883
EOF

  cat <<EOF > "${MOSQUITTO_DIR}/mosquitto.conf"
persistence true
persistence_location /mosquitto/data/

log_dest stdout

listener 1883

allow_anonymous true

connection_messages true
log_timestamp true
EOF

  local log_types
  local log_type

  # shellcheck disable=SC2206
  log_types=(${MOSQUITTO_LOG_TYPE//,/ })

  for log_type in "${log_types[@]}"
  do
    echo "log_type ${log_type}" >> "${MOSQUITTO_DIR}/mosquitto.conf"
  done
}

#
# Create openiot mongo index
#
create_openiot_mongo_index() {
  cat <<EOF >> "${CONFIG_DIR}/mongo/mongo-init.js"
db = connect("localhost:27017/orion-openiot");
db.createCollection("entities");
db.entities.createIndex({"_id.servicePath": 1, "_id.id": 1, "_id.type": 1}, {unique: true});
db.entities.createIndex({"_id.type": 1});
db.entities.createIndex({"_id.id": 1});
EOF
}

#
# IoT Agent for UltraLight 2.0
#
setup_iotagent_ul() {
  logging_info "${FUNCNAME[0]}"

  cat <<'EOF' >> "${DOCKER_COMPOSE_YML}"

  iotagent-ul:
    image: ${IMAGE_IOTAGENT_UL}
    init: true
    depends_on:
      - mongo
      # __IOTA_UL_DEPENDS_ON__
    environment:
      - IOTA_CB_HOST=orion
      - IOTA_CB_PORT=1026
      - IOTA_NORTH_PORT=4041
      - IOTA_REGISTRY_TYPE=mongodb
      - IOTA_CB_NGSI_VERSION=v2
      - IOTA_LOG_LEVEL=${IOTA_UL_LOG_LEVEL}
      - IOTA_TIMESTAMP=${IOTA_UL_TIMESTAMP}
      - IOTA_AUTOCAST=${IOTA_UL_AUTOCAST}
      - IOTA_MONGO_HOST=mongo
      - IOTA_MONGO_PORT=27017
      - IOTA_MONGO_DB=iotagentul
      - IOTA_DEFAULT_RESOURCE=${IOTA_UL_DEFAULT_RESOURCE}
      - IOTA_PROVIDER_URL=http://iotagent-ul:4041
      # __IOTA_UL_ENVIRONMENT__
    restart: always
    ports:
      - 4041:4041
      # __IOTA_UL_PORTS__
EOF

  setup_mongo
  create_openiot_mongo_index
  cat <<EOF >> "${CONFIG_DIR}/mongo/mongo-init.js"
db = connect("localhost:27017/iotagentul");
db.createCollection("devices");
db.devices.createIndex({"_id.service": 1, "_id.id": 1, "_id.type": 1});
db.devices.createIndex({"_id.type": 1});
db.devices.createIndex({"_id.id": 1});
db.createCollection("groups");
db.groups.createIndex({"_id.resource": 1, "_id.apikey": 1, "_id.service": 1});
db.groups.createIndex({"_id.type": 1});
EOF

  cat <<EOF >> "${DOT_ENV}"

# IoT Agent for UltraLight 2.0

IMAGE_IOTAGENT_UL=${IMAGE_IOTAGENT_UL}
IOTA_UL_DEFAULT_RESOURCE=${IOTA_UL_DEFAULT_RESOURCE}
IOTA_UL_LOG_LEVEL=${IOTA_UL_LOG_LEVEL}
IOTA_UL_TIMESTAMP=${IOTA_UL_TIMESTAMP}
IOTA_UL_AUTOCAST=${IOTA_UL_AUTOCAST}
EOF

  if ${IOTAGENT_HTTP}; then
    add_to_docker_compose_yml "__IOTA_UL_ENVIRONMENT__" "     - IOTA_HTTP_PORT=7896"
    add_to_docker_compose_yml "__IOTA_UL_PORTS__" "     - 7896:7896"
  fi

  if ${IOTAGENT_MQTT}; then
    setup_mosquitto

    add_to_docker_compose_yml "__IOTA_UL_DEPENDS_ON__" "     - mosquitto"
    add_to_docker_compose_yml "__IOTA_UL_ENVIRONMENT__" "     - IOTA_MQTT_HOST=mosquitto"
    add_to_docker_compose_yml "__IOTA_UL_ENVIRONMENT__" "     - IOTA_MQTT_PORT=1883"
  fi
}

#
# IoT Agent for JSON
#
setup_iotagent_json() {
  logging_info "${FUNCNAME[0]}"

  cat <<'EOF' >> "${DOCKER_COMPOSE_YML}"

  iotagent-json:
    image: ${IMAGE_IOTAGENT_JSON}
    init: true
    depends_on:
      - mongo
      # __IOTA_JSON_DEPENDS_ON__
    environment:
      - IOTA_CB_HOST=orion
      - IOTA_CB_PORT=1026
      - IOTA_NORTH_PORT=4041
      - IOTA_REGISTRY_TYPE=mongodb
      - IOTA_CB_NGSI_VERSION=v2
      - IOTA_LOG_LEVEL=${IOTA_JSON_LOG_LEVEL}
      - IOTA_TIMESTAMP=${IOTA_JSON_TIMESTAMP}
      - IOTA_AUTOCAST=${IOTA_JSON_AUTOCAST}
      - IOTA_MONGO_HOST=mongo
      - IOTA_MONGO_PORT=27017
      - IOTA_MONGO_DB=iotagentjson
      - IOTA_DEFAULT_RESOURCE=${IOTA_JSON_DEFAULT_RESOURCE}
      - IOTA_PROVIDER_URL=http://iotagent-json:4041
      # __IOTA_JSON_ENVIRONMENT__
    restart: always
    ports:
      - 4041:4041
      # __IOTA_JSON_PORTS__
EOF

  setup_mongo
  create_openiot_mongo_index
  cat <<EOF >> "${CONFIG_DIR}/mongo/mongo-init.js"
db = connect("localhost:27017/iotagentjson");
db.createCollection("devices");
db.devices.createIndex({"_id.service": 1, "_id.id": 1, "_id.type": 1});
db.devices.createIndex({"_id.type": 1});
db.devices.createIndex({"_id.id": 1});
db.createCollection("groups");
db.groups.createIndex({"_id.resource": 1, "_id.apikey": 1, "_id.service": 1});
db.groups.createIndex({"_id.type": 1});
EOF

  cat <<EOF >> "${DOT_ENV}"

# IoT Agent for JSON

IMAGE_IOTAGENT_JSON=${IMAGE_IOTAGENT_JSON}
IOTA_JSON_DEFAULT_RESOURCE=${IOTA_JSON_DEFAULT_RESOURCE}
IOTA_JSON_LOG_LEVEL=${IOTA_JSON_LOG_LEVEL}
IOTA_JSON_TIMESTAMP=${IOTA_JSON_TIMESTAMP}
IOTA_JSON_AUTOCAST=${IOTA_JSON_AUTOCAST}
EOF

  if ${IOTAGENT_HTTP}; then
    add_to_docker_compose_yml "__IOTA_JSON_ENVIRONMENT__" "     - IOTA_HTTP_PORT=7896"
    add_to_docker_compose_yml "__IOTA_JSON_PORTS__" "     - 7896:7896"
  fi

  if ${IOTAGENT_MQTT}; then
    setup_mosquitto

    add_to_docker_compose_yml "__IOTA_JSON_DEPENDS_ON__" "     - mosquitto"
    add_to_docker_compose_yml "__IOTA_JSON_ENVIRONMENT__" "     - IOTA_MQTT_HOST=mosquitto"
    add_to_docker_compose_yml "__IOTA_JSON_ENVIRONMENT__" "     - IOTA_MQTT_PORT=1883"
  fi
}

#
# Setup QUANTUMLEAP
#
setup_quantumleap() {
  logging_info "${FUNCNAME[0]}"

  cat <<'EOF' >> "${DOCKER_COMPOSE_YML}"

  quantumleap:
    image: ${IMAGE_QUANTUMLEAP}
    depends_on:
      - crate
      - redis
    environment:
      - CRATE_HOST=crate
      - REDIS_HOST=redis
      - REDIS_PORT=6379
      - LOGLEVEL=${QUANTUMLEAP_LOGLEVEL}
    healthcheck:
      test: curl --fail -s http://quantumleap:8668/version || exit 1
    restart: always
    ports:
      - 8668:8668 

  redis:
    image: ${IMAGE_REDIS}
    volumes:
      - ./data/redis:/data
    restart: always

  crate:
    image: ${IMAGE_CRATE}
    command: crate -Cauth.host_based.enabled=false  -Ccluster.name=democluster -Chttp.cors.enabled=true -Chttp.cors.allow-origin="*"
    environment:
      # see https://crate.io/docs/crate/howtos/en/latest/deployment/containers/docker.html#troubleshooting
      - CRATE_HEAP_SIZE=2g
    volumes:
      - ./data/crate:/data
    restart: always
    ports:
      # Admin UI
      - 4200:4200
EOF

  cat <<EOF >> "${DOT_ENV}"

# Quantumleap

IMAGE_QUANTUMLEAP=${IMAGE_QUANTUMLEAP}
QUANTUMLEAP_LOGLEVEL=${QUANTUMLEAP_LOGLEVEL}
IMAGE_REDIS=${IMAGE_REDIS}
IMAGE_CRATE=${IMAGE_CRATE}
EOF
}

#
# Setup PERSEO 
#
setup_perseo() {
  logging_info "${FUNCNAME[0]}"

  cat <<'EOF' >> "${DOCKER_COMPOSE_YML}"

  perseo-core:
    image: ${IMAGE_PERSEO_CORE}
    environment:
      - PERSEO_FE_URL=http://perseo-fe:9090
      - MAX_AGE=${PERSEO_MAX_AGE}
    depends_on:
      - mongo
    restart: always

  perseo-fe:
    image: ${IMAGE_PERSEO_FE}
    depends_on:
      - perseo-core
    environment:
      - PERSEO_MONGO_ENDPOINT=mongo
      - PERSEO_CORE_URL=http://perseo-core:8080
      - PERSEO_LOG_LEVEL=${PERSEO_LOG_LEVEL}
      - PERSEO_ORION_URL=http://orion:1026/
    restart: always
    ports:
      - 9090:9090
EOF

  cat <<EOF >> "${DOT_ENV}"

# Perseo

IMAGE_PERSEO_CORE=${IMAGE_PERSEO_CORE}
IMAGE_PERSEO_FE=${IMAGE_PERSEO_FE}
PERSEO_MAX_AGE=${PERSEO_MAX_AGE}
PERSEO_LOG_LEVEL=${PERSEO_LOG_LEVEL}
EOF
}

#
# Create Elasticsearch 2.4 imaage for arm64
#
create_elasticsearch_2_4_image_for_arm64() {
  logging_info "${FUNCNAME[0]}"

  local ELASTICSEARCH_DIR
  ELASTICSEARCH_DIR="${CONFIG_DIR}"/elasticsearch
  local ELASTICSEARCH_CONFIG_DIR
  ELASTICSEARCH_CONFIG_DIR="${ELASTICSEARCH_DIR}"/config
  mkdir -p "${ELASTICSEARCH_CONFIG_DIR}"

  cat <<'EOF' > "${ELASTICSEARCH_DIR}"/Dockerfile
FROM ubuntu:18.04 AS build_stage

SHELL ["/bin/bash", "-c"]
RUN apt update && \
    apt install -y git curl zip unzip openjdk-8-jdk maven -y --no-install-recommends && \
    apt -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    if [ "$(uname -m)" = "x86_64" ]; then export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/"; echo "${JAVA_HOME}"; else export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-arm64/"; echo "${JAVA_HOME}"; fi && \
    curl -s https://get.sdkman.io | bash && \
    source "/root/.sdkman/bin/sdkman-init.sh" && \
    sdk install gradle 3.3 && \
    git clone -b 2.4 --depth=1 https://github.com/elastic/elasticsearch.git && \
    cd elasticsearch/ && \
    mvn clean -e package -DskipTests

FROM ubuntu:18.04

RUN apt update && \
    apt install -y openjdk-8-jre gosu -y --no-install-recommends && \
    apt -y clean && \
    rm -rf /var/lib/apt/lists/*
COPY --from=build_stage /elasticsearch/distribution/deb/target/releases/elasticsearch-2.4.7-SNAPSHOT.deb /
RUN dpkg -i /elasticsearch-2.4.7-SNAPSHOT.deb && \
    rm /elasticsearch-2.4.7-SNAPSHOT.deb
ENV LANG=C.UTF-8
ENV ELASTICSEARCH_VERSION=2.4.7
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
ENV PATH=/usr/share/elasticsearch/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
WORKDIR /usr/share/elasticsearch
COPY ./config ./config
RUN chown elasticsearch:elasticsearch config && \
    mkdir ./config/scripts && \
    chown elasticsearch:elasticsearch ./config/scripts && \
    mkdir data && \
    chown elasticsearch:elasticsearch data && \
    mkdir logs && \
    chown elasticsearch:elasticsearch logs
VOLUME [/usr/share/elasticsearch/data]
COPY ./docker-entrypoint.sh /
EXPOSE 9200/tcp 9300/tcp
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["elasticsearch"]
EOF

  cat <<'EOF' > "${ELASTICSEARCH_DIR}"/docker-entrypoint.sh
#!/bin/bash

set -e

if [ "${1:0:1}" = '-' ]; then
	set -- elasticsearch "$@"
fi

if [ "$1" = 'elasticsearch' -a "$(id -u)" = '0' ]; then
	for path in \
		/usr/share/elasticsearch/data \
		/usr/share/elasticsearch/logs \
	; do
		chown -R elasticsearch:elasticsearch "$path"
	done
	
	set -- gosu elasticsearch "$@"
fi

exec "$@"
EOF
  chmod +x "${ELASTICSEARCH_DIR}"/docker-entrypoint.sh

  cat <<'EOF' > "${ELASTICSEARCH_CONFIG_DIR}"/elasticsearch.yml
network.host: 0.0.0.0
EOF

  cat <<'EOF' > "${ELASTICSEARCH_CONFIG_DIR}"/logging.yml
es.logger.level: INFO
rootLogger: ${es.logger.level}, console
logger:
  # log action execution errors for easier debugging
  action: DEBUG

appender:
  console:
    type: console
    layout:
      type: consolePattern
      conversionPattern: "[%d{ISO8601}][%-5p][%-25c] %m%n"
EOF

  "${SUDO}" "${DOCKER_CMD}" build  -t "${IMAGE_ELASTICSEARCH}" "${ELASTICSEARCH_DIR}"
}

#
# Setup wirecloud
#
setup_wirecloud() {
  logging_info "${FUNCNAME[0]}"

  cat <<'EOF' >> "${DOCKER_COMPOSE_YML}"

  nginx:
    image: ${IMAGE_NGINX}
    depends_on:
      - wirecloud
    volumes:
      - ${CONFIG_DIR}/nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ${DATA_DIR}/wirecloud/wirecloud-static:/var/www/static:ro
    restart: always
    ports:
      - 80:80

  wirecloud:
    image: ${IMAGE_WIRECLOUD}
    depends_on:
      - postgres
      - elasticsearch
      - memcached
    environment:
      - DB_HOST=postgres
      - DB_PASSWORD=${POSTGRES_PASSWORD}
      - FORWARDED_ALLOW_IPS=*
      - ELASTICSEARCH2_URL=http://elasticsearch:9200/
      - MEMCACHED_LOCATION=memcached:11211
    volumes:
      - ${DATA_DIR}/wirecloud/wirecloud-data:/opt/wirecloud_instance/data
      - ${DATA_DIR}/wirecloud/wirecloud-static:/var/www/static
      - ${DATA_DIR}/wirecloud/widgets:/widgets
    restart: always

  elasticsearch:
    image: ${IMAGE_ELASTICSEARCH}
    volumes:
      - ${DATA_DIR}/wirecloud/elasticsearch-data:/usr/share/elasticsearch/data
    command: elasticsearch -Des.index.max_result_window=50000
    restart: always

  memcached:
    image: ${IMAGE_MEMCACHED}
    command: memcached -m 2048m
    restart: always

  ngsiproxy:
    image: ${IMAGE_NGSIPROXY}
    environment:
      - TRUST_PROXY_HEADERS=1
    restart: always
    ports:
      - 3000:3000
EOF
  
  mkdir "${CONFIG_DIR}"/nginx
  cat <<'EOF' > "${CONFIG_DIR}"/nginx/nginx.conf
user  nginx;
worker_processes  1;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;

    keepalive_timeout  65;

    server {
        listen 80;
        server_name example.org;
        client_max_body_size 20M;
        charset utf-8;

        location /static {
            alias /var/www/static;
        }
        location / {
            proxy_pass http://wirecloud:8000;
            proxy_set_header Host $host:$server_port;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }

    }
}
EOF

  cat <<EOF >> "${DOT_ENV}"

# WireCloud

IMAGE_NGINX=${IMAGE_NGINX}
IMAGE_WIRECLOUD=${IMAGE_WIRECLOUD}
IMAGE_ELASTICSEARCH=${IMAGE_ELASTICSEARCH}
IMAGE_MEMCACHED=${IMAGE_MEMCACHED}
IMAGE_NGSIPROXY=${IMAGE_NGSIPROXY}
EOF

  setup_postgres

  if [ "${ARCH}" = "arm64" ]; then
    create_elasticsearch_2_4_image_for_arm64
  fi
}

#
# Setup node-red
#
setup_node_red() {
  logging_info "${FUNCNAME[0]}"

  local NODE_RED_DIR
  NODE_RED_DIR="${CONFIG_DIR}"/node-red
  mkdir "${NODE_RED_DIR}"

  cat <<'EOF' > "${NODE_RED_DIR}"/Dockerfile
FROM nodered/node-red:3.1.9

RUN \
    npm i node-red-contrib-letsfiware-ngsi
EOF

  "${SUDO}" "${DOCKER_CMD}" build -t "${IMAGE_NODE_RED}" "${NODE_RED_DIR}"

  cat <<'EOF' >> "${DOCKER_COMPOSE_YML}"

  node-red:
    image: ${IMAGE_NODE_RED}
    volumes:
      - ${DATA_DIR}/node-red:/data
    restart: always
    ports:
      - 1880:1880
EOF

  mkdir "${DATA_DIR}"/node-red
  "${SUDO}" chmod 777 "${DATA_DIR}"/node-red

  echo "IMAGE_NODE_RED=${IMAGE_NODE_RED}" >> "${DOT_ENV}"
}

#
# Install NGSI Go
#
install_ngsi_go() {
  logging_info "${FUNCNAME[0]}"

  local ngsi_go_version
  ngsi_go_version=v0.13.0

  if [ -e /usr/local/bin/ngsi ]; then
    local ver
    ver=$(/usr/local/bin/ngsi --version)
    logging_info "${ver}"
    ver=$(/usr/local/bin/ngsi --version | sed -e "s/ngsi version \([^ ]*\) .*/\1/" | awk -F. '{printf "%2d%02d%02d", $1,$2,$3}')
    if [ "${ver}" -ge 1200 ]; then
        return
    fi
  fi

  "${CURL_CMD}" -sOL https://github.com/lets-fiware/ngsi-go/releases/download/${ngsi_go_version}/ngsi-${ngsi_go_version}-${OS}-${ARCH}.tar.gz
  ${SUDO} tar zxf ngsi-${ngsi_go_version}-${OS}-${ARCH}.tar.gz -C /usr/local/bin
  rm -f ngsi-${ngsi_go_version}-linux-amd64.tar.gz

  if [ -d /etc/bash_completion.d ]; then
    "${CURL_CMD}" -sOL https://raw.githubusercontent.com/lets-fiware/ngsi-go/main/autocomplete/ngsi_bash_autocomplete
    ${SUDO} mv ngsi_bash_autocomplete /etc/bash_completion.d/
    source /etc/bash_completion.d/ngsi_bash_autocomplete
    if [ -e ~/.bashrc ]; then
      set +e
      FOUND=$(grep -c "ngsi_bash_autocomplete" ~/.bashrc)
      set -e
      if [ "${FOUND}" -eq 0 ]; then
        echo "source /etc/bash_completion.d/ngsi_bash_autocomplete" >> ~/.bashrc
      fi
    fi
  fi
}

#
# Setup NGSI Go
#
setup_ngsi_go() {
  logging_info "${FUNCNAME[0]}"

  ngsi broker add --host orion.local --ngsiType v2 --brokerHost "http://${IP_ADDRESS}:1026" --overWrite

  ${CYGNUS} && ngsi server add --host cygnus.local --serverType cygnus --serverHost "http://${IP_ADDRESS}:5080" --overWrite
  ${COMET} && ngsi server add --host comet.local --serverType comet --serverHost "http://${IP_ADDRESS}:8666" --overWrite
  ${WIRECLOUD} && ngsi server add --host wirecloud.local --serverType wirecloud --serverHost "http://${IP_ADDRESS}" --overWrite
  ${IOTAGENT} && ngsi server add --host iotagent.local --serverType iota --serverHost "http://${IP_ADDRESS}:4041" --service openiot --path / --overWrite
  ${QUANTUMLEAP} && ngsi server add --host quantumleap.local --serverType quantumleap --serverHost "http://${IP_ADDRESS}:8668" --overWrite
  ${PERSEO} && ngsi server add --host perseo.local --serverType perseo --serverHost "http://${IP_ADDRESS}:9090" --overWrite
  true
}

#
# Create script to setup NGSI Go
#
create_script_to_setup_ngsi_go() {
  logging_info "${FUNCNAME[0]}"

  local SCRIPT_FILE
  SCRIPT_FILE="setup_ngsi_go.sh"
  if [ -e "${SCRIPT_FILE}" ]; then
    rm -f "${SCRIPT_FILE}"
  fi
  {
    echo -e "#!/bin/bash\n\n# This file was created by FIWARE Small Bang.\n# See http://github.com/lets-fiware/ngsi-go for how to install NGSI Go.\n\nIP_ADDRESS=${IP_ADDRESS}\n";
    echo "ngsi broker add --host orion.\${IP_ADDRESS} --ngsiType v2 --brokerHost http://\${IP_ADDRESS}:1026 --overWrite";
  } > "${SCRIPT_FILE}"
  ${CYGNUS} && echo "ngsi server add --host cygnus.\${IP_ADDRESS} --serverType cygnus --serverHost http://\${IP_ADDRESS}:5080 --overWrite" >> "${SCRIPT_FILE}"
  ${COMET} && echo "ngsi server add --host comet.\${IP_ADDRESS} --serverType comet --serverHost http://\${IP_ADDRESS}:8666 --overWrite" >> "${SCRIPT_FILE}"
  ${WIRECLOUD} && echo "ngsi server add --host wirecloud.\${IP_ADDRESS} --serverType wirecloud --serverHost http://\${IP_ADDRESS} --overWrite" >> "${SCRIPT_FILE}"
  ${IOTAGENT} && echo "ngsi server add --host iotagent.\${IP_ADDRESS} --serverType iota --serverHost http://\${IP_ADDRESS}:4041 --service openiot --path / --overWrite" >> "${SCRIPT_FILE}"
  ${QUANTUMLEAP} && echo "ngsi server add --host quantumleap.\${IP_ADDRESS} --serverType quantumleap --serverHost http://\${IP_ADDRESS}:8668 --overWrite" >> "${SCRIPT_FILE}"
  ${PERSEO} && echo "ngsi server add --host perseo.\${IP_ADDRESS} --serverType perseo --serverHost http://\${IP_ADDRESS}:9090 --overWrite" >> "${SCRIPT_FILE}"
  chmod 0755 "${SCRIPT_FILE}"
}

#
# Add serivce resources to .env file
#
add_service_resources(){

  cat <<EOF >> "${DOT_ENV}"

# Service resources

ORION=orion.local
EOF
  ${CYGNUS} && echo "CYGNUS=cygnus.local" >> "${DOT_ENV}"
  ${COMET} && echo "COMET=comet.local" >> "${DOT_ENV}"
  ${WIRECLOUD} && echo "WIRECLOUD=wirecloud.local" >> "${DOT_ENV}"
  ${IOTAGENT_UL} && echo "IOTAGENT_UL=iotagent.local" >> "${DOT_ENV}"
  ${IOTAGENT_JSON} && echo "IOTAGENT_JSON=iotagent.local" >> "${DOT_ENV}"
  ${IOTAGENT_HTTP} && echo "IOTAGENT_HTTP=${IP_ADDRESS}:7896" >> "${DOT_ENV}"
  ${IOTAGENT_MQTT} && echo "MOSQUITTO=${IP_ADDRESS}" >> "${DOT_ENV}"
  ${QUANTUMLEAP} && echo "QUANTUMLEAP=quantumleap.local" >> "${DOT_ENV}"
  ${PERSEO} && echo "PERSEO=perseo.local" >> "${DOT_ENV}"
  ${NODE_RED} && echo "NODE_RED=${IP_ADDRESS}:1880" >> "${DOT_ENV}"
  true
}

#
# Start containers
#
start_containers() {
  logging_info "${FUNCNAME[0]}"

  if "${START_CONTAINER}"; then
    docker compose up -d
  fi
}

#
# Setup complete
#
setup_complete() {
  sed -i.bak -e "/# __/d" "${DOCKER_COMPOSE_YML}"
  rm -f "${DOCKER_COMPOSE_YML}.bak"
  rm -f .install

  echo "*** Setup has completed ***"
  make info
}

#
# Init env
#
init_env() {
  LANG=C
  LC_TIME=C
  ERR_CODE="${ERR_CODE:-1}"
  LOGGING_INFO="${LOGGING_INFO:-false}"
  LOGGER="${LOGGER:-false}"
  SED_LF=$(printf '\\\012_')
  SED_LF=${SED_LF%_}

  IP_ADDRESS=
  if [ $# -ge 1 ]; then
    IP_ADDRESS=$(echo "${1}" | sed -n -r -e "s/([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)/\1/p")
  fi
}

#
# main
#
main() {
  init_env "$@"

  init_cmd

  check_machine

  check_data_direcotry

  get_config_sh

  get_ip_address

  set_default_values

  init_directories

  create_makefile

  check_docker

  init_docker_compose_yml

  setup_orion

  ${CYGNUS} && setup_cygnus

  ${COMET} && setup_comet

  ${WIRECLOUD} && setup_wirecloud

  ${NODE_RED} && setup_node_red

  ${IOTAGENT_UL} && setup_iotagent_ul

  ${IOTAGENT_JSON} && setup_iotagent_json

  ${QUANTUMLEAP} && setup_quantumleap

  ${PERSEO} && setup_perseo

  install_ngsi_go

  setup_ngsi_go

  create_script_to_setup_ngsi_go

  add_service_resources

  start_containers

  setup_complete
}

main "$@"
