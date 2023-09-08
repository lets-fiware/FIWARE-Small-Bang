# トラブルシューティング

## CrateDB を使用した QuantumLeap

QuantumLeap には、履歴コンテキスト・データを保持するためのバックエンド・データベースである CrateDB を持っています。
CrateDB が `max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]`
エラーですぐに終了する場合は、ホスト・マシンで `sudo sysctl -w vm.max_map_count=262144` コマンドを実行することで
修正できます。詳細については、CrateDB の[ドキュメント](https://crate.io/docs/crate/howtos/en/latest/admin/bootstrap-checks.html#bootstrap-checks)
、および、Docker の[トラブルシューティング・ガイド](https://crate.io/docs/crate/howtos/en/latest/deployment/containers/docker.html#troubleshooting)
を参照してください。

```
sudo sysctl -w vm.max_map_count=262144
```
