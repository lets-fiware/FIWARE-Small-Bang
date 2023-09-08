# Node-RED

## コンテンツ

<details>
<summary><strong>詳細</strong></summary>

-   [Node-RED の健全性チェック](#sanity-check-node-red)
-   [Node-RED API へのアクセス](#access-node-red-api)
-   [NGSI node の使用方法](#how-to-use-ngsi-node)
-   [Context-Broker node の構成](#configration-for-context-broker-node)
-   [例](#examples)
-   [関連情報](#related-information)

</details>

<a name="sanity-check-node-red"></a>

## Node-RED の健全性チェック

Web ブラウザで、`https://node-red.local` を開いて、 Node-RED GUI にアクセスします。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Small-Bang/gh-pages/images/node-red/node-red-sign-in.png)

<a name="access-node-red-api"></a>

## Node-RED API へのアクセス

Node-RED Admin HTTP API にアクセスします。

### Node-RED Admin HTTP API へのアクセス

#### リクエスト:

```bash
curl http://<your local IP address>:1880/settings
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

<a name="how-to-use-ngsi-node"></a>

## NGSI node の使用方法

### エンティティを作成

#### リクエスト:

```
ngsi create \
  --host orion.local \
  entity \
  --data '{"id":"device001"}' \
  --keyValues
```

### エンティティを取得

#### リクエスト:

```bash
ngsi get \
  --host orion.local \
  entity \
  --id device001 \
  --pretty
```

#### レスポンス:

```json
{
  "id": "device001",
  "type": "Thing"
}
```

## フローを作成

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Small-Bang/gh-pages/images/node-red/node-red-001.png)

```
[{"id":"f5717ef56f6b92ee","type":"tab","label":"Flow 1","disabled":false,"info":"","env":[]},{"id":"d64a75632b691651","type":"NGSI Entity","z":"f5717ef56f6b92ee","openapis":"c574ed7e49fe8012","servicepath":"/","mode":"normalized","entitytype":"","attrs":"","x":410,"y":100,"wires":[["1600fecad297713b"]]},{"id":"ac8c9b2cb6a23119","type":"inject","z":"f5717ef56f6b92ee","name":"","props":[{"p":"payload"}],"repeat":"","crontab":"","once":false,"onceDelay":0.1,"topic":"","payload":"device001","payloadType":"str","x":240,"y":100,"wires":[["d64a75632b691651"]]},{"id":"1600fecad297713b","type":"debug","z":"f5717ef56f6b92ee","name":"","active":true,"tosidebar":true,"console":false,"tostatus":false,"complete":"false","statusVal":"","statusType":"auto","x":590,"y":100,"wires":[]},{"id":"c574ed7e49fe8012","type":"Open APIs","name":"","brokerEndpoint":"https://orion.local","service":"","idmEndpoint":"https://orion.local","idmType":"tokenproxy"}]
```

## ノードの構成

### NGSI Entity node の構成

新しい Open API エンドポイントを追加します。

-   Open APIs endpoint の構成

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Small-Bang/gh-pages/images/node-red/node-red-002.png)

### Context-Broker node の構成

ブローカー・エンドポイントとセキュリティ構成をセットアップします。

-   Broker Endpoint: `http://<your local IP address>:1026`

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Small-Bang/gh-pages/images/node-red/node-red-003.png)

### ペイロードを挿入

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Small-Bang/gh-pages/images/node-red/node-red-004.png)

<a name="examples"></a>

## 例

[こちら](https://github.com/lets-fiware/FIWARE-Small-Bang/tree/main/examples/node-red)の例を参照ください。

<a name="related-information"></a>

## 関連情報

-   [lets-fiware / node-red-contrib-letsfiware-NGSI - GitHub](https://github.com/lets-fiware/node-red-contrib-letsfiware-NGSI)
-   [node-red-contrib-letsfiware-NGSI documentation](https://node-red-contrib-letsfiware-ngsi.letsfiware.jp/)
-   [Node-RED - GitHub](https://github.com/node-red/node-red)
-   [Node-RED portal site](https://nodered.org/)
-   [nodered/node-red - Docker Hub](https://hub.docker.com/r/nodered/node-red)
