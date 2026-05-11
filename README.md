# Date Navigation

Plan dates together, vote for places, and find a meeting point that works for both users.

---

## About

**Date Navigation** is a Flutter app for collaborative meeting planning:
- share room/session
- sync preferences between two users
- select meeting format
- find nearby places around a shared center
- vote or propose alternatives

The app is built with clean, feature-oriented architecture and real-time sync through Firebase.

## Features

- Real-time room collaboration for two users
- Meeting format selection and coordination flow
- Place discovery with filtering and quality checks
- Voting / proposing places with synchronized state
- Favorites and history
- Adaptive UI with map + control panel workflow

## Tech Stack

- **Framework:** Flutter (Dart)
- **State Management:** Riverpod
- **Backend:** Firebase (Auth, Firestore, Analytics, Crashlytics)
- **Architecture:** Feature-first + layered modules (`presentation`, `domain`, `data`)

## Project Structure

```text
lib/
  core/                     # shared services, error/result, theme, utils
  features/
    auth/                   # authentication feature
    account/                # account, favorites, history
    date_navigation/        # main collaborative planning flow
test/                       # unit and widget tests
docs/                       # architecture and feature docs
```

## Quick Start

### 1) Prerequisites

- Flutter SDK installed
- Xcode / Android Studio (for device builds)
- Firebase project configured

### 2) Install dependencies

```bash
flutter pub get
```

### 3) Run

```bash
flutter run
```

## Development Commands

```bash
flutter analyze
flutter test
flutter clean
```

## Firestore Room Cleanup

The project includes a maintenance script that removes expired room invites and
old completed rooms from Firestore:

```bash
cd scripts
npm ci
npm run cleanup:rooms
```

It can also run automatically through GitHub Actions. Configure these repository
secrets in GitHub (`Settings` -> `Secrets and variables` -> `Actions`):

- `FIREBASE_PROJECT_ID` - your Firebase project id
- `FIREBASE_SERVICE_ACCOUNT_JSON` - JSON key for a Firebase service account with
  Firestore access

The workflow `.github/workflows/cleanup-rooms.yml` runs every day at `03:00 UTC`
and can also be started manually from the Actions tab.

## Setup Firebase

To run the app with backend features (Auth, Firestore, Analytics, Crashlytics), connect your own Firebase project.

### 1) Create Firebase project

1. Open [Firebase Console](https://console.firebase.google.com/)
2. Create a new project
3. Enable:
   - Authentication (providers you need)
   - Cloud Firestore
   - Analytics (optional but recommended)
   - Crashlytics (optional but recommended)

### 2) Configure Android

1. Add Android app in Firebase with package name from:
   - `android/app/build.gradle.kts` (`applicationId`)
2. Download `google-services.json`
3. Put it here:
   - `android/app/google-services.json`

### 3) Configure iOS

1. Add iOS app in Firebase with bundle id from Xcode (`Runner` target)
2. Download `GoogleService-Info.plist`
3. Put it here:
   - `ios/Runner/GoogleService-Info.plist`

### 4) Regenerate Flutter Firebase config (recommended)

If you use FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This updates `lib/firebase_options.dart` for your Firebase project.

### 5) Validate setup

```bash
flutter pub get
flutter run
```

If Firebase setup is correct, the app should launch and backend-dependent flows should work.

## Roadmap Ideas

- Better onboarding UX for first-time users
- Extended analytics dashboard for meeting flow
- More place sources and recommendation signals

## License

This project currently has no license file. Add one if you plan public reuse.
