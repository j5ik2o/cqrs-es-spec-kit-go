# 注文集約Skeleton設計ドキュメント

## コンテキスト (Context)

このプロジェクトは、CQRS/Event Sourcingアーキテクチャのテンプレートとなるコードを提供することを目的としている。参照実装(`references/cqrs-es-example-go`)は、グループチャットドメインを実装しているが、開発者が独自のドメインモデルを実装する際の指針が不足している。

このため、注文集約(Order)という別のドメインモデルを実装したSkeletonコードを提供し、開発者が参照実装のパターンを理解し、独自のドメインモデルに適用できるようにする。

### 制約

- Go 1.24.0以上を使用
- 既存のイベントストアアダプター(`github.com/j5ik2o/event-store-adapter-go`)との互換性を維持
- 参照実装と同じアーキテクチャパターンに従う
- DDD (Domain-Driven Design)の原則に従う

### ステークホルダー

- **開発者**: このSkeletonコードを使用して、独自のドメインモデルを実装する
- **アーキテクト**: CQRS/Event Sourcingアーキテクチャのベストプラクティスを示す
- **プロジェクトメンテナー**: 参照実装のパターンを維持し、品質を保証する

## ゴール / 非ゴール

### ゴール

- 注文集約(Order)の完全な実装例を提供
- CQRS/Event Sourcingアーキテクチャの基本構造を示す
- 参照実装と同じパターンに従ったコードを生成
- コマンドサイドとクエリサイドの分離を明確に示す
- イベントソーシングとスナップショットの使用方法を示す
- GraphQLインターフェースの実装例を提供

### 非ゴール

- 実際のビジネスロジックの完全な実装 (Skeletonとしての提供)
- データベースマイグレーションスクリプトの提供
- デプロイメント設定の提供
- パフォーマンステストの実装

## 決定事項 (Decisions)

### 1. ドメインモデルの設計

**決定**: 注文集約(Order)は、以下の要素で構成される:

- **集約ルート**: Order
- **エンティティ**: OrderItem (注文アイテム)
- **値オブジェクト**:
  - OrderId (注文ID)
  - OrderItemId (注文アイテムID)
  - ProductId (商品ID)
  - Quantity (数量)
  - Price (価格)
  - UserAccountId (ユーザーアカウントID、注文の所有者)

**理由**:
- 注文は、複数の注文アイテムを持つ集約として自然にモデル化できる
- 参照実装のGroupChatとMembersの関係に類似しており、パターンの再利用が容易
- DDDの集約パターンに従っている

**検討した代替案**:
- 注文と注文アイテムを別々の集約として扱う → 却下 (トランザクション境界が複雑になる)
- 注文ステータス (OrderStatus) を値オブジェクトとして追加 → 将来の拡張として保留

### 2. ドメインイベントの設計

**決定**: 以下のドメインイベントを実装:

1. `OrderCreated` - 注文作成時
2. `OrderItemAdded` - 注文アイテム追加時
3. `OrderItemRemoved` - 注文アイテム削除時
4. `OrderConfirmed` - 注文確定時
5. `OrderCancelled` - 注文キャンセル時

**理由**:
- 注文のライフサイクルをイベントとして表現
- 参照実装のイベント数 (7個) と比較して適切な粒度
- Event Sourcingの基本的なパターンを示すのに十分

**検討した代替案**:
- OrderItemQuantityChanged, OrderItemPriceChanged などの細かいイベント → 却下 (Skeletonとして複雑すぎる)
- OrderShipped, OrderDelivered などの配送イベント → 将来の拡張として保留

### 3. コマンドプロセッサの設計

**決定**: `OrderCommandProcessor` は、以下のコマンドハンドラーを提供:

- `CreateOrder(userAccountId UserAccountId) Result[OrderEvent]`
- `AddOrderItem(orderId *OrderId, productId ProductId, quantity Quantity, price Price, executorId UserAccountId) Result[OrderEvent]`
- `RemoveOrderItem(orderId *OrderId, orderItemId OrderItemId, executorId UserAccountId) Result[OrderEvent]`
- `ConfirmOrder(orderId *OrderId, executorId UserAccountId) Result[OrderEvent]`
- `CancelOrder(orderId *OrderId, executorId UserAccountId) Result[OrderEvent]`

**理由**:
- 参照実装の`GroupChatCommandProcessor`と同じパターンに従う
- ドメインロジックをコマンドプロセッサに委譲し、集約ルートはドメインルールのみを実装
- `mo.Result`を使用してエラーハンドリングを明示的に行う

### 4. リポジトリの設計

**決定**: `OrderRepository` インターフェースと `OrderRepositoryImpl` 実装を提供:

- `Store(event OrderEvent, snapshot *Order) Option[error]`
- `FindById(id *OrderId) Result[Option[Order]]`
- イベントとスナップショットのコンバーター・シリアライザーを実装

**理由**:
- 参照実装と同じインターフェースに従う
- イベントストアアダプターとの統合を維持
- スナップショット戦略 (WithRetention) をサポート

### 5. GraphQL スキーマの設計

**決定**: コマンドサイドとクエリサイドで別々のGraphQLスキーマを提供:

**コマンドサイド (Mutation)**:
- `createOrder(input: CreateOrderInput!): OrderResult!`
- `addOrderItem(input: AddOrderItemInput!): OrderResult!`
- `removeOrderItem(input: RemoveOrderItemInput!): OrderResult!`
- `confirmOrder(input: ConfirmOrderInput!): OrderResult!`
- `cancelOrder(input: CancelOrderInput!): OrderResult!`

**クエリサイド (Query)**:
- `getOrder(orderId: String!): Order`
- `getOrders(userAccountId: String!): [Order!]!`
- `getOrderItem(orderId: String!, orderItemId: String!): OrderItem`

**理由**:
- CQRS パターンに従い、コマンドとクエリを明確に分離
- 参照実装と同じGraphQLの使用方法を示す

### 6. Read Model Updater の設計

**決定**: `OrderDao` インターフェースと `OrderDaoImpl` 実装を提供:

- `InsertOrder(orderId *OrderId, userAccountId *UserAccountId, createdAt time.Time) error`
- `UpdateOrderStatus(orderId *OrderId, status string, updatedAt time.Time) error`
- `InsertOrderItem(orderId *OrderId, orderItem *OrderItem, createdAt time.Time) error`
- `DeleteOrderItem(orderId *OrderId, orderItemId *OrderItemId) error`

**理由**:
- イベントからRead Modelを更新するパターンを示す
- 参照実装の`GroupChatDao`と同じパターンに従う
- RDS (PostgreSQL/MySQL) を想定した設計

## リスク / トレードオフ

### リスク

1. **複雑性**: 注文ドメインは実際のビジネスでは非常に複雑になる可能性がある
   - **緩和策**: Skeletonとして最小限の機能に絞る

2. **参照実装との乖離**: 参照実装が更新された場合、このSkeletonとの整合性が失われる可能性がある
   - **緩和策**: バージョン管理を明確にし、定期的な同期を実施

3. **誤解の可能性**: Skeletonコードが実際のプロダクションコードとして使用される可能性がある
   - **緩和策**: ドキュメントで明確に「テンプレート」であることを示す

### トレードオフ

1. **完全性 vs シンプルさ**:
   - 選択: シンプルさを優先し、基本的な機能のみを実装
   - トレードオフ: 一部の実用的な機能 (在庫管理、支払い処理など) は含まれない

2. **再利用性 vs 具体性**:
   - 選択: 注文ドメインという具体的な例を提供
   - トレードオフ: 他のドメインに直接適用できない部分もある

## マイグレーション計画

このSkeletonは新規追加のため、マイグレーション計画は不要。

ただし、以下の点を考慮:

1. **参照実装との共存**: `pkg/` ディレクトリ内に配置し、参照実装と同じ構造を維持
2. **テストの実行**: 既存のテストスイートに影響を与えないように、個別のテストファイルを作成
3. **ドキュメント**: README.md に Skeletonコードの説明を追加

### ロールバック

新規追加のため、ロールバックは単純に追加されたファイルを削除するだけで対応可能。

## 未解決の質問 (Open Questions)

1. **注文ステータスの扱い**: 注文ステータス (Pending, Confirmed, Cancelled など) を値オブジェクトとして実装するか、集約内のフラグとして扱うか?
   - **暫定的な決定**: 集約内のフラグ (`confirmed`, `cancelled`) として実装

2. **価格の計算**: 注文の合計金額を集約内で計算するか、クエリサイドで計算するか?
   - **暫定的な決定**: 集約内では計算せず、クエリサイドで計算

3. **同時実行制御**: 楽観的ロックの実装方法について
   - **暫定的な決定**: イベントストアアダプターのバージョン管理機能を使用

4. **テストデータ**: Skeletonコードにテストデータを含めるか?
   - **暫定的な決定**: 基本的なテストケースのみを含め、テストデータは最小限にする
