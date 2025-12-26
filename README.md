# Secure Banking Branch Locator

A Flutter application demonstrating secure banking features with branch/ATM locator functionality.

## Overview

This application implements a secure banking interface with authentication, encrypted local storage, and location-based services for finding nearby branches and ATMs.

## Features

- **Authentication**: Firebase Email/Password authentication with biometric support
- **Secure Dashboard**: Account and credit card information display
- **Branch Locator**: Interactive map with OpenStreetMap integration
- **Location Services**: GPS-based location detection and nearest branch finder
- **Offline Support**: Encrypted local storage with automatic sync
- **Security**: Code obfuscation, encrypted database, and secure storage

## Tech Stack

- **Framework**: Flutter
- **State Management**: Flutter Bloc (Cubit)
- **Architecture**: Clean Architecture
- **Authentication**: Firebase Auth
- **Database**: SQLite with SQLCipher (encrypted)
- **Maps**: Flutter Map (OpenStreetMap)
- **Network**: Dio

## Prerequisites

- Flutter SDK (3.6.2 or higher)
- Firebase project configured
- Android Studio / Xcode for platform-specific builds

## Setup

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Configure Firebase**:
   - Create a Firebase project
   - Add Android app (package: `com.example.cubic_task`)
   - Add iOS app (bundle ID: `com.example.cubicTask`)
   - Download configuration files:
     - `google-services.json` → `android/app/`
     - `GoogleService-Info.plist` → `ios/Runner/`
   - Enable Email/Password authentication in Firebase Console

3. **Run the application**:
   ```bash
   flutter run
   ```

## Building for Production

### Standard Release Build
```bash
flutter build apk --release
```

### Obfuscated Release Build (Recommended)
```bash
flutter build apk --release --obfuscate --split-debug-info=build/app/outputs/symbols --split-per-abi
```

This creates separate APKs for each CPU architecture:
- `app-arm64-v8a-release.apk` (~25MB) - Modern 64-bit devices
- `app-armeabi-v7a-release.apk` (~20MB) - 32-bit devices
- `app-x86_64-release.apk` (~26MB) - x86_64 devices/emulators

**Security Features**:
- Dart code obfuscation
- ProGuard/R8 minification and obfuscation
- Resource shrinking
- Debug symbol removal

## Project Structure

```
lib/
├── core/          # Utilities, theme, constants, services
├── data/          # Data layer
│   ├── datasources/   # Remote and local data sources
│   ├── models/       # Data models
│   └── repositories/ # Repository implementations
└── presentation/     # UI layer
    ├── bloc/         # State management
    ├── screens/      # App screens
    └── widgets/      # Reusable widgets
```

## Architecture

- **Clean Architecture**: Separation of concerns with data and presentation layers
- **State Management**: Flutter Bloc with Cubit pattern
- **Dependency Injection**: GetIt for service management
- **Offline-First**: Cache-first pattern with automatic sync

## Security

- Encrypted local database (SQLCipher)
- Secure storage for sensitive data
- Code obfuscation and minification
- ProGuard/R8 rules for Android native code
- Biometric authentication support

## License

This project is part of a technical assessment.
