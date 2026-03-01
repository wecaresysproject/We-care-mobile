---
trigger: always_on
---

```markdown
# 🏥 We Care Mobile – Engineering Rules & Architecture Contract

---

# 🎯 Purpose

This document defines strict engineering standards for the **We Care Mobile** project.  
All written or generated code must follow these rules without exception.

## Engineering Priorities (in order)

1. Performance  
2. Feature based archtiture  
3. Scalability  
4. Maintainability  
5. Testability  
6. Readability  

Quick fixes that break architecture are not allowed.

---

# 📁 Project Structure Contract

The project structure must remain exactly as follows:

```

we_care_mobile/
├── android/ & ios/         # Native platform configurations (Flavors setup)
├── assets/                 # Images, SVGs, Fonts (Cairo), Sounds
├── lib/
│   ├── core/               # Shared logic across the app
│   │   ├── di/             # Dependency Injection (GetIt)
│   │   ├── global/         # Shared widgets, themes, helpers
│   │   ├── networking/     # Dio/Retrofit + interceptors
│   │   └── routing/        # AppRouter & navigation
│   ├── features/           # Independent modules (login, medicine, allergy, x_ray, etc.)
│   ├── generated/          # Auto-generated code (L10n, build_runner output)
│   ├── main_development.dart
│   ├── main_production.dart
│   └── we_care_app.dart
├── test/
└── pubspec.yaml

```

## Structure Rules

- No networking logic inside `presentation`.
- No cross-feature direct imports.
- No business logic inside UI.

---



## Layer Responsibilities

### Presentation
- UI
- Cubit/Bloc
- State rendering only
- No API calls
- No JSON parsing

### Domain
- Entities
- Use cases (optional)
- Pure business logic
- No framework dependency

### Data
- DTO models
- Repository implementation
- Service calls
- Mapping DTO → Entity

## Strictly Forbidden

- UI importing networking layer
- Domain importing data layer
- API calls from UI
- Direct DTO usage inside UI

---

# 📦 Model Rules

All API models must:

- Use `json_serializable`
- Be immutable
- Implement `Equatable`
- Use `explicitToJson: true` for nested objects
- Avoid `dynamic` unless strictly required
- Avoid manual `fromJson` / `toJson`

## Model Standards

- Separate request and response models
- No UI-specific logic inside models
- No nullable abuse — use required fields when applicable
- Use enums instead of raw string values

---

# 🌐 API Integration Standard

## Step 1 – Create Models

Location:

```

features/<feature>/data/models/

```

Create:
- request_model.dart
- response_model.dart

---

## Step 2 – Add Endpoint to Service

Location:

```

core/networking/

```

Rules:
- Use Retrofit annotations
- No business logic
- No error handling
- No mapping
- No hardcoded base URLs

---

## Step 3 – Repository Implementation

Location:

```

features/<feature>/data/repositories/

```

Repository must:

- Call service
- Wrap response inside `ApiResult`
- Catch and transform exceptions
- Map DTO → Domain entity

Return type must be:

```

Future<ApiResult<Entity>>

```

Never return raw response to UI.

---

## Step 4 – Dependency Injection

Register inside:

```

core/di/dependency_injection.dart

```

Rules:
- Use `lazySingleton` by default
- No direct instantiation inside UI
- All services and repositories must be registered
- Keep registration centralized

---

## Step 5 – Code Generation

After editing models or Retrofit services:

```

dart run build_runner build --delete-conflicting-outputs

```

Never commit without generating code.

---

# ⚡ Performance Rules

## Widget Rules

- Never return large UI blocks from helper methods inside `build()`
- Extract reusable UI into separate `StatelessWidget`
- Use `const` constructors wherever possible
- Avoid deep widget nesting (>5 levels → extract widget)
- Avoid heavy logic inside `build()`
- Avoid anonymous widgets inside large lists

---

## Rebuild Optimization

- Do not wrap full screen in a single `BlocBuilder`
- Use `BlocSelector` or `buildWhen`
- Avoid unnecessary state emissions
- Guard against duplicate loading states
- Do not emit identical states
- Keep state objects minimal and immutable

---

## List Rendering

- Use `ListView.builder` for large lists
- Never use `Column + map` for large datasets
- Implement pagination for large API responses
- Use keys when necessary for performance stability

---

## Memory Optimization

- Dispose controllers properly
- Do not store large lists in Cubit state
- Avoid global mutable variables
- Never store `BuildContext` in state
- Avoid large object allocations in build

---

# 🌐 Networking Rules

All networking must go through:

```

core/networking/

```

Must include:
- Dio client
- Logging interceptor
- Token refresh interceptor
- Centralized error handling

Forbidden:
- Hardcoded URLs inside features
- Direct Dio usage inside features
- Error handling inside UI
- JSON parsing inside presentation layer

---

# 🔐 Authentication & Token Rules

- Access token handled via interceptor
- Refresh token must be automatic
- Unauthorized responses handled centrally
- No token logic inside UI
- Do not expose tokens in logs

---

# 🎨 UI & Theming Rules

- No hardcoded colors
- No hardcoded strings
- Use localization (L10n)
- Use shared components from `core/global`
- No magic numbers
- Follow consistent spacing system
- Reuse typography styles from theme


---

# 🚀 Flavor Rules

- No direct flavor checks in UI
- Use centralized configuration class
- Branding differences handled in theme
- Environment logic only in:
  - `main_development.dart`
  - `main_production.dart`
- No scattered environment conditions across features

---

# 🧹 Code Quality Rules

- No duplicate logic
- No commented dead code
- No large God classes
- Follow Dart naming conventions
- Always declare return types
- Avoid unused imports
- Avoid unnecessary null checks

Recommended linter rules:

- prefer_const_constructors
- prefer_const_literals_to_create_immutables
- avoid_redundant_argument_values
- avoid_print
- always_declare_return_types
- unnecessary_this

---

# 🏥 Medical App Specific Rules

- Handle patient data securely
- Avoid logging sensitive information , use AppLogger class in helpers
- Mask sensitive fields in logs
- Validate medical inputs strictly
- Ensure error messages are user-safe
- No sensitive data inside crash logs
- Maintain clear separation between medical data and UI formatting

---

# 🏁 Final Engineering Principle

Every feature must be:

- Modular
- Isolated
- Scalable
- Performance-optimized

If a solution compromises architecture, performance, or scalability, it must be redesigned.
```
