# Pickleball App

A modern Flutter application designed for **Pickleball** enthusiasts. The app provides a smooth and interactive platform for players to join matches, connect with other players, participate in tournaments, and track their rankings - all designed to enhance the pickleball community experience.

## Quick Overview

- **Create Room**: Home → Create Room (1vs1, 2vs2) → Detail Room
- **Play**: 
  - Match Room → Detail Room → Score Room
  - Detail Room → Invite Friends → Score Room
- **Tournament**: Create Tournament (Admin) → User Participants → Detail Room → Score Room

## Features

- **Authentication**:
  + User registration and login
  + Role-based access (Player, Sponsor, Admin)
  + Profile management
  
- **Room Management**:
  + Create Room: 1vs1, 2vs2 matches
  + Quick Match: Automatic player matching
  + Match Details: Room information, player invitations, scoring system
  
- **Match History**:
  + Upcoming matches
  + Completed games with results
  
- **Ranking System**:
  + Player rankings based on match performance
  + Leaderboards
  
- **Tournament Management**:
  + Tournament creation and registration
  + Participant management
  + Bracket system
  
- **Club Features**:
  + Training ground information
  + Coaching services
  + Club membership
  
- **Rules & Resources**:
  + Official pickleball rules
  + Gameplay instructions
  
- **Notifications**:
  + Friend requests
  + Match invitations
  + Tournament updates

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Project Setup

### Prerequisites

- Flutter SDK: [Install Flutter](https://docs.flutter.dev/get-started/install)
- Dart SDK: Included with Flutter
- Android Studio or Visual Studio Code: [Install Android Studio](https://developer.android.com/studio)
  or [Install Visual Studio Code](https://code.visualstudio.com/)
- Flutter SDK: `>=3.6.0`
- Dart SDK: `>=3.4.1`
- Android/iOS device/emulator for testing
-

### Installation

1. Clone the repository:

   ```sh
   git clone https://github.com/Pickleball-Team/pickleball-app.git
   cd pickleball-app
   ```

2. Install dependencies:
   ```sh
   flutter pub get
   ```

3. Run the app:
   ```sh
   flutter run
   ```

### Direct APK Installation

For users who want to install the app directly without building from source:

1. Download the release APK from:
   [Download](https://github.com/Pickleball-Team/pickleball-app/raw/refs/heads/main/assets/release/app-release.apk)

2. Transfer the APK to your Android device

3. On your Android device, navigate to the APK file location and tap on it to install
   - You may need to enable "Install from Unknown Sources" in your device settings

4. Follow the on-screen instructions to complete the installation

## Architecture

The app is structured using BLoC (Business Logic Component) pattern and follows Clean Architecture principles.

## Key Components

- AppBloc: Manages global app states (e.g., app initialization and authentication status).
- AuthenticationBloc: Handles user authentication.
- RoomBloc: Manages Pickleball game rooms.
- Theme: Allows users to toggle between Light and Dark themes.
- Routing: Uses auto_route for defining routes with nested navigation.

## Dependencies

The app uses the following main dependencies:

- flutter_bloc: State management for clean separation of business logic.
- firebase_core, firebase_auth: Firebase integration for authentication.

- flutter_animate, animations: Animated UI components for smooth user interactions.

- auto_route: For navigation between screens.

- flutter_secure_storage: To securely store sensitive information such as tokens.

- json_annotation, json_serializable: For efficient JSON serialization.

- intl: For internationalization and formatting.

## Contributions


Feel free to submit issues, pull requests, or suggestions!
