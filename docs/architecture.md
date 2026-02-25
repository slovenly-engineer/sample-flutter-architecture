# Flutter アーキテクチャ設計書

## 1. 設計方針

| 項目 | 採用 |
|---|---|
| 横の分割 | Feature-first（機能単位） |
| 縦の分割 | Layered Architecture（Presentation / Domain / Data） |
| 状態管理 | Riverpod + Hooks |
| 依存の流れ | Presentation → Domain → Data → Core Infrastructure（単方向） |
| 外部パッケージ依存 | Core Infrastructure層に閉じ込める |

---

## 2. パッケージ構成と抽象化方針

| カテゴリ | パッケージ | 抽象化 |
|---|---|---|
| 状態管理 | riverpod, flutter_hooks | しない（アーキテクチャ根幹） |
| モデル生成 | freezed, json_serializable | 不要（ビルド時依存） |
| API通信 | dio | `HttpClientService` で抽象化 |
| ローカルDB | objectbox | `LocalDbService` で抽象化 |
| ルーティング | go_router | `AppNavigator` で抽象化 |
| UIフィードバック | material | `AppDialogService` で抽象化 |
| テスト | mocktail | - |

### パッケージ差し替え時の影響範囲

| パッケージ | 変更ファイル | Feature側 |
|---|---|---|
| Dio → http | core/infrastructure/network/ 内の2〜3ファイル | **変更不要** |
| ObjectBox → Isar | core/infrastructure/storage/ 内の2ファイル | **変更不要** |
| go_router → auto_route | core/infrastructure/navigation/ 内の2ファイル | **変更不要** |
| Material → Cupertino | core/infrastructure/ui/ 内の1ファイル | **変更不要** |

### 抽象化しないパッケージの扱い

- **Riverpod / Hooks**: アーキテクチャ根幹。抽象化コスト＞メリット。ただしUseCase・Action・Repositoryは純粋なDartクラスなので、Riverpodに変更があっても影響はProvider配線層のみ
- **freezed / json_serializable**: ビルド時依存。生成済みコードはDart標準で動くため、サポート終了時も即座にアプリが壊れるリスクなし。段階的に別パッケージへ移行可能

---

## 3. 依存の流れ

```
Page / Widget
  │
  ├── ref.watch → Notifier（UI状態の購読）
  │                  ↑
  │                  │ 状態更新の指示
  │                  │
  └── ref.read → Action（UIイベントの司令塔）
                   │
                   ├──→ UseCase（純粋なビジネスロジック）
                   ├──→ Repository抽象（データ操作）
                   ├──→ AppDialogService（フィードバック）
                   └──→ AppNavigator（画面遷移）
                            │
                            ↓
                   RepositoryImpl（Data層）
                            │
                            ↓
                   Core Infrastructure（抽象 → 具体実装）
                   ├── HttpClientService  → DioHttpClientService
                   ├── LocalDbService     → ObjectBoxService
                   ├── AppNavigator       → GoRouterNavigator
                   └── AppDialogService   → MaterialDialogService
                            │
                            ↓
                   外部パッケージ
```

---

## 4. 各層の責務

| 層 | 責務 | importできるもの |
|---|---|---|
| **Page / Widget** | 描画、イベント発火 | Notifier（watch）, Action（read） |
| **Action** | UIイベントの司令塔。各所に指示を出す | Notifier, UseCase, Repository, DialogService, Navigator |
| **Notifier** | UI状態の保持・更新メソッド提供 | Repository（buildでの初期データ取得のみ・許容事項） |
| **UseCase** | 純粋なビジネスロジック | なし（または他のUseCase） |
| **Repository（抽象）** | データアクセスの定義 | なし |
| **RepositoryImpl（具体）** | データアクセスの実装、Entity↔Model変換 | Core Infrastructureの抽象, Entity |
| **Core Infrastructure** | 外部パッケージのラップ | 外部パッケージ |

### UseCaseとActionの区別

- **UseCase**: 純粋なビジネスロジック。UIの概念（Dialog, Navigator, Notifier）を一切知らない
- **Action**: UIイベントの司令塔。UseCaseを呼びつつ、Notifier更新・Dialog表示・画面遷移を組み立てる

区別の基準: 「DialogやNavigatorに依存するか？」 → Yes: Action / No: UseCase

### Notifierの許容事項

Notifierの `build` メソッドでのRepository依存（初期データ取得）は、Riverpodの根幹機能として許容する。

### Hooksの役割

UIローカルな状態（TextEditingController、AnimationController、フォーカス等）だけに使用。ビジネスに関わる状態はすべてRiverpod Providerに置く。

---

## 5. フォルダ構成

```
lib/
  ├── main.dart
  ├── app.dart
  ├── core/
  │   ├── infrastructure/
  │   │   ├── network/              # HTTP通信（抽象 + Dio具体実装）
  │   │   ├── storage/              # ローカルDB（抽象 + ObjectBox具体実装）
  │   │   ├── navigation/           # 画面遷移（抽象 + go_router具体実装）
  │   │   └── ui/dialogs/           # ダイアログ/スナックバー（抽象 + Material具体実装）
  │   │
  │   ├── auth/                     # 認証（横断的関心事）
  │   ├── app_settings/             # アプリ設定（横断的関心事）
  │   ├── initialization/           # アプリ起動処理
  │   │
  │   ├── models/                   # 共通モデル（3Feature以上で使用）
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
      └── {feature_name}/
          ├── models/               # Feature内共有モデル（freezed）
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
              ├── pages/
              ├── widgets/
              ├── providers/        # UI状態（Notifier）
              └── actions/          # UIイベントの司令塔
```

---

## 6. 配置ルール

### core/ と feature/ の判断基準

```
そのドメインは特定のビジネス機能に属するか？
  │
  ├── Yes → features/
  │   例: Todo管理、ユーザープロフィール、注文、商品一覧
  │
  └── No → core/
      ├── 外部パッケージの抽象化？ → core/infrastructure/
      ├── アプリ全体の横断的関心事？ → core/{concern_name}/
      ├── Feature非依存の画面？ → core/pages/
      └── 共通UIパーツ？ → core/ui/
```

### core/models/ 昇格基準

以下をすべて満たす場合のみ core/models/ に置く:
- 3つ以上のFeatureで使用している
- Feature間で同一の構造である

それ以外は feature/{name}/models/ に置き、共通化の必要が出てから昇格させる。

### Entity配置ルール

| Entityの性質 | 配置先 |
|---|---|
| Feature固有 | `features/{name}/data/entities/` |
| 横断的関心事 | `core/{concern_name}/entities/` |

`core/infrastructure/storage/` はEntityを一切持たない（汎用CRUDメソッドのみ）。

### 責務の配置基準

| やること | 置く場所 |
|---|---|
| 文字列の加工・結合 | Notifier（Presentation） |
| 条件判定（表示/非表示、有効/無効） | Notifier（Presentation） |
| ビジネスルールの判定 | UseCase（Domain） |
| API呼び出し・データ保存の実行 | Repository（Data） |
| UI状態更新・フィードバック・画面遷移の組み立て | Action（Presentation） |
| アニメーション制御、フォーカス管理 | Hooks（Presentation） |

---

## 7. UI設計原則

| 要素 | 責務 |
|---|---|
| **Page** | UIパーツを組み立てる場所。ロジックは持たない |
| **Widget** | 再利用可能な部品。Riverpod経由でデータ取得 |
| **データ共有** | Riverpod経由（引数でのデータ受け渡しはアンチパターン） |
| **Feature非依存コンポーネント** | core/ui/ に配置。上記ルール対象外 |

UIの依存は2つだけ:
- **Notifier**: `ref.watch` で「今どういう状態か」を受け取る
- **Action**: `ref.read` で「これが起きた」を伝える

UIがNotifierを直接操作することはアンチパターン。状態変更は必ずAction経由。

---

## 8. テスト戦略

### テスト分離

| | Unit Test | Widget Test |
|---|---|---|
| テスト対象 | UseCase, Action, RepositoryImpl | Page, Widget |
| Flutter依存 | **なし** | あり |
| モック対象 | Repository, DialogService, Navigator, Notifier | Action, Notifier（状態） |
| 検証内容 | 正しい指示が出るか | 正しく描画されるか |
| 実行速度 | **非常に高速** | やや遅い |
| 担当者 | ロジック担当 | UI担当 |

各層が完全に分離されているため、ロジック担当者はFlutterを知らなくてもUnit Testが書け、UI担当者はビジネスロジックを知らなくてもWidget Testが書ける。作業が完全に並行可能。

---

## 9. 肥大化防止策

| 箇所 | 肥大化するか | 対策 |
|---|---|---|
| `HttpClientService` | しない | 汎用メソッドのみ。APIが増えてもインターフェース不変 |
| `LocalDbService` | しない | 汎用CRUDのみ。テーブルが増えてもインターフェース不変 |
| `AppNavigator` | やや増える | Feature単位でNavigator分割して軽減 |
| `AppDialogService` | しない | ダイアログ種別は限定的 |
| Entity定義 | しない | Feature側に分散配置 |
| ルート定義 | しない | Feature側でルート定義、coreは組み立てのみ |
| `core/models/` | しない | 厳格な昇格基準で抑制 |

---

## 10. 抽象化の適用範囲

同じパターン（抽象定義 → 具体実装 → Provider配線）は以下にも適用可能:

| 対象 | 抽象 | 具体実装例 |
|---|---|---|
| API通信 | `HttpClientService` | Dio |
| ローカルDB | `LocalDbService` | ObjectBox |
| 画面遷移 | `AppNavigator` | go_router |
| ダイアログ/スナックバー | `AppDialogService` | Material |
| カメラ | `CameraService` | camera |
| 位置情報 | `LocationService` | geolocator |
| プッシュ通知 | `NotificationService` | firebase_messaging |
| 分析 | `AnalyticsService` | firebase_analytics |

---

## 11. 残された課題

- エラーハンドリングの統一パターン
- 認証・認可の具体的な実装方法
- CI/CDでのテスト自動化設定

## 12. 次のアクション

1. プロジェクトの初期セットアップ
2. Core Infrastructureの基盤実装（HttpClientService, LocalDbService, AppNavigator, AppDialogService）
3. 横断的関心事の実装（auth, app_settings, initialization）
4. 1つのFeatureをサンプル実装し、パターンを検証
5. 検証結果をもとにルールを微調整
