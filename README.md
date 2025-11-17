# CQRS/ES Spec Kit for Go

このリポジトリは CQRS/Event Sourcing の参照実装 (`references/cqrs-es-example-go`) を土台に、
新しい集約を素早く立ち上げるための Skeleton を提供します。現時点では Order 集約向けテンプレートを含み、
以下を満たす構造になっています。

- Command/Domain: `pkg/order/command/domain` に Order 集約、値オブジェクト、イベント、エラーを収録。
- Infrastructure: `pkg/order/command/interfaceAdaptor/repository` と `pkg/order/command/processor` が EventStore とドメインの橋渡しを担当。
- Read Model Updater: `pkg/order/rmu` に DAO (`order_dao.go`) と `ReadModelUpdater` を配置し、DynamoDB Streams から読み取りモデルを更新可能。
- Bootstrap: `cmd/order-skeleton` で OnMemory EventStore → Command Processor → ReadModelUpdater までの流れ、`cmd/order-skeleton/lambda` で DynamoDB Streams/Lambda ハンドラの雛形を提供。

詳しい利用手順や参照実装との対応表は `docs/order-skeleton.ja.md` を参照してください。

推奨セルフチェック:

```bash
go test ./...
go run ./cmd/order-skeleton
```

テストとサンプルコマンドが通れば Skeleton の一貫性とイベント配線の動作が確認できます。
