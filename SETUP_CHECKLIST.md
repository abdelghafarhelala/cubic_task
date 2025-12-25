# Firebase Setup Checklist

Use this checklist to ensure Firebase is properly configured before testing the app.

## ✅ Pre-Setup

- [ ] Have a Google account ready
- [ ] Access to [Firebase Console](https://console.firebase.google.com/)

## ✅ Step 1: Create Firebase Project

- [ ] Go to Firebase Console
- [ ] Click "Add project" or "Create a project"
- [ ] Enter project name (e.g., `cubic-banking-app`)
- [ ] Choose whether to enable Google Analytics (optional)
- [ ] Click "Create project"
- [ ] Wait for project creation
- [ ] Click "Continue"

## ✅ Step 2: Add Android App

- [ ] In Firebase Console, click Android icon or "Add app" → Android
- [ ] Enter package name: `com.example.cubic_task`
- [ ] Enter app nickname (optional): `Cubic Banking Android`
- [ ] Click "Register app"
- [ ] **Download `google-services.json`**
- [ ] **Place file in: `android/app/google-services.json`**
- [ ] Verify file exists: `ls android/app/google-services.json`

## ✅ Step 3: Add iOS App

- [ ] In Firebase Console, click iOS icon or "Add app" → iOS
- [ ] Enter bundle ID: `com.example.cubicTask`
- [ ] Enter app nickname (optional): `Cubic Banking iOS`
- [ ] Click "Register app"
- [ ] **Download `GoogleService-Info.plist`**
- [ ] **Place file in: `ios/Runner/GoogleService-Info.plist`**
- [ ] Verify file exists: `ls ios/Runner/GoogleService-Info.plist`

## ✅ Step 4: Enable Authentication

- [ ] Go to Firebase Console → Authentication
- [ ] Click "Get started" (if first time)
- [ ] Click "Sign-in method" tab
- [ ] Click "Email/Password"
- [ ] **Enable "Email/Password" toggle**
- [ ] Click "Save"

## ✅ Step 5: Enable Firestore Database

- [ ] Go to Firebase Console → Firestore Database
- [ ] Click "Create database"
- [ ] Choose "Start in test mode"
- [ ] Select location (closest to your users)
- [ ] Click "Enable"
- [ ] Go to "Rules" tab
- [ ] **Update security rules** (see FIREBASE_SETUP.md)
- [ ] Click "Publish"

## ✅ Step 6: Verify Configuration Files

### Android
- [ ] File exists: `android/app/google-services.json`
- [ ] File contains correct package name: `com.example.cubic_task`
- [ ] `android/build.gradle` has Google Services classpath
- [ ] `android/app/build.gradle` applies Google Services plugin

### iOS
- [ ] File exists: `ios/Runner/GoogleService-Info.plist`
- [ ] File contains correct bundle ID: `com.example.cubicTask`
- [ ] File is added to Xcode project (if using Xcode)

## ✅ Step 7: Test the Setup

- [ ] Run `flutter pub get`
- [ ] Run `flutter clean` (optional, but recommended)
- [ ] Run `flutter run`
- [ ] App launches without Firebase errors
- [ ] Try to sign up with a new email
- [ ] Check Firebase Console → Authentication → Users
- [ ] Verify new user appears in Firebase Console

## ✅ Troubleshooting

If you encounter issues:

- [ ] Verify package name/bundle ID matches Firebase configuration
- [ ] Check that `google-services.json` and `GoogleService-Info.plist` are in correct locations
- [ ] Ensure Email/Password authentication is enabled
- [ ] Verify Firestore database is created
- [ ] Check Firebase Console for any error messages
- [ ] Review [FIREBASE_SETUP.md](./FIREBASE_SETUP.md) for detailed troubleshooting

## ✅ Ready for Phase 2

Once all items are checked:
- [ ] Firebase project created
- [ ] Android app configured
- [ ] iOS app configured
- [ ] Authentication enabled
- [ ] Firestore database created
- [ ] App runs successfully
- [ ] Can sign up/sign in

**You're ready to proceed with Phase 2: Network & High Performance! 🚀**




