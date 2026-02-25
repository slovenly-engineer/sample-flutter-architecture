# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Flutter Version Management (FVM)

This project uses [FVM](https://fvm.app/) to manage the Flutter SDK version.
The required version is defined in `.fvmrc`.

```bash
# Install FVM (if not already installed)
dart pub global activate fvm

# Install the project's Flutter version
fvm install

# Use FVM-managed Flutter (prefix commands with `fvm`)
fvm flutter pub get
fvm flutter run
fvm flutter test
```

Alternatively, if FVM is configured as the default, `flutter` commands work directly.

## Build & Development Commands

```bash
# Setup
fvm flutter pub get
dart run build_runner build --delete-conflicting-outputs

# Run
fvm flutter run

# Tests
flutter test                                    # All tests
flutter test --coverage                         # With coverage
flutter test --dart-define=CI=true              # CI mode (goldens)
flutter test --update-goldens                   # Update golden files

# Linting
flutter analyze --fatal-infos
dart format lib/ test/
dart fix --dry-run                              # Check for fixes
dart fix --apply                                # Apply fixes

# Coverage check (requires 90%+, warns if below 95%)
bash scripts/check_coverage.sh coverage/lcov.info
```

## Architecture

**Pattern**: Feature-First + Layered Architecture (Presentation → Domain → Data)

詳細な設計書は [`docs/architecture.md`](docs/architecture.md) を参照。

### フォルダ構成

```
lib/
├── core/                          # 共有インフラストラクチャ
│   ├── infrastructure/
│   │   ├── network/              # HTTP通信（抽象 + Dio具体実装）
│   │   ├── storage/              # ローカルDB（抽象 + ObjectBox具体実装）
│   │   ├── navigation/           # 画面遷移（抽象 + go_router具体実装）
│   │   └── ui/dialogs/           # ダイアログ/スナックバー（抽象 + Material具体実装）
│   ├── auth/                     # 認証（横断的関心事）
│   ├── app_settings/             # アプリ設定（横断的関心事）
│   ├── initialization/           # アプリ起動処理
│   ├── models/                   # 共通モデル（Result<T>, ApiError）
│   ├── ui/
│   │   ├── theme/                # カラー、フォント、スペーシング
│   │   ├── components/           # アプリ固有デザイン適用Widget
│   │   ├── layouts/              # レスポンシブ対応レイアウト
│   │   └── blocks/               # 複合コンポーネント（Header等）
│   ├── pages/                    # Feature非依存の画面（スプラッシュ、404等）
│   ├── utils/
│   └── providers/
│
└── features/
    └── {feature}/                 # Feature modules
        ├── models/                # Feature内共有モデル（freezed）
        ├── data/
        │   ├── entities/         # DB Entity定義
        │   └── repositories/     # Repository具体実装
        ├── domain/
        │   ├── repositories/     # Repository抽象（interface）
        │   ├── usecases/         # 純粋なビジネスロジック
        │   └── providers/        # Domain層のProvider配線
        ├── navigation/
        │   └── {name}_routes.dart
        └── presentation/
            ├── pages/             # 画面Widget
            ├── widgets/           # 再利用可能UIコンポーネント
            ├── providers/         # UI状態（Notifier）
            └── actions/           # UIイベントの司令塔（Action）
```

### 依存の流れ

```
Page / Widget
  ├── ref.watch → Notifier（UI状態の購読）
  └── ref.read → Action（UIイベントの司令塔）
                   ├──→ UseCase（純粋なビジネスロジック）
                   ├──→ Notifier（状態更新）
                   ├──→ AppDialogService（フィードバック）
                   └──→ AppNavigator（画面遷移）
```

### 各層の責務

| 層 | 責務 | importできるもの |
|---|---|---|
| **Page / Widget** | 描画、イベント発火 | Notifier（watch）, Action（read） |
| **Action** | UIイベントの司令塔。UseCaseを呼びつつNotifier更新・Dialog表示・画面遷移を組み立てる | Notifier, UseCase, DialogService, Navigator |
| **Notifier** | UI状態の保持・更新メソッド提供 | Repository（buildでの初期データ取得のみ） |
| **UseCase** | 純粋なビジネスロジック | なし（または他のUseCase） |
| **Repository（抽象）** | データアクセスの定義 | なし |
| **RepositoryImpl** | データアクセスの実装 | Core Infrastructureの抽象 |
| **Core Infrastructure** | 外部パッケージのラップ | 外部パッケージ |

### UseCaseとActionの区別

- **UseCase**: 純粋なビジネスロジック。UIの概念を一切知らない
- **Action**: UIイベントの司令塔。UseCaseを呼びつつ、Notifier更新・Dialog表示・画面遷移を組み立てる
- 区別の基準: 「DialogやNavigatorに依存するか？」 → Yes: Action / No: UseCase

### 重要なルール

- **UIがNotifierを直接操作するのはアンチパターン**。状態変更は必ずAction経由
- **Notifierの `build` メソッド**でのRepository依存（初期データ取得）は許容
- **UseCase・Action・Repository**は純粋なDartクラス（Riverpod非依存）
- **Hooks**はUIローカルな状態のみに使用（TextEditingController、AnimationController等）

## Key Patterns

### State Management: Riverpod + Hooks + Action
- Use `@riverpod` annotation for code-generated providers
- Widgets extend `HookConsumerWidget`
- UIイベントはAction経由、UI状態はNotifier経由
- Providers organized by layer: Data → Domain → Presentation

### Error Handling: Result<T>
```dart
sealed class Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(ApiError error) = Failure<T>;
}
```
UseCases return `Result<T>` for type-safe error handling.
ActionがResult<T>のSuccess/Failureを判定し、Notifier更新またはDialog表示を行う。

### Models: Freezed
All domain models use `@freezed` for immutability, pattern matching, and JSON serialization.

### Core Infrastructure: 外部パッケージの抽象化
- `HttpClientService` → DioHttpClientService（API通信）
- `LocalDbService` → ObjectBoxService（ローカルDB）
- `AppNavigator` → GoRouterNavigator（画面遷移）
- `AppDialogService` → MaterialDialogService（ダイアログ/スナックバー）

## Testing Strategy

### テスト分離

| | Unit Test | Widget Test |
|---|---|---|
| テスト対象 | UseCase, Action, RepositoryImpl | Page, Widget |
| Flutter依存 | **なし** | あり |
| モック対象 | Repository, DialogService, Navigator, Notifier | Action, Notifier（状態） |
| 検証内容 | 正しい指示が出るか | 正しく描画されるか |

### テストヘルパー

Test helpers in `test/helpers/`:
- `createTestApp(widget, overrides: [])` - Basic test wrapper
- `createTestAppWithScaffold(widget, overrides: [])` - With Scaffold
- Mock classes via mocktail in `test/helpers/mocks.dart`

### Goldenテスト

Visual regression with Alchemist.
Golden tests use separate directories for CI (`goldens/ci/`) vs local (`goldens/`).

## Adding New Features

1. Create `lib/features/{feature}/` with the layered structure
2. Define Repository interface in `domain/repositories/`
3. Create Repository implementation in `data/repositories/`
4. Write UseCases in `domain/usecases/`（純粋なビジネスロジック）
5. Add Riverpod providers in `domain/providers/`
6. Create Notifier in `presentation/providers/`（UI状態の保持・更新）
7. Create Action in `presentation/actions/`（UIイベントの司令塔）
8. Build UI in `presentation/{pages,widgets}/`
9. Define routes in `navigation/`
10. Mirror structure in `test/` with >90% coverage

## CI Pipeline

GitHub Actions runs on Ubuntu with the Flutter version from `.fvmrc`:
1. Analyze (lint)
2. Format check
3. Dart fix check
4. Generated files verification
5. Tests with golden updates
6. Coverage threshold check (90% min)

## MCP Servers (Claude Code on the Web)

This project configures MCP (Model Context Protocol) servers in `.mcp.json` to enhance Claude Code's Flutter development capabilities. These are auto-approved via `enableAllProjectMcpServers` in `.claude/settings.json`.

> **Security Note**: Auto-approving MCP servers means any server defined in `.mcp.json` will run automatically without a manual prompt. This is convenient for web-based development but carries risk — if a malicious server configuration is committed (e.g., via a compromised account), it could execute arbitrary code. Always review changes to `.mcp.json` carefully in PRs. If you prefer a stricter security posture, disable `enableAllProjectMcpServers` and approve servers manually.

### Configured Servers

| Server | Command | Purpose |
|--------|---------|---------|
| `dart` | `dart mcp-server` | Official Dart/Flutter MCP — code analysis, symbol resolution, pub.dev search, dependency management, test runner, formatter (requires Dart 3.9+) |
| `context7` | `npx -y @upstash/context7-mcp@2.1.2` | Fetches up-to-date, version-specific documentation for any library (Riverpod, Freezed, go_router, Dio, etc.) |

### Prerequisites

These servers require the following runtimes (installed by the SessionStart hook):
- **Dart 3.9+** (for `dart mcp-server`)
- **Node.js / npx** (for `context7`)

## Code Review

コードレビューのコメントはすべて**日本語**で記述してください。

レビュー時には以下の観点を重視してください：
- **アーキテクチャ**: Feature-First + Layered Architecture に準拠しているか
- **Action層**: UIイベントがAction経由で処理されているか（UIがNotifierを直接操作していないか）
- **状態管理**: Riverpod + Hooks パターンが正しく使われているか
- **エラーハンドリング**: `Result<T>` パターンで型安全にエラー処理されているか（ActionがSuccess/Failureを適切に処理しているか）
- **モデル**: Freezed による不変データモデルが適切に定義されているか
- **Core Infrastructure**: 外部パッケージの抽象化パターンに従っているか
- **テスト**: テストカバレッジ 90% 以上を維持できるか（Action Unit Test + Widget Test の分離）
- **コーディング規約**: flutter_lints、`prefer_const_constructors`、`prefer_single_quotes` に準拠しているか

## Conventions

- **Commits**: Conventional Commits format (`feat:`, `fix:`, `test:`, `ci:`)
- **Linting**: flutter_lints with prefer_const_constructors, avoid_print, prefer_single_quotes
- **Routing**: go_router with declarative routes. Feature routes in `features/{name}/navigation/`
- **Theme**: Centralized in `core/ui/theme/` (AppTheme, AppColors, AppTypography, AppSpacing)
