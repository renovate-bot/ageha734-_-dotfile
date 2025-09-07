# Git ワークフロー・プルリクエスト規約プロンプト

## 基本原則

全ての作業には、`.cursor/rules/guidelines.mdc`を参照し、完全に従ってください。

## Git ワークフロー

### 1. ブランチ戦略

#### ブランチ命名規則

```text
feature/ISSUE-123-add-user-authentication
bugfix/ISSUE-456-fix-memory-leak
hotfix/ISSUE-789-security-patch
docs/update-api-documentation
refactor/optimize-database-queries
```

#### ブランチの種類

- `feature/`: 新機能開発
- `bugfix/`: バグ修正
- `hotfix/`: 緊急修正
- `docs/`: ドキュメント更新
- `refactor/`: リファクタリング
- `chore/`: 雑務（依存関係更新等）

### 2. コミットメッセージ規約

#### フォーマット（Conventional Commits準拠）

```text
<type>: <subject>

[optional body]
```

#### Type の種類

- `feat`: 新機能
- `fix`: バグ修正
- `docs`: ドキュメント変更
- `refactor`: リファクタリング
- `chore`: ビルドプロセス・補助ツール変更

#### 例

```text
feat(auth): add OAuth2 integration

- Implement Google OAuth2 provider
- Add user profile synchronization
- Update authentication middleware
```

### 3. プルリクエスト作成手順

#### 1. 事前チェック

```bash
# Linter実行
dprint fmt
```

#### 2. PR作成（gh CLI使用）

```bash
gh pr create \
  --title "feat(auth): add OAuth2 integration" \
  --body-file .github/templates/pull_request_template.md \
  --assignee @me \
  --label "enhancement"
```

#### 3. PR説明テンプレート

```markdown
## Summary

## Changes

## Checklist
```

### 4. レビュープロセス

#### レビュアーの責任

- コードの品質・可読性確認
- セキュリティ脆弱性チェック
- パフォーマンス影響評価
- テストカバレッジ確認

#### 作成者の責任

- レビューコメントへの迅速な対応
- CI/CDパイプラインの成功確認
- コンフリクト解決
- 適切なドキュメント更新

### 5. マージ戦略

#### Squash and Merge（推奨）

- 機能単位での履歴管理
- クリーンな履歴維持
- リバート時の簡便性

#### 使用場面

- `feature/` ブランチ → `master`
- `bugfix/` ブランチ → `master`
- `docs/` ブランチ → `master`

### 6. リリース管理

#### セマンティックバージョニング

- `MAJOR.MINOR.PATCH`
- Breaking changes → MAJOR
- New features → MINOR
- Bug fixes → PATCH

#### リリースノート自動生成

```bash
changelog
```

### 7. 緊急対応フロー

#### Hotfix手順

1. `master`から`hotfix/`ブランチ作成
2. 修正実装・テスト
3. 直接`master`にマージ
4. タグ作成・リリース
5. `develop`ブランチにもマージ（存在する場合）

### 8. 自動化設定

#### GitHub Actions

- PR作成時の自動テスト実行
- コードカバレッジレポート生成
- セキュリティスキャン実行
- 依存関係脆弱性チェック
