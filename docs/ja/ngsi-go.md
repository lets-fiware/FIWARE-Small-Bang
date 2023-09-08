# NGSI Go

NGSI Go は、FIWARE 開発者向けに FIWARE Open APIs をサポートするコマンドライン・インターフェイスです。
クライアント PC に NGSI Go をインストールすることで、FIWARE Open APIs に簡単にアクセスできます。
詳細については、[こちら](https://ngsi-go.letsfiware.jp/)のドキュメントを参照してください。

## インストール

### NGSI Go バイナリをインストール

NGSI Go バイナリは `/usr/local/bin` にインストールされます。

#### Linux へのインストール

```console
curl -OL https://github.com/lets-fiware/ngsi-go/releases/download/v0.12.0/ngsi-v0.13.0-linux-amd64.tar.gz
sudo tar zxvf ngsi-v0.13.0-linux-amd64.tar.gz -C /usr/local/bin
```

`ngsi-v0.13.0-linux-arm.tar.gz` and `ngsi-v0.13.0-linux-arm64.tar.gz` binaries are also available.

#### Mac へのインストール

```console
curl -OL https://github.com/lets-fiware/ngsi-go/releases/download/v0.12.0/ngsi-v0.13.0-darwin-amd64.tar.gz
sudo tar zxvf ngsi-v0.13.0-darwin-amd64.tar.gz -C /usr/local/bin
```

`ngsi-v0.13.0-darwin-arm64.tar.gz` binary is also available.

### NGSI Go の bash オートコンプリート・ファイルをインストール

ngsi_bash_autocomplete ファイルを `/etc/bash_completion.d` にインストールします。

```console
curl -OL https://raw.githubusercontent.com/lets-fiware/ngsi-go/main/autocomplete/ngsi_bash_autocomplete
sudo mv ngsi_bash_autocomplete /etc/bash_completion.d/
source /etc/bash_completion.d/ngsi_bash_autocomplete
echo "source /etc/bash_completion.d/ngsi_bash_autocomplete" >> ~/.bashrc
```

## セットアップ

以下は、各 FIWARE GE にアクセスするための設定例です。

### Orion

```bash
ngsi broker \
  add \
  --host orion.local \
  --ngsiType v2 \
  --brokerHost "http://<your local ip address>:1026"
```

### Cygnus

```bash
ngsi server add \
  --host cygnus.local \
  --serverType cygnus \
  --serverHost "http://<your local ip address>:5080"
```

### Comet

```bash
ngsi server add \
  --host "comet.local" \
  --serverType comet \
  --serverHost "http://<your local ip address>:8666"
```

### QuantumLeap

```bash
ngsi server add \
  --host "quantumleap.local" \
  --serverType quantumleap \
  --serverHost "http://<your local ip address>:8668" \
```

### IoT Agent for UltraLight

```bash
ngsi server add \
  --host "iotagent-ul.local" \
  --serverType iota \
  --serverHost "http://<your local ip address>:4041" \
  --service openiot \
  --path /
```

### IoT Agent for JSON

```bash
ngsi server add \
  --host "iotagent-json.local" \
  --serverType iota \
  --serverHost "http://<your local ip address>:4041" \
  --service openiot \
  --path /
```

### WireCloud

```bash
ngsi server add \
  --host "wirecloud.local" \
  --serverType wirecloud \
  --serverHost "http://<your local ip address>"
```

## 関連情報

-   [NGSI Go - GitHub](https://github.com/lets-fiware/ngsi-go)
-   [NGSI Go - Full documentation](https://ngsi-go.letsfiware.jp/)
