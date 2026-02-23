# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Development Commands

```bash
# Setup
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# Run
flutter run

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

```
lib/
├── core/                          # Shared infrastructure
│   ├── models/                    # Result<T>, ApiError
│   ├── network/                   # Dio client
│   ├── ui/                        # Theme, shared components
│   └── providers/                 # Global providers (Router)
└── features/
    └── {feature}/                 # Feature modules
        ├── models/                # Domain models (freezed)
        ├── data/
        │   ├── api/               # Retrofit API definitions
        │   └── repositories/      # Repository implementations
        ├── domain/
        │   ├── usecases/          # Business logic
        │   └── providers/         # DI via Riverpod
        └── presentation/
            ├── providers/         # UI state (Notifiers)
            ├── pages/             # Screen widgets
            └── widgets/           # Reusable UI components
```

## Key Patterns

### State Management: Riverpod + Hooks
- Use `@riverpod` annotation for code-generated providers
- Widgets extend `HookConsumerWidget`
- Providers organized by layer: Data → Domain → Presentation

### Error Handling: Result<T>
```dart
sealed class Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(ApiError error) = Failure<T>;
}
```
UseCases return `Result<T>` for type-safe error handling.

### Models: Freezed
All domain models use `@freezed` for immutability, pattern matching, and JSON serialization.

### API Layer: Retrofit + Dio
- Centralized Dio client via `dioClientProvider`
- API classes use Retrofit annotations (@GET, @POST, etc.)
- Repository pattern wraps API calls and handles errors

## Testing Strategy

Three categories of tests:

1. **Unit Tests**: UseCases, Models, Utils (pure Dart)
2. **Widget/Provider Tests**: UI state and behavior
3. **Golden Tests**: Visual regression with Alchemist

Test helpers in `test/helpers/`:
- `createTestApp(widget, overrides: [])` - Basic test wrapper
- `createTestAppWithScaffold(widget, overrides: [])` - With Scaffold
- Mock classes via mocktail

Golden tests use separate directories for CI (`goldens/ci/`) vs local (`goldens/`).

## Adding New Features

1. Create `lib/features/{feature}/` with the layered structure
2. Define Retrofit API in `data/api/`
3. Create repository interface + implementation in `data/repositories/`
4. Write UseCases in `domain/usecases/`
5. Add Riverpod providers in `domain/providers/` and `presentation/providers/`
6. Build UI in `presentation/{pages,widgets}/`
7. Mirror structure in `test/` with >90% coverage

## CI Pipeline

GitHub Actions runs on Ubuntu with Flutter 3.27.4:
1. Analyze (lint)
2. Format check
3. Dart fix check
4. Generated files verification
5. Tests with golden updates
6. Coverage threshold check (90% min)

## Conventions

- **Commits**: Conventional Commits format (`feat:`, `fix:`, `test:`, `ci:`)
- **Linting**: flutter_lints with prefer_const_constructors, avoid_print, prefer_single_quotes
- **Routing**: go_router with declarative routes in `router_provider.dart`
- **Theme**: Centralized in `core/ui/theme/` (AppTheme, AppColors, AppTypography, AppSpacing)
