# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

**We Care** is a Flutter Personal Health Record (PHR) app for tracking medical history, chronic diseases, prescriptions, biometrics, and more. Arabic (RTL) is the primary/default locale, with English also supported.

## Common commands

```bash
flutter pub get                       # install dependencies
flutter analyze                       # lint (rules in analysis_options.yaml, based on flutter_lints)
flutter test                          # run all tests
flutter test test/widget_test.dart    # run a single test file

# Code generation (required after editing any @RestApi service, Freezed model,
# json_serializable model, or Hive adapter — these are hand-committed .g.dart/.freezed.dart files)
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch --delete-conflicting-outputs   # while iterating

# Run the app — there is no single `flutter run`, always pick a flavor entrypoint:
flutter run -t lib/main_development.dart
flutter run -t lib/main_production.dart
```

There are two build flavors, `development` and `production`, selected by entrypoint file (`lib/main_development.dart`, `lib/main_production.dart`), not by `--flavor`. iOS flavor setup lives in `ios/setup_flavors.rb`.

Localization strings are managed via `flutter_intl` (ARB files in `lib/l10n/intl_ar.arb`, `lib/l10n/intl_en.arb`, generated code in `lib/generated/`). Regenerate via the Flutter Intl IDE plugin or `flutter pub run intl_utils:generate` after editing ARB files.

## Architecture

**Feature-first structure.** Each of the 38 modules under `lib/features/` (allergy, medicine, x_ray, vaccine, surgeries, biometrics, essential_info, etc.) is self-contained and typically split into `*_data_entry` (create/edit) and `*_view` (read) sub-features, each with its own `logic/cubit`, `Presentation/views` (or `views`), and shared `data/` (models + repos). A feature's API endpoints live in a `<feature>_api_constants.dart` file, and its Retrofit service in `<feature>_services.dart` (generates `<feature>_services.g.dart`).

**Layering per feature:** `View (Cubit/BlocBuilder)` → `Cubit` → `Repo` (wraps calls in `ApiResult.success`/`ApiResult.failure` via `ApiErrorHandler.handle`) → `*Services` (Retrofit/Dio interface) → REST API. Models are `json_serializable` (`.g.dart`) or occasionally `freezed`.

**Dependency injection:** all services/repos/cubits are registered in `lib/core/di/dependency_injection.dart` via `get_it` (`getIt`), split into `setupAppServices()` (Retrofit services, singletons, share one `Dio` instance), `setupAppRepos()` (repos, lazy singletons), and `setupAppCubits()` (cubits, factories — new instance per screen). When adding a feature, register all three in this file following the existing per-feature grouping. Widely reused cross-feature logic (doctor specializations, countries, image/report uploads, module guidance videos) lives in `AppSharedRepo`/`SharedServices` (`lib/core/global/shared_repo.dart`, `shared_services.dart`) rather than being duplicated per feature.

**Networking (`lib/core/networking/`):**
- `dio_serices.dart` — single shared `Dio` instance (`DioServices.getDio()`). `addCareContextInterceptor()` attaches the `Authorization: Bearer <token>` header (read fresh from secure storage on every request) and, when in "care mode", an `Active-Medical-Profile` header carrying the active patient's ID. Also wires a debug-only logging interceptor, a cancellation interceptor (`DioServices.cancelRequests()`), and a naive retry-on-500 interceptor.
- `auth_api_constants.dart` / `auth_service.dart` — auth endpoints (signup, login, OTP, forgot/reset password). No refresh-token mechanism exists; the bearer token is long-lived until manually cleared.
- There is no logout endpoint or wired-up in-app "change password while authenticated" flow yet — only the forgot-password/reset-via-OTP flow is implemented. If asked to add these, coordinate the actual backend contract first rather than assuming REST conventions.

**Local storage (`lib/core/Database/cach_helper.dart`):** `CacheHelper` wraps two stores — `SharedPreferences` for plain data and `FlutterSecureStorage` for sensitive data (auth token, cached FCM token). `clearAllData()` / `clearAllSecuredData()` exist for wiping state (e.g. on logout or fresh install) but must be called explicitly by feature code — nothing invokes them automatically except the first-run check in `main_development.dart`/`main_production.dart` (`checkIfLoggedInUser`).

**Care/family access model:** `CareContextManager` (`lib/core/networking/models/care_context_manager_model.dart`) is a static, app-wide `ValueNotifier<CareContext?>` representing "care mode" — when a user is viewing/editing another patient's records via delegated access (see `allowed_care_access` feature), `CareContextManager.enter(...)` sets the active patient context, which the Dio interceptor and permission checks (`hasModuleAccessForViewMedicalFilesCategory`, `hasModuleAccessForDataEntryMedicalFilesCategory`) read to scope requests and gate UI. `MedicalModule` (`lib/core/models/medical_module_enum.dart`) is the canonical enum identifying each medical module for these permission checks — reuse it rather than string module names when adding permission-aware features.

**Routing:** classic named routes — `Routes` (`lib/core/routing/routes.dart`) defines route name constants; `AppRouter` (`lib/core/routing/app_router.dart`) maps them to widgets via `onGenerateRoute`. Add both a `Routes` constant and an `AppRouter` case when adding a new screen.

**Local persistence beyond auth:** some features (medicine alarms, medical complaints, genetic diseases) use `Hive` boxes registered/opened directly in `main_development.dart`/`main_production.dart` (not centrally abstracted) — if extending one of these, register any new `TypeAdapter` and open its box the same way, in both entrypoints.

**Notifications:** `FcmTokenManager` (`lib/core/Services/fcm_token_manager.dart`) syncs the Firebase Messaging token to the backend, debounced, and caches the last-sent token in secure storage to avoid redundant syncs. It already exposes `clearCachedToken()` intended for logout, but nothing calls it yet.
