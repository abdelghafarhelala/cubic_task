# Firebase Setup Guide

This guide will help you set up Firebase for the Secure Banking Branch Locator app.

## Prerequisites

- A Google account
- Firebase CLI installed (optional, but recommended)
- Android Studio (for Android setup)
- Xcode (for iOS setup)

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"** or **"Create a project"**
3. Enter project name: `cubic-banking-app` (or your preferred name)
4. Disable Google Analytics (optional, you can enable it later)
5. Click **"Create project"**
6. Wait for the project to be created, then click **"Continue"**

## Step 2: Add Android App

1. In Firebase Console, click the **Android icon** (or **"Add app"** → **Android**)
2. Enter Android package name: `com.example.cubic_task`
   - You can find this in `android/app/build.gradle` under `applicationId`
3. Enter App nickname (optional): `Cubic Banking Android`
4. Enter Debug signing certificate SHA-1 (optional for now)
5. Click **"Register app"**
6. Download the `google-services.json` file
7. Place the file in: `android/app/google-services.json`
   ```bash
   # The file should be at:
   android/app/google-services.json
   ```

## Step 3: Add iOS App

1. In Firebase Console, click the **iOS icon** (or **"Add app"** → **iOS**)
2. Enter iOS bundle ID: `com.example.cubicTask`
   - You can find this in `ios/Runner.xcodeproj` or `ios/Runner/Info.plist`
   - Check `ios/Runner/Info.plist` for `CFBundleIdentifier`
3. Enter App nickname (optional): `Cubic Banking iOS`
4. Enter App Store ID (optional, leave blank for now)
5. Click **"Register app"**
6. Download the `GoogleService-Info.plist` file
7. Place the file in: `ios/Runner/GoogleService-Info.plist`
   ```bash
   # The file should be at:
   ios/Runner/GoogleService-Info.plist
   ```

## Step 4: Enable Authentication

1. In Firebase Console, go to **Authentication** (left sidebar)
2. Click **"Get started"** (if first time)
3. Click on the **"Sign-in method"** tab
4. Click on **"Email/Password"**
5. Enable **"Email/Password"** toggle
6. Click **"Save"**

## Step 5: Enable Firestore Database

1. In Firebase Console, go to **Firestore Database** (left sidebar)
2. Click **"Create database"**
3. Choose **"Start in test mode"** (for development)
4. Select a location (choose closest to your users)
5. Click **"Enable"**

### Important: Update Firestore Security Rules

After creating the database, go to **Rules** tab and update with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own favorites
    match /favorites/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Users can only read/write their own user data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

Click **"Publish"** to save the rules.

## Step 6: Update Android Configuration

The Android configuration has already been updated in the project. Verify:

1. **android/build.gradle** - Should have Google Services classpath
2. **android/app/build.gradle** - Should apply Google Services plugin

If you need to update manually, see the configuration files in the project.

## Step 7: Update iOS Configuration

The iOS configuration is ready. The `GoogleService-Info.plist` file you downloaded will be automatically included.

## Step 8: Verify Setup

1. Run the app:
   ```bash
   flutter run
   ```

2. Try to sign up with a new account
3. Check Firebase Console → Authentication → Users (should see your test user)

## Troubleshooting

### Android Issues

**Error: "google-services.json not found"**
- Make sure `google-services.json` is in `android/app/` directory
- Verify the file name is exactly `google-services.json` (case-sensitive)

**Error: "Package name mismatch"**
- Verify the package name in `google-services.json` matches `com.example.cubic_task`
- Check `android/app/build.gradle` → `applicationId`

### iOS Issues

**Error: "GoogleService-Info.plist not found"**
- Make sure `GoogleService-Info.plist` is in `ios/Runner/` directory
- In Xcode, right-click on `Runner` folder → "Add Files to Runner" → Select the file

**Error: "Bundle ID mismatch"**
- Verify the bundle ID in `GoogleService-Info.plist` matches your iOS bundle ID
- Check `ios/Runner/Info.plist` → `CFBundleIdentifier`

### Authentication Issues

**Error: "Email/Password sign-in is disabled"**
- Go to Firebase Console → Authentication → Sign-in method
- Enable Email/Password provider

**Error: "Invalid API key"**
- Make sure you downloaded the correct `google-services.json` and `GoogleService-Info.plist`
- Re-download from Firebase Console if needed

## Next Steps

Once Firebase is set up:
1. ✅ Authentication is ready
2. ✅ Firestore is ready for favorites sync
3. Ready to proceed with Phase 2: Network & High Performance

## Additional Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Setup](https://firebase.flutter.dev/docs/overview)
- [Firebase Console](https://console.firebase.google.com/)




