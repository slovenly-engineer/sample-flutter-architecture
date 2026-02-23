# sample-flutter-architecture

Feature-first + Layered Architecture のFlutterアプリサンプルです。

## アーキテクチャ

- **横の分割**: Feature-first（機能単位）
- **縦の分割**: Layered Architecture（Presentation / Domain / Data）
- **状態管理**: Riverpod + Hooks
- **依存の流れ**: Presentation → Domain → Data

## フォルダ構造

```
lib/
  ├── main.dart
  ├── app.dart
  ├── core/           # 共通基盤
  │   ├── models/     # 共通モデル (ApiError, Result等)
  │   ├── network/    # Dio設定, 共通API
  │   ├── storage/    # ObjectBox設定
  │   ├── ui/         # テーマ, 共通コンポーネント
  │   ├── utils/      # ユーティリティ
  │   └── providers/  # 共通Provider (Router等)
  └── features/
      └── {feature}/
          ├── models/        # Feature固有モデル (freezed)
          ├── data/          # API, Repository
          ├── domain/        # UseCase, Domain Provider
          └── presentation/  # Pages, Widgets, UI Provider
```

## セットアップ

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

## テスト

```bash
flutter test
```

## 使用パッケージ

| カテゴリ | パッケージ |
|---|---|
| 状態管理 | hooks_riverpod, flutter_hooks |
| モデル生成 | freezed, json_serializable |
| API通信 | dio, retrofit |
| ルーティング | go_router |
| テスト | mocktail |
