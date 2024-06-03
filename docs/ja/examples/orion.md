# Orion

## コンテンツ

<details>
<summary><strong>詳細</strong></summary>

-   [Orion の健全性チェック](#sanity-check-for-orion)
-   [例](#examples)
-   [関連情報](#related-information)

</details>

<a name="sanity-check-for-orion"></a>

## Orion の健全性チェック

Orion が起動したら、次のコマンドでステータスを確認できます:

#### リクエスト:

```bash
ngsi version --host orion.local
```

#### レスポンス:

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

<a name="examples"></a>

## 例

[こちら](https://github.com/lets-fiware/FIWARE-Small-Bang/tree/main/examples/orion)の例を見てください。

<a name="related-information"></a>

## 関連情報

-   [FIWARE Orion - GitHub](https://github.com/telefonicaid/fiware-orion)
-   [FIWARE Orion - Read the Docs](https://fiware-orion.readthedocs.io/en/master/)
-   [FIWARE-NGSI v2 Specification](http://telefonicaid.github.io/fiware-orion/api/v2/stable/)
-   [FIWARE-NGSI Simple API (v2) Cookbook](http://telefonicaid.github.io/fiware-orion/api/v2/stable/cookbook/)
-   [Introductory presentations](https://www.slideshare.net/fermingalan/orion-context-broker-20211022)
-   [FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/)
-   [NGSI Go tutorial for NGSIv2](https://ngsi-go.letsfiware.jp/tutorial/ngsi-v2-crud/)
-   [telefonicaiot/fiware-orion - Docker Hub](https://hub.docker.com/r/telefonicaiot/fiware-orion)
