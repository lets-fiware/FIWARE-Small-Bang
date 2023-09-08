# NGSI Go

The NGSI Go is a command-line interface supporting FIWARE Open APIs for FIWARE developers.
You will have easy access to FIWARE Open APIs by installing NGSI Go on your client PC.
See full documentation [here](https://ngsi-go.letsfiware.jp/) for details.

## Install

### Install NGSI Go binary

The NGSI Go binary is installed in `/usr/local/bin`.

#### Installation on Linux

```console
curl -OL https://github.com/lets-fiware/ngsi-go/releases/download/v0.12.0/ngsi-v0.13.0-linux-amd64.tar.gz
sudo tar zxvf ngsi-v0.13.0-linux-amd64.tar.gz -C /usr/local/bin
```

`ngsi-v0.13.0-linux-arm.tar.gz` and `ngsi-v0.13.0-linux-arm64.tar.gz` binaries are also available.

#### Installation on Mac

```console
curl -OL https://github.com/lets-fiware/ngsi-go/releases/download/v0.12.0/ngsi-v0.13.0-darwin-amd64.tar.gz
sudo tar zxvf ngsi-v0.13.0-darwin-amd64.tar.gz -C /usr/local/bin
```

`ngsi-v0.13.0-darwin-arm64.tar.gz` binary is also available.

### Install bash autocomplete file for NGSI Go

Install ngsi_bash_autocomplete file in `/etc/bash_completion.d`.

```console
curl -OL https://raw.githubusercontent.com/lets-fiware/ngsi-go/main/autocomplete/ngsi_bash_autocomplete
sudo mv ngsi_bash_autocomplete /etc/bash_completion.d/
source /etc/bash_completion.d/ngsi_bash_autocomplete
echo "source /etc/bash_completion.d/ngsi_bash_autocomplete" >> ~/.bashrc
```

## Set up

The followings are setting-up examples to access each FIWARE GE.

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

## Related information

-   [NGSI Go - GitHub](http://github.com/lets-fiware/ngsi-go)
-   [NGSI Go - Full documentation](http://ngsi-go.letsfiware.jp/)
