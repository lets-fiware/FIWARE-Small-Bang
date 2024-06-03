# After installation

## Contents

<details>
<summary><strong>Details</strong></summary>

-   [Installation completion message](#installation-completion-message)
-   [Sanity check procedures](#sanity-check-procedures)
    -   [Get the status of docker containers](#get-the-status-of-docker-containers)
    -   [Get Orion version](#get-orion-version)
    -   [Sanity check for Cygnus](#sanity-check-for-cygnus)
    -   [Sanity check for Comet](#sanity-check-for-comet)
    -   [Sanity check for Perseo](#sanity-check-for-perseo)
    -   [Get QuantumLeap version](#get-quantumleap-version)
    -   [Sanity check for QuantumLeap](#sanity-check-for-quantumleap)
    -   [Sanity check for IoT Agent for UL](#sanity-check-for-iot-agent-for-ul)
    -   [Sanity check for IoT Agent for JSON](#sanity-check-for-iot-agent-for-json)
    -   [Sanity check for WireCloud](#sanity-check-for-wirecloud)
    -   [Access WireCloud API](#access-wirecloud-api)
    -   [Sanity check for Node-RED](#sanity-check-for-node-red)
    -   [Access Node-RED API](#access-node-red-api)

</details>

## Installation completion message

After installation, you will get a completion message as shown:

```text
*** Setup has completed ***
Service URLs:
  Orion: http://192.168.12.249:1026
  Cygnus: http://192.168.12.249:5080
  Comet: http://192.168.12.249:8666
  WireCloud: http://192.168.12.249
  Ngsiproxy: http://192.168.12.249:3000
  IoT Agent: http://192.168.12.249:4041
    over HTTP: http://192.168.12.249:7896/iot/ul
    over MQTT: http://192.168.12.249:1883
  Quantumleap: http://192.168.12.249:8668
  Perseo: http://192.168.12.249:9090
  Node-RED: http://192.168.12.249:1880
Sanity check:
  ngsi version --host orion.local
  ngsi version --host cygnus.local
  ngsi version --host comet.local
  ngsi version --host wirecloud.local
  ngsi version --host iotagent.local
  ngsi version --host quantumleap.local
  ngsi version --host perseo.local
docs: https://fi-sb.letsfiware.jp/
Please see the .env file for details.
```

## Sanity check procedures

You can check if the FIWARE instance is healthy by running some commands.

### Get the status of docker containers

#### Request:

```bash
make ps
```

#### Response:

```text
sudo docker compose ps
NAME                           COMMAND                  SERVICE             STATUS                PORTS
fiware-small-bang_keyrock_1      "docker-entrypoint.s…"   keyrock             running (healthy)     3000/tcp
fiware-small-bang_mongo_1        "docker-entrypoint.s…"   mongo               running               27017/tcp
fiware-small-bang_mysql_1        "docker-entrypoint.s…"   mysql               running               33060/tcp
fiware-small-bang_nginx_1        "/docker-entrypoint.…"   nginx               running               0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp, :::80->80/tcp, :::443->443/tcp
fiware-small-bang_orion_1        "sh -c 'rm /tmp/cont…"   orion               running               1026/tcp
fiware-small-bang_tokenproxy_1   "docker-entrypoint.sh"   tokenproxy          running               1029/tcp
fiware-small-bang_wilma_1        "docker-entrypoint.s…"   wilma               running (unhealthy)   1027/tcp
```

### Get Orion version

You can get the Orion version with NGSI Go.

```bash
ngsi version --host orion.local
```

```json
{
"orion" : {
  "version" : "3.12.0",
  "uptime" : "0 d, 0 h, 0 m, 3 s",
  "git_hash" : "7ebe97f8ddc13436c66ead53460fd4776e923e34",
  "compile_time" : "Sun Jun 2 04:51:55 UTC 2024",
  "compiled_by" : "root",
  "compiled_in" : "buildkitsandbox",
  "release_date" : "Sun Jun 2 04:51:55 UTC 2024",
  "machine" : "aarch64",
  "doc" : "https://fiware-orion.rtfd.io/en/3.12.0/",
  "libversions": {
     "boost": "1_74",
     "libcurl": "libcurl/7.88.1 OpenSSL/3.0.11 zlib/1.2.13 brotli/1.0.9 zstd/1.5.4 libidn2/2.3.3 libpsl/0.21.2 (+libidn2/2.3.3) libssh2/1.10.0 nghttp2/1.52.0 librtmp/2.3 OpenLDAP/2.5.13",
     "libmosquitto": "2.0.15",
     "libmicrohttpd": "0.9.76",
     "openssl": "3.0.11",
     "rapidjson": "1.1.0",
     "mongoc": "1.24.3",
     "bson": "1.24.3"
  }
}
}
```

### Sanity check for Cygnus

Once Cygnus is running, you can check the status by the following command:

#### Request:

```bash
ngsi version --host cygnus.local --pretty
```

#### Response:

```json
{
  "success": "true",
  "version": "3.8.0.f62eff701c01df1f708e0c9484e48e7b9bd9b1ed"
}
```

### Sanity check for Comet

Once Comet is running, you can check the status by the following command:

#### Request:

```bash
ngsi version --host comet.local
```

#### Response:

```json
{"version":"2.11.0"}
```

### Sanity check for Perseo

Once Perseo is running, you can check the status by the following command:

#### Request:

```bash
ngsi version --host perseo.local --pretty
```

#### Response:

```json
{
  "error": null,
  "data": {
    "name": "perseo",
    "description": "IOT CEP front End",
    "version": "1.30.0"
  }
}
```

### Get QuantumLeap version

Once QuantumLeap is running, you can get the version by the following command:

#### Request:

```bash
ngsi version --host quantumleap.local
```

#### Response:

```json
{
  "version": "1.0.0"
}
```

### Sanity check for QuantumLeap

You can check the status by the following command:

#### Request:

```bash
ngsi health --host quantumleap.local
```

#### Response:

```json
{
  "status": "pass"
}
```

### Sanity check for IoT Agent for UL

Once IoT Agent for UltraLight 2.0 is running, you can check the status by the following command:

#### Request:

```bash
ngsi version --host iotagent.local --pretty
```

#### Response:

```json
{
  "libVersion": "4.4.0",
  "port": "4041",
  "baseRoot": "/",
  "version": "3.4.0"
}
```

### Sanity check for IoT Agent for JSON

Once IoT Agent for JSON is running, you can check the status by the following command:

#### Request:

```bash
ngsi version --host iotagent.local --pretty
```

#### Response:

```json
{
  "libVersion": "4.4.0",
  "port": "4041",
  "baseRoot": "/",
  "version": "3.4.0"
}
```

### Sanity check for WireCloud 

#### Create superuser

To sign in WireCloud, create superuser as shown:

```
make superuser
```

```
Username (leave blank to use 'root'):
Email address:
Password:
Password (again):
Superuser created successfully.
```

#### Open WireCloud GUI and sign in it.

Open at `http://<your local ip address>` to access the WireCloud GUI.

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Small-Bang/gh-pages/images/wirecloud/wirecloud-sign-in.png)

### Access WireCloud API

#### Request:

```bash
ngsi version --host wirecloud.local --pretty
```

#### Response:

```json
{
  "ApplicationMashup": "2.2",
  "ComponentManagement": "1.0",
  "DashboardManagement": "1.0",
  "FIWARE": "7.7.1",
  "FullscreenWidget": "0.5",
  "NGSI": "1.2.1",
  "OAuth2Provider": "0.5",
  "ObjectStorage": "0.5",
  "StyledElements": "0.10.0",
  "Wirecloud": "1.3.1"
}
```

### Sanity check for Node-RED

Open at `http://<your local ip address>:1880` to access the Node-RED GUI.

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Small-Bang/gh-pages/images/node-red/node-red-sign-in.png)

### Access Node-RED API

Request to the Admin HTTP API.

#### Request:

```bash
curl http://<your local ip address>:1880/settings
```

#### Response:

```json
{
  "httpNodeRoot": "/",
  "version": "3.1.0",
  "context": {
    "default": "memory",
    "stores": [
      "memory"
    ]
  },
  "codeEditor": {
    "lib": "monaco",
    "options": {}
  },
  "markdownEditor": {
    "mermaid": {
      "enabled": true
    }
  },
  "libraries": [
    {
      "id": "local",
      "label": "editor:library.types.local",
      "user": false,
      "icon": "font-awesome/fa-hdd-o"
    },
    {
      "id": "examples",
      "label": "editor:library.types.examples",
      "user": false,
      "icon": "font-awesome/fa-life-ring",
      "types": [
        "flows"
      ],
      "readOnly": true
    }
  ],
  "flowFilePretty": true,
  "externalModules": {},
  "flowEncryptionType": "system",
  "diagnostics": {
    "enabled": true,
    "ui": true
  },
  "runtimeState": {
    "enabled": false,
    "ui": false
  },
  "functionExternalModules": true,
  "functionTimeout": 0,
  "tlsConfigDisableLocalFiles": false,
  "editorTheme": {
    "palette": {},
    "projects": {
      "enabled": false,
      "workflow": {
        "mode": "manual"
      }
    },
    "languages": [
      "de",
      "en-US",
      "fr",
      "ja",
      "ko",
      "pt-BR",
      "ru",
      "zh-CN",
      "zh-TW"
    ]
  }
}
```
