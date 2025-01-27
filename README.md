# We Care Mobile App

This project follows the **MVVM (Model-View-ViewModel)** architectural pattern to maintain a clean separation of concerns, promote scalability, and ensure testability.

---

## 🎨 System Design

The project structure is divided into the following layers:

1. **Core**: Contains essential modules like Dependency Injection (DI), Networking, Routing, Helpers, Theming, and Shared Widgets.
2. **Features**: Organized by app modules (e.g., Home). Each module has its own `Data`, `Logic`, and `UI` layers:
   - `Data`: Handles models and repositories.
   - `Logic`: Contains Cubits/States for managing the app's state.
   - `UI`: Includes screens and widgets for the module.

![System Design](https://github.com/user-attachments/assets/e77de8f2-6315-491c-b5dc-af1a81ae4e5e)

---

## 🌐 Localization

The app's localization is configured using the **Flutter Intl** package. This enables seamless support for multiple languages, including dynamic right-to-left (RTL) and left-to-right (LTR) layouts based on the user's selected language.

### How Localization Works:
. **Flutter Intl Integration**:
   - Localized strings are managed in `.arb` files (JSON-like files).
   - These files are automatically generated and mapped into the app, providing strong typing for translations.


## 🛠️ Packages Used

Here’s a list of the main packages used in this project and their purpose:

1. **State Management**:
   - [`flutter_bloc`](https://pub.dev/packages/flutter_bloc): For implementing the MVVM pattern with Cubit/Bloc for managing the app's state.

2. **Networking**:
   - [`dio`](https://pub.dev/packages/dio): A powerful HTTP client for making API requests.
   - [`retrofit`](https://pub.dev/packages/retrofit): Simplifies RESTful API integration by generating boilerplate code.

3. **Dependency Injection**:
   - [`get_it`](https://pub.dev/packages/get_it): For implementing dependency injection and service locator.

4. **Localization**:
   - [`flutter_intl`](https://pub.dev/packages/flutter_intl): For adding multi-language support with easy-to-use `.arb` files.

5. **UI and Theming**:
   - [`flutter_screenutil`](https://pub.dev/packages/flutter_screenutil): For adaptive screen sizes, ensuring responsive layouts across devices.
   - [`device_preview`](https://pub.dev/packages/device_preview): Allows previewing the app on different devices and locales during development.

6. **Others**:
   - [`equatable`](https://pub.dev/packages/equatable): Simplifies state comparison for Cubit/Bloc.
   - [`shared_preferences`](https://pub.dev/packages/shared_preferences): For storing user preferences locally (e.g., selected language).

---

## 💡 Features

- **Dynamic Language Switching**: Switch between languages (LTR and RTL) without restarting the app.
- **Scalable Architecture**: Based on the MVVM pattern to separate logic, UI, and data layers.
- **Responsive UI**: Adjusts layouts based on screen sizes using `flutter_screenutil`.