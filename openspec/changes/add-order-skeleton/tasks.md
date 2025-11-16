# 注文集約Skeleton実装タスク

## 1. ドメイン層の実装

### 1.1 値オブジェクトの実装
- [ ] 1.1.1 `pkg/command/domain/models/order_id.go` を作成 (参照: `group_chat_id.go`)
- [ ] 1.1.2 `pkg/command/domain/models/order_item_id.go` を作成 (参照: `member_id.go`)
- [ ] 1.1.3 `pkg/command/domain/models/product_id.go` を作成 (参照: `user_account_id.go`)
- [ ] 1.1.4 `pkg/command/domain/models/quantity.go` を作成 (新規、整数値オブジェクト)
- [ ] 1.1.5 `pkg/command/domain/models/price.go` を作成 (新規、整数値オブジェクト)
- [ ] 1.1.6 `pkg/command/domain/models/order_item.go` を作成 (参照: `member.go`)
- [ ] 1.1.7 `pkg/command/domain/models/order_items.go` を作成 (参照: `members.go`)

### 1.2 ドメインイベントの実装
- [ ] 1.2.1 `pkg/command/domain/events/order_event.go` を作成 (参照: `group_chat_event.go`)
- [ ] 1.2.2 `pkg/command/domain/events/order_created.go` を作成 (参照: `group_chat_created.go`)
- [ ] 1.2.3 `pkg/command/domain/events/order_item_added.go` を作成 (参照: `group_chat_member_added.go`)
- [ ] 1.2.4 `pkg/command/domain/events/order_item_removed.go` を作成 (参照: `group_chat_member_removed.go`)
- [ ] 1.2.5 `pkg/command/domain/events/order_confirmed.go` を作成 (新規、OrderConfirmedイベント)
- [ ] 1.2.6 `pkg/command/domain/events/order_cancelled.go` を作成 (参照: `group_chat_deleted.go`)

### 1.3 集約ルートの実装
- [ ] 1.3.1 `pkg/command/domain/order.go` を作成 (参照: `group_chat.go`)
  - NewOrder関数 (注文作成)
  - AddOrderItem メソッド (注文アイテム追加)
  - RemoveOrderItem メソッド (注文アイテム削除)
  - ConfirmOrder メソッド (注文確定)
  - CancelOrder メソッド (注文キャンセル)
  - ReplayOrder関数 (イベントリプレイ)
  - ApplyEvent メソッド (イベント適用)

### 1.4 型定義の拡張
- [ ] 1.4.1 `pkg/command/domain/types.go` にOrder用の型エイリアスを追加

## 2. アプリケーション層の実装

### 2.1 コマンドプロセッサの実装
- [ ] 2.1.1 `pkg/command/processor/order_command_processor.go` を作成 (参照: `group_chat_command_processor.go`)
  - CreateOrder ハンドラー
  - AddOrderItem ハンドラー
  - RemoveOrderItem ハンドラー
  - ConfirmOrder ハンドラー
  - CancelOrder ハンドラー
  - エラー型の定義

## 3. インフラストラクチャ層の実装

### 3.1 リポジトリの実装
- [ ] 3.1.1 `pkg/command/interfaceAdaptor/repository/order_repository.go` を作成 (参照: `group_chat_repository.go`)
  - OrderRepository インターフェース
  - OrderRepositoryImpl 構造体
  - Store, FindById メソッド

### 3.2 イベント・スナップショットコンバーター/シリアライザーの実装
- [ ] 3.2.1 `event_converter.go` にOrder用のコンバーター関数を追加
  - convertToOrderEvent 関数
  - convertToOrderCreated 関数
  - convertToOrderItemAdded 関数
  - convertToOrderItemRemoved 関数
  - convertToOrderConfirmed 関数
  - convertToOrderCancelled 関数

- [ ] 3.2.2 `snapshot_converter.go` にOrder用のコンバーター関数を追加
  - convertToOrder 関数
  - convertOrderToSnapshot 関数

- [ ] 3.2.3 `event_serializer.go` にOrder用のシリアライザー関数を追加
  - serializeOrderEvent 関数
  - deserializeOrderEvent 関数

- [ ] 3.2.4 `snapshot_serializer.go` にOrder用のシリアライザー関数を追加
  - serializeOrder 関数
  - deserializeOrder 関数

### 3.3 GraphQLインターフェース (コマンドサイド) の実装
- [ ] 3.3.1 `pkg/command/interfaceAdaptor/graphql/schema.graphqls` にOrder用のスキーマを追加
  - CreateOrderInput 型
  - AddOrderItemInput 型
  - RemoveOrderItemInput 型
  - ConfirmOrderInput 型
  - CancelOrderInput 型
  - OrderResult 型
  - Mutation 型に上記のミューテーションを追加

- [ ] 3.3.2 `pkg/command/interfaceAdaptor/graphql/schema.resolvers.go` にOrder用のリゾルバーを実装
  - CreateOrder リゾルバー
  - AddOrderItem リゾルバー
  - RemoveOrderItem リゾルバー
  - ConfirmOrder リゾルバー
  - CancelOrder リゾルバー

- [ ] 3.3.3 `pkg/command/interfaceAdaptor/graphql/model/models_gen.go` を再生成 (gqlgen)

## 4. クエリサイドの実装

### 4.1 GraphQLインターフェース (クエリサイド) の実装
- [ ] 4.1.1 `pkg/query/interfaceAdaptor/graphql/schema.graphqls` にOrder用のクエリスキーマを追加
  - Order 型
  - OrderItem 型
  - Query 型に以下を追加:
    - getOrder(orderId: String!): Order
    - getOrders(userAccountId: String!): [Order!]!
    - getOrderItem(orderId: String!, orderItemId: String!): OrderItem

- [ ] 4.1.2 `pkg/query/interfaceAdaptor/graphql/schema.resolvers.go` にOrder用のクエリリゾルバーを実装
  - GetOrder リゾルバー
  - GetOrders リゾルバー
  - GetOrderItem リゾルバー

- [ ] 4.1.3 `pkg/query/interfaceAdaptor/graphql/model/models_gen.go` を再生成 (gqlgen)

## 5. Read Model Updater の実装

### 5.1 DAOの実装
- [ ] 5.1.1 `pkg/rmu/order_dao.go` を作成 (参照: `group_chat_dao.go`)
  - OrderDao インターフェース定義
  - InsertOrder メソッド
  - UpdateOrderStatus メソッド
  - InsertOrderItem メソッド
  - DeleteOrderItem メソッド

- [ ] 5.1.2 `pkg/rmu/order_dao_impl.go` を作成 (参照: `group_chat_dao_impl.go`)
  - OrderDaoImpl 構造体
  - 各メソッドの実装 (SQL実行)

### 5.2 Read Model更新ロジックの実装
- [ ] 5.2.1 `pkg/rmu/update_read_model.go` にOrder用の更新関数を追加
  - handleOrderCreated 関数
  - handleOrderItemAdded 関数
  - handleOrderItemRemoved 関数
  - handleOrderConfirmed 関数
  - handleOrderCancelled 関数

## 6. テストの実装

### 6.1 ドメイン層のテスト
- [ ] 6.1.1 `pkg/command/domain/order_test.go` を作成 (参照: `group_chat_test.go`)
  - NewOrder のテスト
  - AddOrderItem のテスト
  - RemoveOrderItem のテスト
  - ConfirmOrder のテスト
  - CancelOrder のテスト
  - ReplayOrder のテスト

### 6.2 コマンドプロセッサのテスト
- [ ] 6.2.1 `pkg/command/processor/order_command_processor_test.go` を作成 (参照: `group_chat_command_processor_test.go`)
  - CreateOrder のテスト
  - AddOrderItem のテスト
  - RemoveOrderItem のテスト
  - ConfirmOrder のテスト
  - CancelOrder のテスト

### 6.3 リポジトリのテスト
- [ ] 6.3.1 `pkg/command/interfaceAdaptor/repository/order_repository_test.go` を作成 (参照: `group_chat_repository_test.go`)
  - Store のテスト
  - FindById のテスト

### 6.4 GraphQLリゾルバーのテスト
- [ ] 6.4.1 `pkg/command/interfaceAdaptor/graphql/schema.resolvers_test.go` にOrder用のテストを追加
  - CreateOrder ミューテーションのテスト
  - AddOrderItem ミューテーションのテスト
  - 他のミューテーションのテスト

- [ ] 6.4.2 `pkg/query/interfaceAdaptor/graphql/schema.resolvers_test.go` にOrder用のテストを追加
  - GetOrder クエリのテスト
  - GetOrders クエリのテスト
  - GetOrderItem クエリのテスト

### 6.5 Read Model Updaterのテスト
- [ ] 6.5.1 `pkg/rmu/order_dao_impl_test.go` を作成 (参照: `group_chat_dao_impl_test.go`)
- [ ] 6.5.2 `pkg/rmu/update_read_model_test.go` にOrder用のテストを追加

## 7. アプリケーション層の実装

### 7.1 コマンドエントリーポイントの実装
- [ ] 7.1.1 `cmd/root.go` を確認・更新 (参照実装のパターンに従う)
- [ ] 7.1.2 `cmd/writeApi.go` にOrder用のルーティングを追加
  - OrderCommandProcessorの初期化
  - GraphQLハンドラーの設定
- [ ] 7.1.3 `cmd/readApi.go` にOrder用のクエリルーティングを追加
  - OrderDaoの初期化
  - GraphQLクエリハンドラーの設定
- [ ] 7.1.4 `cmd/rmu.go` にOrder用のイベントハンドラーを追加
  - OrderDaoの初期化
  - DynamoDB Streamsハンドラーの設定
- [ ] 7.1.5 `cmd/localRmu.go` にOrder用のローカルRMUを追加

## 8. インフラストラクチャとデプロイメント

### 8.1 データベースマイグレーション
- [ ] 8.1.1 `tools/migrate/migrations/` にOrder用のマイグレーションファイルを作成
  - `X_create_orders.up.sql` - ordersテーブル作成
  - `X_create_order_items.up.sql` - order_itemsテーブル作成
  - 適切なインデックスとリレーションシップの設定

### 8.2 DynamoDBセットアップ
- [ ] 8.2.1 `tools/dynamodb-setup/create-tables.sh` を確認
  - Order用のテーブルが参照実装と同じパターンで作成されることを確認

### 8.3 Docker Compose設定
- [ ] 8.3.1 `tools/docker-compose/docker-compose-applications.yml` を確認
  - writeApi, readApi, rmu サービスがOrder対応になっていることを確認
- [ ] 8.3.2 `tools/docker-compose/docker-compose-databases.yml` を確認
  - PostgreSQL, DynamoDBの設定を確認
- [ ] 8.3.3 `tools/docker-compose/docker-compose-e2e-test.yml` を確認
  - E2Eテスト用の設定を確認

### 8.4 Dockerfileの作成
- [ ] 8.4.1 `Dockerfile` を確認・更新
  - マルチステージビルドの設定
  - 依存関係のインストール
- [ ] 8.4.2 `Dockerfile.rmu` を確認・更新
  - RMU用のDockerイメージ設定

### 8.5 ビルドスクリプト
- [ ] 8.5.1 `Makefile` にOrder用のターゲットを追加
  - build, test, docker-build などのターゲット
- [ ] 8.5.2 `tools/scripts/docker-compose-build.sh` を確認
- [ ] 8.5.3 `tools/scripts/docker-compose-up.sh` を確認
- [ ] 8.5.4 `tools/scripts/docker-compose-down.sh` を確認
- [ ] 8.5.5 `tools/scripts/docker-compose-ps.sh` を確認

## 9. E2Eテストと検証スクリプト

### 9.1 curlテストスクリプトの作成
- [ ] 9.1.1 `tools/scripts/curl-create-order.sh` を作成 (参照: `curl-create-group-chat.sh`)
  - createOrder ミューテーションのテスト
- [ ] 9.1.2 `tools/scripts/curl-add-order-item.sh` を作成 (参照: `curl-add-member.sh`)
  - addOrderItem ミューテーションのテスト
- [ ] 9.1.3 `tools/scripts/curl-confirm-order.sh` を作成
  - confirmOrder ミューテーションのテスト
- [ ] 9.1.4 `tools/scripts/curl-cancel-order.sh` を作成
  - cancelOrder ミューテーションのテスト
- [ ] 9.1.5 `tools/scripts/curl-get-order.sh` を作成 (参照: `curl-get-group-chat.sh`)
  - getOrder クエリのテスト
- [ ] 9.1.6 `tools/scripts/curl-get-orders.sh` を作成 (参照: `curl-get-group-chats.sh`)
  - getOrders クエリのテスト
- [ ] 9.1.7 `tools/scripts/curl-get-order-item.sh` を作成
  - getOrderItem クエリのテスト
- [ ] 9.1.8 `tools/scripts/curl-create-and-get-order.sh` を作成 (参照: `curl-create-and-get-group-chat.sh`)
  - 注文作成から取得までの一連のフローテスト

### 9.2 E2Eテストスクリプトの作成
- [ ] 9.2.1 `tools/e2e-test/verify-order.sh` を作成 (参照: `verify-group-chat.sh`)
  - 注文作成
  - 注文アイテム追加
  - 注文確定
  - 注文取得と検証
  - クリーンアップ
- [ ] 9.2.2 `tools/e2e-test/config.env` にOrder用の環境変数を追加
  - USER_ACCOUNT_ID, WRITE_API_SERVER_BASE_URL, READ_API_SERVER_BASE_URL など
- [ ] 9.2.3 `tools/e2e-test/Dockerfile` を確認
- [ ] 9.2.4 `tools/e2e-test/Makefile` を確認

### 9.3 E2Eテスト実行スクリプト
- [ ] 9.3.1 `tools/scripts/docker-compose-e2e-test.sh` を確認・更新
  - Order用のE2Eテストが実行されることを確認

## 10. ドキュメンテーション

### 10.1 READMEの更新
- [ ] 10.1.1 `README.md` にOrder Skeletonの説明を追加
  - Skeletonコードの目的
  - 使用方法
  - カスタマイズ方法
  - Docker Composeでの起動方法
  - E2Eテストの実行方法

### 10.2 コード内ドキュメント
- [ ] 10.2.1 各パッケージに `doc.go` を追加 (必要に応じて)
- [ ] 10.2.2 全ての公開関数・メソッドにGoDocコメントを追加

### 10.3 API仕様ドキュメント
- [ ] 10.3.1 `docs/API_SPEC.md` にOrder用のAPI仕様を追加
  - GraphQL Mutation仕様
  - GraphQL Query仕様
  - リクエスト・レスポンス例
- [ ] 10.3.2 `docs/API_SPEC.ja.md` にOrder用のAPI仕様を追加 (日本語版)

## 11. 検証とクリーンアップ

### 11.1 コード品質チェック
- [ ] 11.1.1 `go fmt` でフォーマットを統一
- [ ] 11.1.2 `go vet` で静的解析を実行
- [ ] 11.1.3 `go test ./...` で全テストを実行
- [ ] 11.1.4 コードレビュー (参照実装との整合性確認)

### 11.2 Docker Compose検証
- [ ] 11.2.1 `make docker-build` でDockerイメージをビルド
- [ ] 11.2.2 `tools/scripts/docker-compose-up.sh` でサービスを起動
- [ ] 11.2.3 `tools/scripts/docker-compose-ps.sh` でサービスの状態を確認
- [ ] 11.2.4 各curlスクリプトで個別機能を検証
- [ ] 11.2.5 `tools/scripts/docker-compose-e2e-test.sh` でE2Eテストを実行
- [ ] 11.2.6 E2Eテストが成功することを確認
- [ ] 11.2.7 `tools/scripts/docker-compose-down.sh` でサービスを停止

### 11.3 OpenSpec検証
- [ ] 11.3.1 `openspec validate add-order-skeleton --strict` を実行
- [ ] 11.3.2 検証エラーを修正

## 依存関係と並列化

### 並列実行可能なタスク
- セクション1.1 (値オブジェクト) の各タスクは並列実行可能
- セクション1.2 (ドメインイベント) の各タスクは並列実行可能
- セクション3.2 の各サブセクション (コンバーター/シリアライザー) は並列実行可能
- セクション6 (テスト) の各サブセクションは、対応する実装完了後に並列実行可能
- セクション9.1 (curlテストスクリプト) の各タスクは並列実行可能

### 順序依存関係
- セクション1.3 (集約ルート) は セクション1.1, 1.2 完了後
- セクション2.1 (コマンドプロセッサ) は セクション1.3 完了後
- セクション3.1 (リポジトリ) は セクション1.3, 1.2 完了後
- セクション3.3, 4.1 (GraphQL) は セクション2.1 完了後
- セクション5 (RMU) は セクション1.2 完了後
- セクション6 (テスト) は 対応する実装完了後
- セクション7 (アプリケーション層) は セクション2.1, 3.1, 5 完了後
- セクション8 (インフラ) は セクション7 完了後
- セクション9 (E2Eテスト) は セクション8 完了後
- セクション11 (検証) は 全実装完了後

### クリティカルパス
1. ドメイン層 (セクション1) → コマンドプロセッサ (セクション2) → リポジトリ (セクション3)
2. GraphQL (セクション3.3, 4.1) → アプリケーション層 (セクション7)
3. インフラ (セクション8) → E2Eテスト (セクション9) → 検証 (セクション11)
