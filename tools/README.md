# Tools ディレクトリ

このディレクトリには、開発環境のセットアップとテストのためのツールとスクリプトが含まれています。

## ディレクトリ構成

```
tools/
├── dynamodb-setup/       # DynamoDBテーブル作成スクリプト
│   └── create-tables.sh  # ジャーナル・スナップショットテーブル作成
├── migrate/              # データベースマイグレーション
│   └── migrations/       # PostgreSQLマイグレーションファイル
│       ├── 1_create_orders.up.sql
│       └── 2_create_order_items.up.sql
└── scripts/              # ユーティリティスクリプト
    └── e2e-test.sh       # E2Eテストスクリプト
```

## 使用方法

### 環境の起動

全サービスを起動（ビルド含む）:

```bash
make docker-compose-up
```

データベースのみ起動:

```bash
make docker-compose-up-db
```

### マイグレーション

PostgreSQLマイグレーションを実行:

```bash
make migrate
```

### E2Eテスト

全サービスの起動後にE2Eテストを実行:

```bash
make verify-order
```

### サービス管理

サービスの状態確認:

```bash
make docker-compose-ps
```

ログの確認:

```bash
make docker-compose-logs
```

全サービスの停止とクリーンアップ:

```bash
make docker-compose-down
```

## サービスポート

- **Write API**: http://localhost:8080
- **Read API**: http://localhost:8081
- **Read Model Updater**: http://localhost:8082（内部サービス）
- **PostgreSQL**: localhost:5432
- **pgAdmin**: http://localhost:5050
  - Email: admin@example.com
  - Password: admin
- **LocalStack**: http://localhost:4566
- **DynamoDB Admin**: http://localhost:8001

## データベース接続情報

### PostgreSQL

- Host: localhost
- Port: 5432
- Database: cqrs_es_spec_kit
- User: postgres
- Password: postgres

### DynamoDB (LocalStack)

- Endpoint: http://localhost:4566
- Region: ap-northeast-1
- Access Key ID: x
- Secret Access Key: x

テーブル:
- `journal` - イベントジャーナル
- `snapshot` - 集約スナップショット

## トラブルシューティング

### ポートが既に使用されている

他のサービスでポートが使用されている場合は、`docker-compose.yml`のポートマッピングを変更してください。

### マイグレーションが失敗する

PostgreSQLの起動を待ってから再度実行:

```bash
docker-compose up -d postgres
sleep 10
make migrate
```

### DynamoDBテーブルが作成されない

LocalStack起動後、手動でセットアップスクリプトを実行:

```bash
docker-compose up -d localstack
sleep 5
docker-compose up dynamodb-setup
```
