# 注文集約Skeletonコードの生成

## なぜ (Why)

参照実装(`references/cqrs-es-example-go`)を元に、CQRS/Event Sourcingアーキテクチャの基本構造を持つSkeletonコードを生成する。このSkeletonは、新しいドメインモデルを実装する際のテンプレートとして機能し、プロジェクト規約に従った標準的な構造を提供する。

参照実装はグループチャットドメインであるが、今回は注文集約(Order)を想定したSkeletonを作成する。これにより、開発者は参照実装のパターンに従って、独自のドメインモデルを迅速に実装できるようになる。

## 何が変わるか (What Changes)

- **新規追加**: 注文集約(Order)のドメインモデル一式を作成
  - 集約ルート: `pkg/command/domain/order.go`
  - 値オブジェクト:
    - `pkg/command/domain/models/order_id.go`
    - `pkg/command/domain/models/order_items.go`
    - `pkg/command/domain/models/order_item.go`
    - `pkg/command/domain/models/order_item_id.go`
    - `pkg/command/domain/models/product_id.go`
    - `pkg/command/domain/models/quantity.go`
    - `pkg/command/domain/models/price.go`
  - ドメインイベント:
    - `pkg/command/domain/events/order_event.go`
    - `pkg/command/domain/events/order_created.go`
    - `pkg/command/domain/events/order_item_added.go`
    - `pkg/command/domain/events/order_item_removed.go`
    - `pkg/command/domain/events/order_confirmed.go`
    - `pkg/command/domain/events/order_cancelled.go`
  - ドメインエラー:
    - `pkg/command/domain/errors/errors.go` (既存のものを再利用)

- **新規追加**: コマンドプロセッサ
  - `pkg/command/processor/order_command_processor.go`

- **新規追加**: リポジトリ実装
  - `pkg/command/interfaceAdaptor/repository/order_repository.go`
  - `pkg/command/interfaceAdaptor/repository/event_converter.go` (Orderイベント用の拡張)
  - `pkg/command/interfaceAdaptor/repository/snapshot_converter.go` (Orderスナップショット用の拡張)
  - `pkg/command/interfaceAdaptor/repository/event_serializer.go` (Orderイベント用の拡張)
  - `pkg/command/interfaceAdaptor/repository/snapshot_serializer.go` (Orderスナップショット用の拡張)

- **新規追加**: GraphQL インターフェース (コマンドサイド)
  - `pkg/command/interfaceAdaptor/graphql/schema.graphqls` (Order用のスキーマ追加)
  - `pkg/command/interfaceAdaptor/graphql/schema.resolvers.go` (Order用のリゾルバー追加)

- **新規追加**: クエリサイド
  - `pkg/query/interfaceAdaptor/graphql/schema.graphqls` (Order用のクエリスキーマ追加)
  - `pkg/query/interfaceAdaptor/graphql/schema.resolvers.go` (Order用のクエリリゾルバー追加)

- **新規追加**: Read Model Updater
  - `pkg/rmu/order_dao.go`
  - `pkg/rmu/order_dao_impl.go`
  - `pkg/rmu/update_read_model.go` (Order用の拡張)

- **新規追加**: テストコード
  - `pkg/command/domain/order_test.go`
  - `pkg/command/processor/order_command_processor_test.go`
  - `pkg/command/interfaceAdaptor/repository/order_repository_test.go`
  - `pkg/command/interfaceAdaptor/graphql/schema.resolvers_test.go` (Order用のテスト追加)

- **新規追加**: 型定義
  - `pkg/command/domain/types.go` (Order用の型エイリアス追加)

- **新規追加**: アプリケーション層
  - `cmd/writeApi.go` (Order用のルーティング追加)
  - `cmd/readApi.go` (Order用のクエリルーティング追加)
  - `cmd/rmu.go` (Order用のイベントハンドラー追加)
  - `cmd/localRmu.go` (Order用のローカルRMU追加)

- **新規追加**: インフラストラクチャ
  - `tools/migrate/migrations/X_create_orders.up.sql`
  - `tools/migrate/migrations/X_create_order_items.up.sql`
  - `Dockerfile` (確認・更新)
  - `Dockerfile.rmu` (確認・更新)
  - `Makefile` (Order用ターゲット追加)

- **新規追加**: E2Eテストと検証スクリプト
  - `tools/scripts/curl-create-order.sh`
  - `tools/scripts/curl-add-order-item.sh`
  - `tools/scripts/curl-confirm-order.sh`
  - `tools/scripts/curl-cancel-order.sh`
  - `tools/scripts/curl-get-order.sh`
  - `tools/scripts/curl-get-orders.sh`
  - `tools/scripts/curl-get-order-item.sh`
  - `tools/scripts/curl-create-and-get-order.sh`
  - `tools/e2e-test/verify-order.sh`
  - `tools/e2e-test/config.env` (Order用の環境変数追加)

- **新規追加**: ドキュメント
  - `docs/API_SPEC.md` (Order用のAPI仕様追加)
  - `docs/API_SPEC.ja.md` (Order用のAPI仕様追加、日本語版)

## 影響 (Impact)

- **影響を受ける仕様**: order-aggregate (新規作成)
- **影響を受けるコード**:
  - 新規パッケージ: `pkg/command/domain/`, `pkg/command/processor/`, `pkg/command/interfaceAdaptor/`
  - 新規パッケージ: `pkg/query/interfaceAdaptor/`
  - 新規パッケージ: `pkg/rmu/`
- **依存関係**:
  - `github.com/j5ik2o/event-store-adapter-go` (既存の依存関係を使用)
  - `github.com/samber/mo` (既存の依存関係を使用)
  - `github.com/oklog/ulid/v2` (既存の依存関係を使用)
  - `github.com/barweiss/go-tuple` (既存の依存関係を使用)
- **後方互換性**: なし (新規追加のみ)

## 注意事項

このSkeletonコードは、実際のビジネスロジックの実装例であり、参照実装のパターンに従っている。開発者は、このSkeletonを元に、独自のドメインモデルを実装する際の指針として利用できる。

### 検証方法

実装完了後、以下の手順で検証を行う:

1. **ビルドと起動**
   ```bash
   make docker-build
   tools/scripts/docker-compose-up.sh
   ```

2. **個別機能テスト**
   ```bash
   tools/scripts/curl-create-order.sh
   tools/scripts/curl-add-order-item.sh
   tools/scripts/curl-get-order.sh
   ```

3. **E2Eテスト**
   ```bash
   tools/scripts/docker-compose-e2e-test.sh
   ```

4. **停止**
   ```bash
   tools/scripts/docker-compose-down.sh
   ```
