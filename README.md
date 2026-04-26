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

## Firebase Notes

For full functionality, platform Firebase configs are required:
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

## Roadmap Ideas

- Better onboarding UX for first-time users
- Extended analytics dashboard for meeting flow
- More place sources and recommendation signals

## License

This project currently has no license file. Add one if you plan public reuse.
