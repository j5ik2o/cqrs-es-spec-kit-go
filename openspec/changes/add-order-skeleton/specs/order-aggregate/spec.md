# 注文集約 (Order Aggregate) 仕様

## ADDED Requirements

### Requirement: 注文集約の定義

システムは、CQRS/Event Sourcingアーキテクチャに基づく注文集約 (Order Aggregate) を提供しなければならない (SHALL)。注文集約は、注文のライフサイクル全体を管理し、ドメインイベントを発行することでイベントソーシングを実現する (SHALL)。

#### Scenario: 注文集約の基本構造

- **WHEN** システムが注文集約を初期化する
- **THEN** 以下の要素を持つ集約が作成される:
  - 集約ID (OrderId)
  - 注文アイテムのコレクション (OrderItems)
  - 注文の所有者 (UserAccountId)
  - 確定フラグ (confirmed)
  - キャンセルフラグ (cancelled)
  - シーケンス番号 (seqNr)
  - バージョン (version)

### Requirement: 注文の作成

システムは、ユーザーアカウントIDを指定して新しい注文を作成できなければならない (SHALL)。注文作成時には、OrderCreatedイベントが発行される (SHALL)。

#### Scenario: 正常な注文作成

- **WHEN** ユーザーアカウントIDを指定して注文を作成する
- **THEN** 新しい注文集約が作成される
- **AND** OrderCreatedイベントが発行される
- **AND** 注文は未確定 (confirmed=false) 状態である
- **AND** 注文はキャンセルされていない (cancelled=false) 状態である

### Requirement: 注文アイテムの追加

システムは、既存の注文に新しい注文アイテムを追加できなければならない (SHALL)。注文アイテム追加時には、OrderItemAddedイベントが発行される (SHALL)。

#### Scenario: 正常な注文アイテムの追加

- **WHEN** 注文ID、商品ID、数量、価格、実行者IDを指定して注文アイテムを追加する
- **THEN** 注文に新しい注文アイテムが追加される
- **AND** OrderItemAddedイベントが発行される
- **AND** 注文アイテムには一意のOrderItemIdが割り当てられる

#### Scenario: 確定済み注文への注文アイテム追加の拒否

- **WHEN** 確定済みの注文に注文アイテムを追加しようとする
- **THEN** AlreadyConfirmedErrorが返される
- **AND** 注文アイテムは追加されない
- **AND** イベントは発行されない

#### Scenario: キャンセル済み注文への注文アイテム追加の拒否

- **WHEN** キャンセル済みの注文に注文アイテムを追加しようとする
- **THEN** AlreadyCancelledErrorが返される
- **AND** 注文アイテムは追加されない
- **AND** イベントは発行されない

#### Scenario: 実行者権限の検証

- **WHEN** 注文の所有者以外のユーザーが注文アイテムを追加しようとする
- **THEN** NotOwnerErrorが返される
- **AND** 注文アイテムは追加されない
- **AND** イベントは発行されない

### Requirement: 注文アイテムの削除

システムは、既存の注文から注文アイテムを削除できなければならない (SHALL)。注文アイテム削除時には、OrderItemRemovedイベントが発行される (SHALL)。

#### Scenario: 正常な注文アイテムの削除

- **WHEN** 注文ID、注文アイテムID、実行者IDを指定して注文アイテムを削除する
- **THEN** 注文から指定された注文アイテムが削除される
- **AND** OrderItemRemovedイベントが発行される

#### Scenario: 存在しない注文アイテムの削除の拒否

- **WHEN** 存在しない注文アイテムIDを指定して削除しようとする
- **THEN** NotFoundErrorが返される
- **AND** 注文アイテムは削除されない
- **AND** イベントは発行されない

#### Scenario: 確定済み注文からの注文アイテム削除の拒否

- **WHEN** 確定済みの注文から注文アイテムを削除しようとする
- **THEN** AlreadyConfirmedErrorが返される
- **AND** 注文アイテムは削除されない
- **AND** イベントは発行されない

#### Scenario: キャンセル済み注文からの注文アイテム削除の拒否

- **WHEN** キャンセル済みの注文から注文アイテムを削除しようとする
- **THEN** AlreadyCancelledErrorが返される
- **AND** 注文アイテムは削除されない
- **AND** イベントは発行されない

#### Scenario: 実行者権限の検証 (削除)

- **WHEN** 注文の所有者以外のユーザーが注文アイテムを削除しようとする
- **THEN** NotOwnerErrorが返される
- **AND** 注文アイテムは削除されない
- **AND** イベントは発行されない

### Requirement: 注文の確定

システムは、注文を確定できなければならない (SHALL)。注文確定時には、OrderConfirmedイベントが発行される (SHALL)。

#### Scenario: 正常な注文確定

- **WHEN** 注文ID、実行者IDを指定して注文を確定する
- **THEN** 注文が確定状態 (confirmed=true) になる
- **AND** OrderConfirmedイベントが発行される

#### Scenario: 空の注文の確定の拒否

- **WHEN** 注文アイテムが1つも含まれていない注文を確定しようとする
- **THEN** EmptyOrderErrorが返される
- **AND** 注文は確定されない
- **AND** イベントは発行されない

#### Scenario: 既に確定済みの注文の確定の拒否

- **WHEN** 既に確定済みの注文を再度確定しようとする
- **THEN** AlreadyConfirmedErrorが返される
- **AND** イベントは発行されない

#### Scenario: キャンセル済み注文の確定の拒否

- **WHEN** キャンセル済みの注文を確定しようとする
- **THEN** AlreadyCancelledErrorが返される
- **AND** 注文は確定されない
- **AND** イベントは発行されない

#### Scenario: 実行者権限の検証 (確定)

- **WHEN** 注文の所有者以外のユーザーが注文を確定しようとする
- **THEN** NotOwnerErrorが返される
- **AND** 注文は確定されない
- **AND** イベントは発行されない

### Requirement: 注文のキャンセル

システムは、注文をキャンセルできなければならない (SHALL)。注文キャンセル時には、OrderCancelledイベントが発行される (SHALL)。

#### Scenario: 正常な注文キャンセル

- **WHEN** 注文ID、実行者IDを指定して注文をキャンセルする
- **THEN** 注文がキャンセル状態 (cancelled=true) になる
- **AND** OrderCancelledイベントが発行される

#### Scenario: 既にキャンセル済みの注文のキャンセルの拒否

- **WHEN** 既にキャンセル済みの注文を再度キャンセルしようとする
- **THEN** AlreadyCancelledErrorが返される
- **AND** イベントは発行されない

#### Scenario: 実行者権限の検証 (キャンセル)

- **WHEN** 注文の所有者以外のユーザーが注文をキャンセルしようとする
- **THEN** NotOwnerErrorが返される
- **AND** 注文はキャンセルされない
- **AND** イベントは発行されない

### Requirement: イベントソーシング

システムは、イベントソーシングパターンに従い、注文集約の状態をイベントから復元できなければならない (SHALL)。

#### Scenario: イベントからの状態復元

- **WHEN** OrderCreated, OrderItemAdded, OrderConfirmedイベントのシーケンスが与えられる
- **THEN** イベントを順次適用することで、注文集約の現在の状態が復元される
- **AND** 復元された注文集約は、最新のイベントが適用された状態と一致する

#### Scenario: スナップショットからの復元

- **WHEN** スナップショットと、それ以降のイベントが与えられる
- **THEN** スナップショットをベースとし、以降のイベントを適用することで、注文集約の現在の状態が復元される
- **AND** 復元された注文集約は、すべてのイベントを最初から適用した場合と同じ状態である

### Requirement: リポジトリパターン

システムは、リポジトリパターンを使用して注文集約の永続化と取得を行わなければならない (SHALL)。

#### Scenario: 注文の保存

- **WHEN** 注文集約とイベントをリポジトリに保存する
- **THEN** イベントがイベントストアに永続化される
- **AND** 必要に応じてスナップショットが保存される

#### Scenario: 注文の取得

- **WHEN** 注文IDを指定して注文を取得する
- **THEN** 最新のスナップショット (存在する場合) とそれ以降のイベントが取得される
- **AND** イベントを適用することで、注文集約の現在の状態が復元される
- **AND** 復元された注文集約が返される

#### Scenario: 存在しない注文の取得

- **WHEN** 存在しない注文IDを指定して注文を取得する
- **THEN** Noneが返される

### Requirement: コマンドプロセッサ

システムは、コマンドプロセッサを使用して注文に対する操作を処理しなければならない (SHALL)。コマンドプロセッサは、ドメインロジックを実行し、リポジトリを通じて永続化を行う (SHALL)。

#### Scenario: CreateOrderコマンドの処理

- **WHEN** CreateOrderコマンドが発行される
- **THEN** 新しい注文集約が作成される
- **AND** OrderCreatedイベントが発行される
- **AND** イベントと注文集約がリポジトリに保存される
- **AND** OrderCreatedイベントが返される

#### Scenario: AddOrderItemコマンドの処理

- **WHEN** AddOrderItemコマンドが発行される
- **THEN** 注文IDで注文集約が取得される
- **AND** 注文アイテムが追加される
- **AND** OrderItemAddedイベントが発行される
- **AND** イベントと更新された注文集約がリポジトリに保存される
- **AND** OrderItemAddedイベントが返される

#### Scenario: ConfirmOrderコマンドの処理

- **WHEN** ConfirmOrderコマンドが発行される
- **THEN** 注文IDで注文集約が取得される
- **AND** 注文が確定される
- **AND** OrderConfirmedイベントが発行される
- **AND** イベントと更新された注文集約がリポジトリに保存される
- **AND** OrderConfirmedイベントが返される

#### Scenario: CancelOrderコマンドの処理

- **WHEN** CancelOrderコマンドが発行される
- **THEN** 注文IDで注文集約が取得される
- **AND** 注文がキャンセルされる
- **AND** OrderCancelledイベントが発行される
- **AND** イベントと更新された注文集約がリポジトリに保存される
- **AND** OrderCancelledイベントが返される

#### Scenario: 存在しない注文に対するコマンド処理のエラー

- **WHEN** 存在しない注文IDを指定してコマンドを発行する
- **THEN** NotFoundErrorが返される
- **AND** 注文は変更されない
- **AND** イベントは発行されない

#### Scenario: ドメインロジックエラーの処理

- **WHEN** ドメインロジックが失敗する条件でコマンドを発行する
- **THEN** DomainLogicErrorが返される
- **AND** 注文は変更されない
- **AND** イベントは発行されない
- **AND** リポジトリへの保存は行われない

### Requirement: GraphQL インターフェース (コマンドサイド)

システムは、GraphQLインターフェースを通じて注文に対する操作を受け付けなければならない (SHALL)。

#### Scenario: createOrder ミューテーション

- **WHEN** createOrder ミューテーションが実行される
- **THEN** CreateOrderコマンドが発行される
- **AND** 新しい注文が作成される
- **AND** OrderResultが返される

#### Scenario: addOrderItem ミューテーション

- **WHEN** addOrderItem ミューテーションが実行される
- **THEN** AddOrderItemコマンドが発行される
- **AND** 注文アイテムが追加される
- **AND** OrderResultが返される

#### Scenario: confirmOrder ミューテーション

- **WHEN** confirmOrder ミューテーションが実行される
- **THEN** ConfirmOrderコマンドが発行される
- **AND** 注文が確定される
- **AND** OrderResultが返される

#### Scenario: cancelOrder ミューテーション

- **WHEN** cancelOrder ミューテーションが実行される
- **THEN** CancelOrderコマンドが発行される
- **AND** 注文がキャンセルされる
- **AND** OrderResultが返される

#### Scenario: GraphQLエラーハンドリング

- **WHEN** コマンド処理中にエラーが発生する
- **THEN** 適切なGraphQLエラーが返される
- **AND** エラーメッセージにはエラーの種類と詳細が含まれる

### Requirement: GraphQL インターフェース (クエリサイド)

システムは、GraphQLインターフェースを通じて注文情報を取得できなければならない (SHALL)。

#### Scenario: getOrder クエリ

- **WHEN** getOrder クエリが実行される
- **THEN** 指定された注文IDの注文情報が返される
- **AND** 注文に含まれる注文アイテムの情報も含まれる

#### Scenario: getOrders クエリ

- **WHEN** getOrders クエリが実行される
- **THEN** 指定されたユーザーアカウントIDの注文一覧が返される
- **AND** 各注文に含まれる基本情報が含まれる

#### Scenario: getOrderItem クエリ

- **WHEN** getOrderItem クエリが実行される
- **THEN** 指定された注文アイテムの情報が返される

#### Scenario: 存在しない注文のクエリ

- **WHEN** 存在しない注文IDでクエリを実行する
- **THEN** nullが返される

### Requirement: Read Model Updater

システムは、ドメインイベントを購読し、Read Modelを更新しなければならない (SHALL)。

#### Scenario: OrderCreatedイベントの処理

- **WHEN** OrderCreatedイベントが発行される
- **THEN** Read Modelに新しい注文レコードが挿入される
- **AND** 注文の初期状態 (未確定、未キャンセル) が記録される

#### Scenario: OrderItemAddedイベントの処理

- **WHEN** OrderItemAddedイベントが発行される
- **THEN** Read Modelに新しい注文アイテムレコードが挿入される
- **AND** 注文アイテムの商品ID、数量、価格が記録される

#### Scenario: OrderItemRemovedイベントの処理

- **WHEN** OrderItemRemovedイベントが発行される
- **THEN** Read Modelから該当する注文アイテムレコードが削除される

#### Scenario: OrderConfirmedイベントの処理

- **WHEN** OrderConfirmedイベントが発行される
- **THEN** Read Modelの注文レコードのステータスが「確定」に更新される

#### Scenario: OrderCancelledイベントの処理

- **WHEN** OrderCancelledイベントが発行される
- **THEN** Read Modelの注文レコードのステータスが「キャンセル」に更新される

### Requirement: 値オブジェクト

システムは、ドメインモデルの整合性を保証するため、値オブジェクトを使用しなければならない (SHALL)。

#### Scenario: OrderIdの生成と検証

- **WHEN** 新しいOrderIdが生成される
- **THEN** ULIDベースの一意なIDが割り当てられる
- **AND** IDは文字列表現に変換可能である

#### Scenario: Quantityの検証

- **WHEN** 数量を指定して注文アイテムを作成する
- **THEN** 数量が正の整数でなければならない
- **AND** 0以下の数量は拒否される

#### Scenario: Priceの検証

- **WHEN** 価格を指定して注文アイテムを作成する
- **THEN** 価格が非負の整数でなければならない
- **AND** 負の価格は拒否される

### Requirement: 楽観的ロック

システムは、楽観的ロックを使用して同時実行制御を行わなければならない (SHALL)。

#### Scenario: バージョン競合の検出

- **WHEN** 2つの異なるプロセスが同じ注文を同時に更新しようとする
- **THEN** 後から保存しようとしたプロセスはバージョン競合エラーを受け取る
- **AND** 最初のプロセスの変更のみが永続化される

#### Scenario: バージョンの自動インクリメント

- **WHEN** 注文にイベントが適用される
- **THEN** 注文のバージョンが自動的にインクリメントされる
- **AND** 次の更新時には新しいバージョン番号が使用される
