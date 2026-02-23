# sample-flutter-architecture

Feature-first + Layered Architecture のFlutterアプリサンプルです。
Todoアプリを題材に、スケーラブルなアーキテクチャパターンと包括的なテスト戦略を実装しています。

## 技術スタック

- **Flutter**: 3.27.4
- **Dart**: >=3.2.0 <4.0.0
- **状態管理**: Riverpod + Hooks
- **モデル生成**: Freezed + json_serializable
- **API通信**: Dio
- **ローカルDB**: ObjectBox
- **ルーティング**: go_router
- **テスト**: mocktail, alchemist（ゴールデンテスト）

## アーキテクチャ

- **横の分割**: Feature-first（機能単位でモジュール化）
- **縦の分割**: Layered Architecture（Presentation / Domain / Data）
- **状態管理**: Riverpod（`@riverpod` アノテーションによるコード生成）+ Hooks
- **依存の流れ**: Presentation → Domain → Data

### 主要パターン

| パターン | 概要 |
|---|---|
| **Result\<T\>** | `sealed class` によるtype-safeなエラーハンドリング（`Success` / `Failure`） |
| **Freezed** | 全ドメインモデルでイミュータブル化・パターンマッチング・JSON変換を実現 |
| **Repository** | インターフェースと実装を分離し、テスタビリティを確保 |
| **UseCase** | ビジネスロジックをPresentation層から分離 |
| **Provider** | Riverpod DIによる依存性注入とUI状態管理 |

## フォルダ構造

```
lib/
├── main.dart
├── app.dart
├── core/                              # 共通基盤
│   ├── models/                        # 共通モデル (Result<T>, ApiError)
│   ├── app_settings/                  # アプリ設定管理
│   ├── auth/                          # 認証（AuthGuard, AuthService）
│   ├── initialization/                # アプリ初期化パイプライン
│   ├── infrastructure/
│   │   ├── navigation/                # go_routerナビゲーション
│   │   ├── network/                   # Dio HTTPクライアント
│   │   ├── storage/                   # ObjectBoxローカルDB
│   │   └── ui/dialogs/               # ダイアログサービス
│   ├── pages/                         # 共通ページ (Splash, NotFound)
│   ├── ui/
│   │   ├── components/                # 共通UIコンポーネント
│   │   └── theme/                     # テーマ (Colors, Typography, Spacing)
│   └── utils/                         # ユーティリティ
└── features/
    └── todo/                          # Todoフィーチャー
        ├── models/                    # Todoモデル (freezed)
        ├── data/
        │   ├── entities/              # DBエンティティ
        │   └── repositories/          # Repository実装
        ├── domain/
        │   ├── repositories/          # Repositoryインターフェース
        │   ├── usecases/              # ビジネスロジック
        │   └── providers/             # DI Provider
        ├── presentation/
        │   ├── providers/             # UI状態管理 (Notifier)
        │   ├── pages/                 # 画面 (List, Detail)
        │   └── widgets/               # UIコンポーネント
        └── navigation/                # ルート定義
```

## セットアップ

```bash
# 依存パッケージの取得
flutter pub get

# コード生成（freezed, riverpod, json_serializable, objectbox）
dart run build_runner build --delete-conflicting-outputs
```

## 開発コマンド

```bash
# アプリ実行
flutter run

# 静的解析
flutter analyze --fatal-infos

# フォーマット
dart format lib/ test/

# 自動修正チェック・適用
dart fix --dry-run
dart fix --apply
```

## テスト

```bash
# 全テスト実行
flutter test

# カバレッジ付き
flutter test --coverage

# CI用（ゴールデンテスト対応）
flutter test --dart-define=CI=true

# ゴールデンファイル更新
flutter test --update-goldens

# カバレッジ閾値チェック（90%以上必須、95%未満で警告）
bash scripts/check_coverage.sh coverage/lcov.info
```

### テスト戦略

| 種別 | 内容 | ツール |
|---|---|---|
| **ユニットテスト** | UseCase, Model, Util, Repository | mocktail |
| **Widget/Providerテスト** | UI状態・振る舞い検証 | flutter_test, Riverpod overrides |
| **ゴールデンテスト** | ビジュアルリグレッション | alchemist |

テストヘルパーは `test/helpers/` に配置:
- `createTestApp(widget, overrides: [])` - 基本テストラッパー
- `createTestAppWithScaffold(widget, overrides: [])` - Scaffold付きラッパー

ゴールデンテストはCI用（`goldens/ci/`）とローカル用（`goldens/`）で分離管理されています。

## CI/CD

GitHub Actionsにより以下を自動検証:

1. 静的解析（`flutter analyze --fatal-infos`）
2. フォーマットチェック（`dart format --set-exit-if-changed`）
3. Dart fixチェック
4. 生成ファイルの整合性検証
5. テスト実行（ゴールデンテスト含む）
6. カバレッジ閾値チェック（90%以上必須）

## 使用パッケージ

| カテゴリ | パッケージ |
|---|---|
| 状態管理 | hooks_riverpod, flutter_hooks, riverpod_annotation |
| モデル生成 | freezed, freezed_annotation, json_serializable, json_annotation |
| API通信 | dio |
| ローカルDB | objectbox, objectbox_flutter_libs |
| ルーティング | go_router |
| ストレージ | shared_preferences |
| コード生成 | build_runner, riverpod_generator, objectbox_generator |
| テスト | mocktail, alchemist |
| リント | flutter_lints |

## 新機能の追加手順

1. `lib/features/{feature}/` にレイヤー構造のディレクトリを作成
2. `data/entities/` にDBエンティティを定義
3. `domain/repositories/` にRepositoryインターフェースを定義
4. `data/repositories/` にRepository実装を作成
5. `domain/usecases/` にUseCaseを実装
6. `domain/providers/` と `presentation/providers/` にRiverpod Providerを追加
7. `presentation/pages/` と `presentation/widgets/` にUIを構築
8. `navigation/` にルート定義を追加
9. `test/` に対応するテストを作成（カバレッジ90%以上）

## コーディング規約

- **コミット**: Conventional Commits形式（`feat:`, `fix:`, `test:`, `ci:`）
- **リント**: flutter_lints（`prefer_const_constructors`, `avoid_print`, `prefer_single_quotes`）
- **ウィジェット**: `HookConsumerWidget` を継承
- **テーマ**: `core/ui/theme/` で一元管理（AppTheme, AppColors, AppTypography, AppSpacing）
