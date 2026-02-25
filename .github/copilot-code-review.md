すべてのコードレビューコメントは日本語で記述してください。

## プロジェクト概要

Flutter アプリケーション。Feature-First + Layered Architecture（Presentation → Domain → Data）を採用。

## レビュー観点

- **アーキテクチャ**: Feature-First + Layered Architecture に準拠しているか
- **状態管理**: Riverpod + Hooks パターンが正しく使われているか
- **エラーハンドリング**: `Result<T>` パターンで型安全にエラー処理されているか
- **モデル**: Freezed による不変データモデルが適切に定義されているか
- **API 層**: Retrofit + Dio のパターンに従っているか
- **テスト**: テストカバレッジ 90% 以上を維持できるか
- **コーディング規約**: flutter_lints、`prefer_const_constructors`、`prefer_single_quotes` に準拠しているか
