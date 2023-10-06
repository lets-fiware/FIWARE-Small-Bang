# Installation

## Contents

<details>
<summary><strong>Details</strong></summary>

-   [Prerequisite](#prerequisite)
-   [Getting Started](#getting-started)
-   [Configuration parameters](#configuration-parameters)
-   [Related information](#related-information)

</details>

## Prerequisite

Before running the setup script, you need to install docker and docker compose plugin.

## Getting Started

Download a tar.gz file for the FIWARE Small Bang.

```bash
curl -sL  https://github.com/lets-fiware/FIWARE-Small-Bang/releases/download/v0.4.0/FIWARE-Small-Bang-0.4.0.tar.gz | tar zxf -
```

Move to the `FIWARE-Small-Bang-0.4.0` directory.

```bash
cd FIWARE-Small-Bang-0.4.0/
```

Run the `setup-fiware.sh` script.

```bash
./setup-fiware.sh
```

## Configuration parameters

You can specify configurations by editing the `config.sh` file.
The Orion context broker is installed by default.

| Variable name           | Description                                  | Default value | Variable type |
| ----------------------- | -------------------------------------------- | ------------- | ------------- |
| CYGNUS\_MONGO           | Use MongoDB sink for Cygnus.                 | false         | boolean       |
| CYGNUS\_MYSQL           | Use MySQL sink for Cygnus.                   | false         | boolean       |
| CYGNUS\_POSTGRES        | Use PostgreSQL sink for Cygnus.              | false         | boolean       |
| CYGNUS\_ELASTICSEARCH   | Use Elasticsearch sink for Cygnus.           | false         | boolean       |
| MYSQL\_ROOT\_PASSWORD   | Set password for MySQL                       | mysql         | string        |
| POSTGRES\_PASSWORD      | Set password for PostgreSQL                  | postgres      | string        |
| ELASTICSEARCH\_PASSWORD | Set passowrd for Elasticsearch               | elasticsearch | string        |
| COMET                   | Use STH-Comet                                | false         | boolean       |
| QUANTUMLEAP             | Use Quantumleap                              | false         | boolean       |
| PERSEO                  | Use Perseo                                   | false         | boolean       |
| WIRECLOUD               | Use WireCloud                                | false         | boolean       |
| IOTAGENT\_UL            | Use IoT Agent for UltraLight 2.0             | false         | boolean       |
| IOTAGENT\_JSON          | Use IoT Agent for JSON                       | false         | boolean       |
| IOTAGENT\_HTTP          | Use HTTP as transport protocol for IoT Agent | true          | boolean       |
| IOTAGENT\_MQTT          | Use MQTT as transport protocol for IoT Agent | false         | boolean       |
| NODE\_RED               | Use Node-RED                                 | false         | boolean       |
| START\_CONTAINERS       | Start containers after installation          | true          | boolean       |

## Related information

### Orion

-   [FIWARE Orion - GitHub](https://github.com/telefonicaid/fiware-orion)
-   [FIWARE Orion - Read the Docs](https://fiware-orion.readthedocs.io/en/master/)
-   [FIWARE-NGSI v2 Specification](http://telefonicaid.github.io/fiware-orion/api/v2/stable/)
-   [FIWARE-NGSI Simple API (v2) Cookbook](http://telefonicaid.github.io/fiware-orion/api/v2/stable/cookbook/)
-   [Introductory presentations](https://www.slideshare.net/fermingalan/orion-context-broker-20211022)
-   [FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/)
-   [NGSI Go tutorial for NGSIv2](https://ngsi-go.letsfiware.jp/tutorial/ngsi-v2-crud/)
-   [telefonicaiot/fiware-orion - Docker Hub](https://hub.docker.com/r/telefonicaiot/fiware-orion)

### Cygnus

-   [FIWARE Cygnus documentation](https://fiware-cygnus.readthedocs.io/en/latest/)
-   [FIWARE Cygnus - GitHub](https://github.com/telefonicaid/fiware-cygnus)
-   [Persisting context (Apache Flume) - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/historic-context-flume.html)

## Comet

-   [STH-Comet - GitHub](https://github.com/telefonicaid/fiware-sth-comet)
-   [STH-Comet - Read the docs](https://fiware-sth-comet.readthedocs.io/en/latest/)
-   [Short Term History - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/short-term-history.html)
-   [NGSI Go tutorial for STH-Comet](https://ngsi-go.letsfiware.jp/tutorial/comet/)
-   [telefonicaiot/fiware-sth-comet - Docker Hub](https://hub.docker.com/r/telefonicaiot/fiware-sth-comet)

## QuantumLeap

-   [NGSI Timeseries API - GitHub](https://github.com/orchestracities/ngsi-timeseries-api)
-   [QuantumLeap - Read the docs](https://quantumleap.readthedocs.io/en/latest/)
-   [QuantumLeap API - SwaggerHub](https://app.swaggerhub.com/apis/smartsdk/ngsi-tsdb/)
-   [Time-Series Data - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/time-series-data.html)
-   [NGSI Go tutorial for QuantumLeap](https://ngsi-go.letsfiware.jp/tutorial/quantumleap/)
-   [orchestracities/quantumleap - Docker Hub](https://hub.docker.com/r/orchestracities/quantumleap)

## Perseo

-   [Perseo Context-Aware CEP - GitHub](https://github.com/telefonicaid/perseo-fe)
-   [Perseo-core (EPL server) - GitHub](https://github.com/telefonicaid/perseo-core)
-   [NGSI Go tutorial for Perseo](https://ngsi-go.letsfiware.jp/tutorial/perseo/)
-   [telefonicaiot/perseo-fe - Docker Hub](https://hub.docker.com/r/telefonicaiot/perseo-fe)
-   [telefonicaiot/perseo-core - Docker Hub](https://hub.docker.com/r/telefonicaiot/perseo-core)

## WireCloud

-   [WireCloud - GitHub](https://github.com/Wirecloud/wirecloud)
-   [Docker WireCloud - GitHub](https://github.com/Wirecloud/docker-wirecloud)
-   [WireCloud - Read the docs](https://wirecloud.readthedocs.io/en/stable/)
-   [NGSI.js reference documentation](https://ficodes.github.io/ngsijs/stable/NGSI.html)
-   [Application Mashups - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/application-mashups.html)
-   [fiware/wirecloud - Docker Hub](https://hub.docker.com/r/fiware/wirecloud)

## IoT Agent for UltraLight 2.0

-   [iotagent-ul - GitHub](https://github.com/telefonicaid/iotagent-ul)
-   [iotagnet-node-lib - GitHub](https://github.com/telefonicaid/iotagent-node-lib)
-   [iotagent-ul - Read the docs](https://fiware-iotagent-ul.readthedocs.io/en/latest/)
-   [iotagent-node-lib - Read the docs](https://iotagent-node-lib.readthedocs.io/en/latest/)
-   [IoT Agent configuration API - Apiary](https://telefonicaiotiotagents.docs.apiary.io/#reference/configuration-api)
-   [iotagnet-node-lib - Read the docs](https://iotagent-node-lib.readthedocs.io/en/latest/)
-   [IoT Agent for UltraLight - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/iot-agent.html)
-   [IoT Agent over MQTT - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/iot-over-mqtt.html)
-   [NGSI Go tutorial for IoT Agent](https://ngsi-go.letsfiware.jp/tutorial/iot-agent/)
-   [telefonicaiot/iotagent-ul - Docker Hub](https://hub.docker.com/r/telefonicaiot/iotagent-ul)

## IoT Agent for JSON

-   [iotagent-json - GitHub](https://github.com/telefonicaid/iotagent-json)
-   [iotagnet-node-lib - GitHub](https://github.com/telefonicaid/iotagent-node-lib)
-   [iotagent-json - Read the docs](https://fiware-iotagent-json.readthedocs.io/en/latest/)
-   [iotagent-node-lib - Read the docs](https://iotagent-node-lib.readthedocs.io/en/latest/)
-   [IoT Agent configuration API - Apiary](https://telefonicaiotiotagents.docs.apiary.io/#reference/configuration-api)
-   [iotagnet-node-lib - Read the docs](https://iotagent-node-lib.readthedocs.io/en/latest/)
-   [IoT Agent for JSON - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/iot-agent-json.html)
-   [IoT Agent over MQTT - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/iot-over-mqtt.html)
-   [NGSI Go tutorial for IoT Agent](https://ngsi-go.letsfiware.jp/tutorial/iot-agent/)
-   [telefonicaiot/iotagent-json - Docker Hub](https://hub.docker.com/r/telefonicaiot/iotagent-json)

## Node-RED

-   [FIWARE/node-red-contrib-FIWARE_official - GitHub](https://github.com/FIWARE/node-red-contrib-FIWARE_official)
-   [Node-RED - GitHub](https://github.com/node-red/node-red)
-   [Node-RED portal site](https://nodered.org/)
-   [nodered/node-red - Docker Hub](https://hub.docker.com/r/nodered/node-red)
