[![FIWARE Small BangBanner](https://raw.githubusercontent.com/lets-fiware/FIWARE-Small-Bang/gh-pages/images/FIWARE-Small-Bang-non-free.png)](https://www.letsfiware.jp/)
[![NGSI v2](https://img.shields.io/badge/NGSI-v2-5dc0cf.svg)](https://fiware-ges.github.io/orion/api/v2/stable/)

![FIWARE: Tools](https://nexus.lab.fiware.org/repository/raw/public/badges/chapters/deployment-tools.svg)
[![License: MIT](https://img.shields.io/github/license/lets-fiware/FIWARE-Small-Bang.svg)](https://opensource.org/licenses/MIT)
[![GitHub Discussions](https://img.shields.io/github/discussions/lets-fiware/FIWARE-Small-Bang)](https://github.com/lets-fiware/FIWARE-Small-Bang/discussions)
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
    -   Ubuntu 22.04 LTS
    -   Ubuntu 20.04 LTS
    -   CentOS Stream release 9
    -   CentOS Stream release 8
    -   Rocky Linux 9
    -   Rocky Linux 8
    -   AlmaLinux 9
    -   AlmaLinux 8

## 前提条件

セットアップ・スクリプトを実行する前に、Docker と Docker compose plugin を導入します。

## 使用方法

FIWARE Small Bang の tar.gz ファイルをダウンロードします。

```bash
curl -sL https://github.com/lets-fiware/FIWARE-Small-Bang/archive/refs/tags/v0.0.1.tar.gz | tar zxf -
```

`FIWARE-Small-Bang-0.0.1` ディレクトリに移動します。

```bash
cd FIWARE-Small-Bang-0.0.1/
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
