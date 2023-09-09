[![FIWARE Small BangBanner](https://raw.githubusercontent.com/lets-fiware/FIWARE-Small-Bang/gh-pages/images/FIWARE-Small-Bang-non-free.png)](https://www.letsfiware.jp/)
[![NGSI v2](https://img.shields.io/badge/NGSI-v2-5dc0cf.svg)](https://fiware-ges.github.io/orion/api/v2/stable/)

![FIWARE: Tools](https://nexus.lab.fiware.org/repository/raw/public/badges/chapters/deployment-tools.svg)
[![License: MIT](https://img.shields.io/github/license/lets-fiware/FIWARE-Small-Bang.svg)](https://opensource.org/licenses/MIT)
[![GitHub Discussions](https://img.shields.io/github/discussions/lets-fiware/FIWARE-Small-Bang)](https://github.com/lets-fiware/FIWARE-Small-Bang/discussions)
<br/>
[![Lint](https://github.com/lets-fiware/FIWARE-Small-Bang/actions/workflows/lint.yml/badge.svg)](https://github.com/lets-fiware/FIWARE-Small-Bang/actions/workflows/lint.yml)
[![Tests](https://github.com/lets-fiware/FIWARE-Small-Bang/actions/workflows/ubuntu-latest.yml/badge.svg)](https://github.com/lets-fiware/FIWARE-Small-Bang/actions/workflows/ubuntu-latest.yml)
[![codecov](https://codecov.io/gh/lets-fiware/FIWARE-Small-Bang/graph/badge.svg?token=NYMGIUqFlH)](https://codecov.io/gh/lets-fiware/FIWARE-Small-Bang)
<br/>
[![Ubuntu 20.04](https://github.com/lets-fiware/FIWARE-Small-Bang/actions/workflows/ubuntu-20.04.yml/badge.svg)](https://github.com/lets-fiware/FIWARE-Small-Bang/actions/workflows/ubuntu-20.04.yml)
[![Ubuntu 22.04](https://github.com/lets-fiware/FIWARE-Small-Bang/actions/workflows/ubuntu-22.04.yml/badge.svg)](https://github.com/lets-fiware/FIWARE-Small-Bang/actions/workflows/ubuntu-22.04.yml)
<br/>

FIWARE Small Bang は、ローカル・マシンに FIWARE インスタンスをセットアップするためのターンキー・ソリューションです。

| :books: [Documentation](https://fi-sb.letsfiware.jp/ja/) | :dart: [Roadmap](./ROADMAP.md) |
|----------------------------------------------------------|--------------------------------|

## FIWARE Small Bang とは

FIWARE Small Bang を使用すると、FIWARE Generic enablers を手元のローカル・マシンに簡単にインストールできます。
FI-SB は FIWARE Small Bang の略称です。

## サポートしている FIWARE GEs とサードパーティ・オープンソース・ソフトウェア

### サポートしている FIWARE GEs

-   Orion
-   Cygnus
-   Comet
-   Perseo
-   QuantumLeap
-   WireCloud
-   Ngsiproxy
-   IoT Agent for UltraLight (over HTTP and MQTT)
-   IoT Agent for JSON (over HTTP and MQTT)

### サポートしているサードパーティ・オープンソース・ソフトウェア

-   Node-RED
-   Mosquitto
-   Elasticsearch (コンテキスト・データを永続化するためのデータベースとして使用)

## 要件

-   サポートしている Linux ディストリビューション
    -   Ubuntu 22.04 LTS (x86_64, Aarch64)
    -   Ubuntu 20.04 LTS
    -   CentOS Stream release 9
    -   CentOS Stream release 8
    -   Rocky Linux 9
    -   Rocky Linux 8
    -   AlmaLinux 9
    -   AlmaLinux 8

-   macOS (Intel, Apple Silicon)

## 前提条件

セットアップ・スクリプトを実行する前に、Docker と Docker compose plugin を導入します。

## 使用方法

FIWARE Small Bang の tar.gz ファイルをダウンロードします。

```bash
curl -sL https://github.com/lets-fiware/FIWARE-Small-Bang/releases/download/v0.1.0/FIWARE-Small-Bang-0.1.0.tgz | tar zxf -
```

`FIWARE-Small-Bang-0.1.0` ディレクトリに移動します。

```bash
cd FIWARE-Small-Bang-0.1.0/
```

`setup-fiware.sh` スクリプトを実行します。

```bash
./setup-fiware.sh
```

## ドキュメント

-   [https://fi-sb.letsfiware.jp/ja/](https://fi-sb.letsfiware.jp/ja/)

## ソースコード

-   [https://github.com/lets-fiware/FIWARE-Small-Bang](https://github.com/lets-fiware/FIWARE-Small-Bang)

## Copyright and License

Copyright (c) 2023 Kazuhito Suda<br>
Licensed under the [MIT License](./LICENSE).
