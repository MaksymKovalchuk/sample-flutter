# Flutter Starter

Production-ready Flutter starter template with Clean Architecture, BLoC, type-safe env config, auto-DI, and code generation wired up.

Clone → configure `.env` → run `build_runner` → start coding your feature.

---

## Stack

| Concern | Choice |
|---|---|
| State management | **BLoC** (`flutter_bloc` + `bloc_concurrency`) |
| Dependency injection | **GetIt** + **Injectable** (auto-registered via annotations) |
| Routing | **go_router** with redirect-based auth guard |
| Networking | **http** + custom `RestClient` with token refresh & retry |
| Persistence | **Hive CE** (local) + **flutter_secure_storage** (tokens) |
| Env / config | **envied** (type-safe, generated from `.env`) |
| Models | **freezed** 3.x + **json_serializable** |
| Localization | Flutter `gen-l10n` (English, Spanish) |
| Theming | Light / Dark with `ValueNotifier<ThemeMode>` + cached colour & text styles |
| Logging | Custom `Logger` wrapper around `logging` package |
| Testing | `flutter_test` (no mocks needed for the starter tests) |
| Lints | `flutter_lints` + ~125 custom rules with strict casts / inference / raw types |

---

## Project layout

```
lib/
  main.dart              # single entry point (print suppressor + error zone)
  src/
    core/
      app_initializer/   # post-login readiness gate
      bloc/              # global AppBloc (auth states)
      caches/            # Hive + secure-storage wrappers
      constants/
      di/                # Injectable module + generated config
      env/               # Envied Env class (generated from .env)
      extensions/        # context / widget / iterable helpers
      localization/      # locale provider + gen-l10n
      models/            # freezed models (ErrorEntity)
      navigation/        # go_router + AuthGuard + transitions
      network/           # RestClient, TokenProvider, interceptors
      session/           # Account / Session / Logout managers
      theme/             # colours, typography, style cache
    feature/
      app/               # root App widget + lifecycle
      tab_bar/           # example feature
      widgets/           # shared widgets (Bounce, SnackBar…)
    services/
      device/            # device-info helpers
      helpers/           # retry, print suppressor
      logging/           # custom Logger
      notifications/     # flutter_local_notifications wrapper
      validators/        # pure-function InputValidators
test/                    # unit tests (validators + AuthGuard)
```

---

## Setup

### Prerequisites
- Flutter `>=3.32.0`
- Dart `>=3.8.0`

### 0. Rename for your project (one-time)

Change the package name, bundle IDs, and app title across all platforms with a single command:

```bash
# Preview the changes
dart run tool/rename.dart \
  --name my_shop \
  --bundle-id com.company.myshop \
  --title "My Shop" \
  --dry-run

# Apply
dart run tool/rename.dart \
  --name my_shop \
  --bundle-id com.company.myshop \
  --title "My Shop"
```

The script updates `pubspec.yaml`, all Dart imports, `android/` (`build.gradle.kts`, manifest, Kotlin package path), `ios/` (`project.pbxproj`, `Info.plist`), and runs `flutter pub get` + `build_runner build` + `dart fix --apply` + `dart format .` afterwards. It refuses to run on a dirty git tree unless `--force` is passed.

Optional — reset git history so your project starts with a single clean commit:
```bash
rm -rf .git
git init && git add . && git commit -m "chore: initial commit from starter"
```

### 1. Install dependencies
```bash
flutter pub get
```

### 2. Configure environment
```bash
cp .env.example .env
```
Edit `.env` and fill in your real API URLs and (optionally) Sentry DSN:
```
API_MAIN_URL=https://api.your-backend.com/
API_PORTAL_URL=https://api.your-backend.com/portal/
SENTRY_DSN=
```
`.env` is git-ignored; only `.env.example` is committed.

### 3. Run code generation
Generates `env.g.dart`, `injection.config.dart`, `*.freezed.dart`, `*.g.dart`:
```bash
dart run build_runner build --delete-conflicting-outputs
```
Or run in watch mode while developing:
```bash
dart run build_runner watch --delete-conflicting-outputs
```

### 4. Run the app
```bash
flutter run                   # debug
flutter run --release         # release build
```

Single entry point at `lib/main.dart`. If you need env-specific behavior (different config in dev vs prod), use `kReleaseMode` / `kDebugMode` from `package:flutter/foundation.dart` or branch on `Env.xxx` values.

> If you later need real Android/iOS build flavors (different bundle IDs, icons, schemes), set them up per-project with `flutter create --flavors` or edit `android/app/build.gradle` and the iOS schemes manually.

---

## Common commands

| Task | Command |
|---|---|
| Static analysis | `flutter analyze` |
| Format code | `dart format .` |
| Run tests | `flutter test` |
| Auto-fix lint issues | `dart fix --apply` |
| Rebuild generated files | `dart run build_runner build --delete-conflicting-outputs` |
| Clean | `flutter clean && flutter pub get` |

---

## Adding a new dependency (Injectable)

Annotate the class and re-run the generator:

```dart
@lazySingleton
class UserRepository {
  UserRepository(this._client);
  final RestClient _client;
}
```

Then:
```bash
dart run build_runner build --delete-conflicting-outputs
```

Resolve anywhere via:
```dart
getIt<UserRepository>()
```

For third-party / async / callback-dependent services, add them to the `RegisterModule` in [`lib/src/core/di/injection.dart`](lib/src/core/di/injection.dart).

---

## Adding a new model (Freezed)

```dart
// lib/src/feature/profile/model/user.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String email,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

Then run `dart run build_runner build`.

---

## Auth flow

`AppBloc` owns four states defined in [`app_state.dart`](lib/src/core/bloc/app_state.dart):

- `AuthUninitialized` — initial (before `AppStarted` is dispatched)
- `AuthInProgress` — login / logout / init in flight
- `AuthAuthenticated` — token present and validated
- `AuthUnauthenticated` — no token, show login

[`AuthGuard.redirectLogic`](lib/src/core/navigation/core/auth_guard.dart) reads the current `AppState` and returns a redirect path for `go_router`:
- Unauthenticated on a protected route → `/auth`
- Authenticated on `/auth` → `/tab-bar`
- Uninitialized / in-progress → stay put

The router subscribes to `AppBloc.stream` via [`GoRouterRefreshStream`](lib/src/core/navigation/core/router_refresh_stream.dart), so redirects fire automatically on state changes.

---

## Networking

[`RestClient.request<T>`](lib/src/core/network/core/rest_client.dart) handles:
- Token retrieval via `TokenProvider` with safe refresh (`Completer`-based dedup)
- Retry with exponential-ish backoff (`RetryHelper`)
- 401 → triggers `LogoutManager.logout()`
- Timeout → `ApiException` with status `408`
- Structured errors via `NetworkExceptions.handleError`

Use `ApiModel` to describe requests, call `_restClient.request<MyType>(...)`, and cast/parse the response to your freezed model.

Example repository: [`AuthRepository`](lib/src/core/network/rest/repositories/auth_repository.dart).

---

## Contributing to the starter

1. Run `flutter analyze` — must be 0 issues.
2. Run `dart format .` — must be 0 changes.
3. Run `flutter test` — must be all green.
4. If you change models / DI / env — re-run `build_runner`.

---

## Licence

Use freely as a template. Attribution not required.
