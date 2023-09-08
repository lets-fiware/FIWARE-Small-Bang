[![FIWARE Small BangBanner](https://raw.githubusercontent.com/lets-fiware/FIWARE-Small-Bang/gh-pages/images/FIWARE-Small-Bang-non-free.png)](https://www.letsfiware.jp/)
[![NGSI v2](https://img.shields.io/badge/NGSI-v2-5dc0cf.svg)](https://fiware-ges.github.io/orion/api/v2/stable/)

![FIWARE: Tools](https://nexus.lab.fiware.org/repository/raw/public/badges/chapters/deployment-tools.svg)
[![License: MIT](https://img.shields.io/github/license/lets-fiware/FIWARE-Small-Bang.svg)](https://opensource.org/licenses/MIT)
[![GitHub Discussions](https://img.shields.io/github/discussions/lets-fiware/FIWARE-Small-Bang)](https://github.com/lets-fiware/FIWARE-Small-Bang/discussions)
<br/>

The FIWARE Small Bang is a turnkey solution for setting up a FIWARE instance on your local machine.

| :books: [Documentation](https://fi-sb.letsfiware.jp/) | :dart: [Roadmap](./ROADMAP.md) |
|-------------------------------------------------------|--------------------------------|

このドキュメントは[日本語](./README.ja.md)でもご覧いただけます。

## What is FIWARE Small Bang?

The FIWARE Small Bang allows you to install FIWARE Generic enablers easily into your local machine.
FI-SB stands for FIWARE Small Bang.

## Supported FIWARE GEs and third-party open source software

### Supported FIWARE GEs

-   Orion
-   Cygnus
-   Comet
-   Perseo
-   QuantumLeap
-   WireCloud
-   Ngsiproxy
-   IoT Agent for UltraLight (over HTTP and MQTT)
-   IoT Agent for JSON (over HTTP and MQTT)

### Supported third-party open source software

-   Node-RED
-   Mosquitto
-   Elasticsearch (as a database for persitenting context data)

## Requirements

-   Supported Linux distribution
    -   Ubuntu 22.04 LTS
    -   Ubuntu 20.04 LTS
    -   CentOS Stream release 9
    -   CentOS Stream release 8
    -   Rocky Linux 9
    -   Rocky Linux 8
    -   AlmaLinux 9
    -   AlmaLinux 8

## Prerequisite

Before running the setup script, you need to install docker and docker compose plugin.

## Getting Started

Download a tar.gz file for the FIWARE Small Bang.

```bash
curl -sL https://github.com/lets-fiware/FIWARE-Small-Bang/archive/refs/tags/v0.0.1.tar.gz | tar zxf -
```

Move to the `FIWARE-Small-Bang-0.0.1` directory.

```bash
cd FIWARE-Small-Bang-0.0.1/
```

Run the `setup-fiware.sh` script.

```bash
./setup-fiware.sh
```

## Documentation

-   [https://fi-sb.letsfiware.jp/](https://fi-sb.letsfiware.jp/)

## Source code 

-   [https://github.com/lets-fiware/FIWARE-Small-Bang](https://github.com/lets-fiware/FIWARE-Small-Bang)

## Copyright and License

Copyright (c) 2023 Kazuhito Suda<br>
Licensed under the [MIT License](./LICENSE).
