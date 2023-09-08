# システム管理

## コンテンツ

<details>
<summary><strong>詳細</strong></summary>

-   [ファイルとディレクトリのレイアウト](#files-and-directories-layout)
-   [システム管理用 make コマンド](#make-command-for-system-administration)
-   [別のマシンに NGSI Go の環境を作成する方法](#how-to-create-environment-for-ngsi-go-on-another-machine)
    -   [NGSI Go のセットアップ](#setup-ngsi-go)

</details>

<a name="files-and-directories-layout"></a>

## ファイルとディレクトリのレイアウト

以下のファイルとディレクトリが作成されます。

| ファイル、または、ディレクトリ | 説明                                                                                                 |
| ------------------------------ | ---------------------------------------------------------------------------------------------------- |
| .                              | FIWARE Small Bang のルートディレクトリ。これは、setup-fiware.sh コマンドを実行したディレクトリです。 |
| ./docker-compose.yml           | FIWARE GE の構成情報を持つ docker compose 用の構成ファイル。                                         |
| ./.env                         | docker-compose.yml ファイルの環境変数を含むファイル。                                                |
| ./Makefile                     | make コマンド用のファイル。                                                                          |
| ./config                       | Docker コンテナを実行するための構成ファイルを含むディレクトリ。                                      |
| ./data                         | Docker コンテナを実行するための永続データを含むディレクトリ。                                        |
| ./setup\_ngsi\_go.sh           | 別のマシンに NGSI Go をセットアップするためのスクリプト ファイル。                                   |

<a name="make-command-for-system-administration"></a>

## システム管理用 make コマンド

make コマンドを使用して FIWARE インスタンスを管理できます。setup-fiware.sh スクリプトを実行したディレクトリで
make コマンドを実行します。

| Command | Description                                                     |
| ------- | --------------------------------------------------------------- |
| ps      | FIWARE インスタンスの Docker コンテナを一覧表示                 |
| up      | FIWARE インスタンスの Docker コンテナを作成して起動             |
| down    | FIWARE インスタンスの Docker コンテナを停止して削除             |
| clean   | !注意! すべてのデータを含む FIWARE インスタンスをクリーンアップ |
| collect | システム情報の収集                                              |
| info    | サービス URLs の表示                                            |

<a name="how-to-create-environment-for-ngsi-go-on-another-machine"></a>

## 別のマシンに NGSI Go の環境を作成する方法

<a name="setup-ngsi-go"></a>

### NGSI Go のセットアップ

別のマシンで NGSI Go をセットアップするには、[https://github.com/lets-fiware/ngsi-go](https://github.com/lets-fiware/ngsi-go)
を参照してください。そして、マシン上で `setup_ngsi_go.sh` スクリプトをコピーして実行します。
管理者の電子メールとパスワードの入力が必要となります。
