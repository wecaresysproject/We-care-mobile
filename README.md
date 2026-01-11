# We Care Mobile Application

![Project Status](https://img.shields.io/badge/Status-In%20Development-orange)
![Flutter Version](https://img.shields.io/badge/Flutter-%5E3.6.0-blue)
![Dart Version](https://img.shields.io/badge/Dart-%5E3.0.0-blue)
![License](https://img.shields.io/badge/License-Proprietary-red)

**We Care** is a comprehensive **Personal Health Record (PHR) and Medical Management System** built with Flutter. It empowers users to take control of their health data by providing a centralized, secure, and intelligent platform for tracking medical history, chronic diseases, prescriptions, and biometrics.

Unlike simple fitness trackers, We Care is designed for **medical depth**, allowing users to manage complex health scenarios such as medication compatibility, genetic disease tracking, and detailed laboratory results.

---

## 📸 Screenshots (WIP)

| Create Account | Login | Contact Support | Home Screen |
|:---:|:---:|:---:|:---:|
| ![Reset Password](assets/screenshots/WhatsApp%20Image%202026-01-11%20at%2010.48.44%20PM.jpeg) | ![Popup](assets/screenshots/WhatsApp%20Image%202026-01-11%20at%2010.49.11%20PM.jpeg) | ![Biometrics](assets/screenshots/WhatsApp%20Image%202026-01-11%20at%2010.49.30%20PM.jpeg) | ![Screen 1](assets/screenshots/WhatsApp%20Image%202026-01-11%20at%2010.50.20%20PM.jpeg) |
| **Home Screen** | **Medical Analaysis** | **Laboratory Tests** | **Dental Module** |
| ![Screen 2](assets/screenshots/WhatsApp%20Image%202026-01-11%20at%2010.50.20%20PM%20(1).jpeg) | ![Screen 3](assets/screenshots/WhatsApp%20Image%202026-01-11%20at%2010.52.52%20PM.jpeg) | ![Screen 4](assets/screenshots/WhatsApp%20Image%202026-01-11%20at%2010.54.16%20PM.jpeg) | ![Screen 5](assets/screenshots/WhatsApp%20Image%202026-01-11%20at%2010.54.42%20PM.jpeg) |
| **Biometrics tracking** | **Features** | **Navigation** | **Settings** |
| ![Screen 6](assets/screenshots/WhatsApp%20Image%202026-01-11%20at%2010.59.04%20PM.jpeg) | | | |

*(Note: Screenshots will be updated as UI polishing is finalized.)*

---

## 🎯 Business Context & Use Case

In the modern healthcare landscape, patient data is often fragmented across various hospitals, clinics, and paper records. This fragmentation leads to:
*   **Medical Errors**: Due to drug interactions or unknown allergies.
*   **Inefficient Care**: Doctors lacking a complete patient history.
*   **Data Loss**: Physical records getting lost or damaged.

### The Solution
**We Care** bridges this gap by acting as a **digital health passport**.
*   **Target Users**: Individual patients, caregivers managing family health, and patients with chronic conditions.
*   **Value Proposition**:
    *   **Centralized Health Data**: Access x-rays, prescriptions, and lab tests instantly.
    *   **Intelligent Safety**: Automated checks for medication compatibility.
    *   **Emergency Readiness**: Critical info (allergies, blood type) available at a glance.

---

## ✨ Key Features

### 🩺 Comprehensive Digital Health Record
*   **Personal Profile**: Manage essential info, biometrics, and user types.
*   **Medical History**: Track **Surgeries**, **Chronic Diseases**, **Medical Illnesses**, and **Genetic Diseases**.
*   **Diagnostics**: storage for **X-Rays**, **Test Laboratory** results, and **Eye** exams.

### 💊 Medication Management
*   **Prescriptions & Medicines**: Digital repository for all current and past medications.
*   **Medication Compatibility**: **(Advanced)** Intelligent analysis to check for potential interactions between stored medicines.
*   **Supplements & Nutrition**: Track intake and dietary requirements.

### 🛡️ Safety & monitoring
*   **Allergy Management**: specialized module for logging drug and food allergies.
*   **Vaccine Tracker**: Record immunization history.
*   **Biometrics & Physical Activity**: Monitor vital signs and daily activity levels.

### ⚙️ Core Utilities
*   **Secure Authentication**: Login, Sign Up, OTP Verification, and Password Management.
*   **Localization**: First-class support for **Arabic** (RTL) and English.
*   **Emergency & Support**: Rapid access to emergency complaints and customer support.

---

## 🏗️ System Architecture

The project follows a **Feature-First, Clean Architecture** approach to ensure scalability, testability, and separation of concerns.

### High-Level Layers

1.  **Presentation Layer (UI)**
    *   Built with **Flutter Widgets** and **ScreenUtil** for pixel-perfect responsiveness.
    *   **State Management**: Uses **Bloc / Cubit** pattern for predictable state transitions.
    *   **Localization**: Integrated via `flutter_intl`.

2.  **Domain Layer (Business Logic)**
    *   Contains pure Dart models and entities.
    *   Defines abstract repositories and use cases.

3.  **Data Layer (Infrastructure)**
    *   **Networking**: **Dio** with **Retrofit** for type-safe API calls.
    *   **Local Storage**: **Hive** for fast offline data and **Flutter Secure Storage** for sensitive tokens.
    *   **Mocking/Testing**: Interfaces prepared for unit and integration testing.

### Data Flow
`UI Event` ➡️ `Cubit/Bloc` ➡️ `UseCase/Repository` ➡️ `RemoteDataSource (API)` OR `LocalDataSource (DB)` ➡️ `UI Update`

---

## 🛠️ Technical Stack

### Frontend & Core
*   **Framework**: Flutter (Dart)
*   **State Management**: `flutter_bloc`, `equatable`
*   **Dependency Injection**: `get_it` (Service Locator pattern)
*   **Navigation**: Named routes with arguments.

### Networking & Data
*   **API Client**: `dio` + `pretty_dio_logger` (Interceptors, logging, error handling)
*   **Code Gen**: `retrofit`, `json_serializable`, `freezed`
*   **Local DB**: `hive` (NoSQL), `shared_preferences`

### UI & UX
*   **Responsive Design**: `flutter_screenutil`
*   **Animations**: `lottie`, `confetti`
*   **Components**: `skeletonizer` (Loading), `carousel_slider`, `fl_chart` (Health graphs), `accordion`.

### Advanced Capabilities
*   **Media**: `camera`, `image_picker`, `audioplayers` (Audio notes).
*   **AI/ML**: `google_mlkit_text_recognition` (OCR for reports), `speech_to_text`.
*   **Background Tasks**: `alarm`, `flutter_local_notifications`.

---

## 📂 Application Structure

```bash
we_care_mobile/
├── android/ & ios/         # Native platform configurations (Flavors setup)
├── assets/                 # Images, SVGs, Fonts (Cairo), Sounds
├── lib/
│   ├── core/               # Shared logic across the app
│   │   ├── di/             # Dependency Injection setup
│   │   ├── global/         # Shared widgets, themes, helpers
│   │   ├── networking/     # API constants, Dio client, Interceptors
│   │   └── routing/        # AppRouter and Route definitions
│   ├── features/           # Feature-based modules (Self-contained)
│   │   ├── allergy/
│   │   ├── medicine/
│   │   ├── login/
│   │   ├── home_tab/
│   │   └── ... (30+ modules)
│   ├── main_development.dart # Dev entry point
│   ├── main_production.dart  # Prod entry point
│   └── we_care_app.dart    # Root widget
└── pubspec.yaml            # Dependencies
```

### Scalability Considerations
*   **Modular Features**: Each feature inside `lib/features` is independent, making it easy for squads to work in parallel.
*   **Flavors**: configured for `dev` and `prod` environments to separate API endpoints and configurations.

---

## 🔒 Security & Data Handling

*   **Secure Storage**: Sensitive data (Auth Tokens, PII) is stored using `flutter_secure_storage` (Keychain on iOS, Keystore on Android).
*   **Environment Variables**: Uses `flutter_dotenv` to keep API keys and base URLs out of the source code.
*   **Type Safety**: Strict JSON parsing ensures the app doesn't crash on malformed API responses.

---

## 🔮 Future Enhancements

*   **Telemedicine Integation**: Video calls with doctors using the `camera` and WebRTC.
*   **AI Health Insights**: Deeper analysis of lab reports using LLMs.
*   **Wearable Sync**: Direct integration with Apple Health / Google Fit.

---

## 👨‍💻 CV-Ready Summary

> **Senior Flutter Developer | We Care Mobile App**
>
> Architected and developed a scalable **Personal Health Record (PHR)** system with over **30+ feature modules**.
> *   Implemented **Clean Architecture** with **Bloc/Cubit** state management to handle complex medical workflows and data entry.
> *   Built advanced features including **OCR for medical reports**, **Medication Compatibility Checking**, and **Offline-first Biometrics**.
> *   Established a robust **CI/CD-ready** environment with **Flavors (Dev/Prod)**, **Dependency Injection**, and rigorous **Unit/Integration Testing**.
> *   Optimized app performance using `flutter_screenutil` for responsive UI and `Hive` for low-latency local storage.
