# インストール後の確認

## コンテンツ

<details>
<summary><strong>詳細</strong></summary>

-   [インストール完了メッセージ](#installation-completion-message)
-   [健全性チェック手順](#sanity-check-procedures)
    -   [Docker コンテナのステータスを取得](#get-the-status-of-docker-containers)
    -   [Orion のバージョンを取得](#get-orion-version)
    -   [Cygnus の健全性チェック](#sanity-check-for-cygnus)
    -   [Comet の健全性チェック](#sanity-check-for-comet)
    -   [Perseo の健全性チェック](#sanity-check-for-perseo)
    -   [QuantumLeap のバージョンを取得](#get-quantumleap-version)
    -   [QuantumLeap の健全性チェック](#sanity-check-for-quantumleap)
    -   [IoT Agent for UL の健全性チェック](#sanity-check-for-iot-agent-for-ul)
    -   [IoT Agent for JSON の健全性チェック](#sanity-check-for-iot-agent-for-json)
    -   [WireCloud の健全性チェック](#sanity-check-for-wirecloud)
    -   [WireCloud API へアクセス](#access-wirecloud-api)
    -   [Node-RED の健全性チェック](#sanity-check-for-node-red)
    -   [Node-RED API へアクセス](#access-node-red-api)

</details>

<a name="installation-completion-message"></a>

## インストール完了メッセージ

インストール後、次のような完了メッセージが表示されます。

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

<a name="sanity-check-procedures"></a>

## 健全性チェック手順

いくつかのコマンドを実行して、FIWARE インスタンスが正常かどうかを確認できます。

<a name="get-the-status-of-docker-containers"></a>

### Docker コンテナのステータスを取得

#### リクエスト:

```bash
make ps
```

#### レスポンス:

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

<a name="get-orion-version"></a>

### Orion のバージョンを取得 

Orion のバージョンは NGSI Go で取得できます。

```bash
ngsi version --host orion.local
```

```json
{
"orion" : {
  "version" : "4.0.0",
  "uptime" : "0 d, 0 h, 0 m, 4 s",
  "git_hash" : "4f9f34df07395c54387a53074f98bef00b1130a3",
  "compile_time" : "Thu Jun 6 07:35:47 UTC 2024",
  "compiled_by" : "root",
  "compiled_in" : "buildkitsandbox",
  "release_date" : "Thu Jun 6 07:35:47 UTC 2024",
  "machine" : "x86_64",
  "doc" : "https://fiware-orion.rtfd.io/en/4.0.0/"
}
}
```

### Cygnus の健全性チェック

Cygnus が起動したら、次のコマンドでステータスを確認できます:

#### リクエスト:

```bash
ngsi version --host cygnus.local --pretty
```

#### レスポンス:

```json
{
  "success": "true",
  "version": "3.8.0.f62eff701c01df1f708e0c9484e48e7b9bd9b1ed"
}
```

<a name="sanity-check-for-comet"></a>

### Comet の健全性チェック

Comet が起動したら、次のコマンドでステータスを確認できます:

#### リクエスト:

```bash
ngsi version --host comet.local
```

#### レスポンス:

```json
{"version":"2.11.0"}
```

<a name="sanity-check-for-perseo"></a>

### Perseo の健全性チェック

Perseo が起動したら、次のコマンドでステータスを確認できます:

#### リクエスト:

```bash
ngsi version --host perseo.local --pretty
```

#### レスポンス:

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

<a name="get-quantumleap-version"></a>

### QuantumLeap のバージョンを取得

QuantumLeap が起動したら、次のコマンドでバージョンを取得できます:

#### リクエスト:

```bash
ngsi version --host quantumleap.local
```

#### レスポンス:

```json
{
  "version": "1.0.0"
}
```

<a name="sanity-check-for-quantumleap"></a>

### QuantumLeap の健全性チェック

次のコマンドでステータスを確認できます:

#### リクエスト:

```bash
ngsi health --host quantumleap.local
```

#### レスポンス:

```json
{
  "status": "pass"
}
```

<a name="sanity-check-for-iot-agent-for-ul"></a>

### IoT Agent for UL の健全性チェック

IoT Agent for UltraLight 2.0 が起動したら、次のコマンドでステータスを確認できます:

#### リクエスト:

```bash
ngsi version --host iotagent-ul.local --pretty
```

#### レスポンス:

```json
{
  "libVersion": "4.4.0",
  "port": "4041",
  "baseRoot": "/",
  "version": "3.4.0"
}
```

<a name="sanity-check-for-iot-agent-for-json"></a>

### IoT Agent for JSON の健全性チェック

IoT Agent for JSON が起動したら、次のコマンドでステータスを確認できます:

#### リクエスト:

```bash
ngsi version --host iotagent-json.local --pretty
```

#### レスポンス:

```json
{
  "libVersion": "4.4.0",
  "port": "4041",
  "baseRoot": "/",
  "version": "3.4.0"
}
```

<a name="sanity-check-for-wirecloud"></a>

### WireCloud の健全性チェック

#### superuser の作成

WireCloud にサインインするために、superuser を作成します:

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

#### WireCloud GUI にアクセスして、サインイン

WireCloud の GUI にアクセスするには、Web ブラウザで、`http://<your local ip address>` を開きます。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Small-Bang/gh-pages/images/wirecloud/wirecloud-sign-in.png)

<a name="access-wirecloud-api"></a>

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

<a name="sanity-check-for-node-red"></a>

### Node-RED の健全性チェック

Node-RED の GUI にアクセスするには、Web ブラウザで、`http://<your local ip address>:1880` を開きます。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Small-Bang/gh-pages/images/node-red/node-red-sign-in.png)

<a name="access-node-red-api"></a>

### Node-RED API へアクセス

Node-RED Admin HTTP API にアクセスします。

#### リクエスト:

```bash
curl http://<your local ip address>:1880/settings
```

#### レスポンス:

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
