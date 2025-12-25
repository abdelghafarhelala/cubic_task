# Secure Banking Branch Locator

Flutter Technical Assessment - A secure banking application with branch/ATM locator functionality.

## Features

- ✅ Firebase Authentication (Email/Password)
- ✅ Biometric Authentication (Face ID/Touch ID)
- ✅ Secure Dashboard with Account & Credit Card Display
- ✅ Recent Transactions List
- 🔄 Network & High Performance (Phase 2 - In Progress)
- 🔄 Offline-First with Encrypted Local Storage (Phase 3 - Planned)

## Prerequisites

Before running this app, you need to:

1. **Set up Firebase Project** - See [FIREBASE_SETUP.md](./FIREBASE_SETUP.md) for detailed instructions
2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

## Quick Firebase Setup Checklist

- [ ] Create Firebase project at [Firebase Console](https://console.firebase.google.com/)
- [ ] Add Android app with package name: `com.example.cubic_task`
- [ ] Download `google-services.json` → Place in `android/app/`
- [ ] Add iOS app with bundle ID: `com.example.cubicTask`
- [ ] Download `GoogleService-Info.plist` → Place in `ios/Runner/`
- [ ] Enable Email/Password authentication in Firebase Console
- [ ] Create Firestore database (test mode for development)
- [ ] Update Firestore security rules (see FIREBASE_SETUP.md)

## Project Structure

```
lib/
├── core/              # Core utilities, theme, constants
├── data/              # Data layer (models, repositories, data sources)
│   ├── datasources/   # Remote and local data sources
│   ├── models/       # Data models
│   └── repositories/ # Repository implementations
└── presentation/      # UI layer
    ├── bloc/         # State management (Cubit)
    ├── screens/      # App screens
    └── widgets/      # Reusable widgets
```

## Running the App

```bash
# Get dependencies
flutter pub get

# Run on connected device/emulator
flutter run

# Build APK (Android)
flutter build apk --release
```

## Architecture

- **State Management**: Flutter Bloc (Cubit) with enum-based states
- **Architecture Pattern**: Clean Architecture (Data & Presentation layers)
- **Authentication**: Firebase Auth
- **Local Storage**: SQLite with SQLCipher (encrypted)
- **Network**: Dio
- **Maps**: Google Maps Flutter

## Important Notes

⚠️ **Before Testing:**
1. Complete Firebase setup (see FIREBASE_SETUP.md)
2. Ensure `google-services.json` and `GoogleService-Info.plist` are in place
3. Enable Email/Password authentication in Firebase Console

## Development Phases

- ✅ **Phase 0**: Project Setup & Dependencies
- ✅ **Phase 1**: Authentication, Security & Dashboard
- 🔄 **Phase 2**: Network & High Performance (Next)
- ⏳ **Phase 3**: Local Storage & Privacy (Offline-First)

## Documentation

- [Firebase Setup Guide](./FIREBASE_SETUP.md) - Detailed Firebase configuration instructions

## License

This project is part of a technical assessment.
