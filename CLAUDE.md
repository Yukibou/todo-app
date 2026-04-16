# CLAUDE.md

## プロジェクト概要

Rails 8.1 製の Todo 管理アプリ。Devise による認証付き。ユーザーごとに Todo を管理できる。

## 技術スタック

- **Ruby on Rails** 8.1
- **PostgreSQL**
- **Devise** — 認証
- **Hotwire** (Turbo + Stimulus) — SPA ライクな UI
- **Tailwind CSS** — スタイリング
- **Solid Cache / Queue / Cable** — DB バックエンドのキャッシュ・ジョブ・Action Cable

## 主要モデル

| モデル | 概要 |
|--------|------|
| `User` | Devise で管理。メール・パスワード認証 |
| `Todo` | `title`, `description`, `priority`, `due_date`, `done`, `user_id` |

- `Todo` は `User` に belongs_to（外部キー制約あり）
- `current_user.todos` でスコープを絞る設計

## テスト

- **RSpec** + **FactoryBot** + **Faker**
- `spec/models/` — モデルスペック
- `spec/requests/` — リクエストスペック（認証・認可含む）

```bash
bundle exec rspec          # 全テスト実行
bundle exec rspec spec/models/todo_spec.rb  # 特定ファイル
```

## よく使うコマンド

```bash
bin/dev                        # 開発サーバー起動（Procfile.dev 使用）
bin/rails db:migrate           # マイグレーション実行
bin/rails db:seed              # シードデータ投入
bundle exec rubocop -A         # RuboCop 自動修正
bundle exec brakeman           # セキュリティ静的解析
```

## デプロイ

- **Render** へデプロイ（`render.yaml` あり）
- DB 接続は `DATABASE_URL` 環境変数で管理
- `Dockerfile` でコンテナ化

## 注意事項

- Todo の取得は必ず `current_user.todos` 経由で行う（他ユーザーのデータ漏洩防止）
- マイグレーション作成時は `bin/rails db:migrate` 後に `db/schema.rb` をコミットに含める
