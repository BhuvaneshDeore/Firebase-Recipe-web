# Firebase Recipe App (Flutter)

This is a starter Flutter app demonstrating CRUD operations with Firebase Firestore.

## Setup (quick)
1. Install Flutter SDK and ensure `flutter` is in your PATH.
2. Open this folder in VS Code or your IDE.
3. Run `flutter pub get`.

## Firebase configuration (required)
You must connect this app to a Firebase project:

### Android / iOS (native)
- Create a Firebase project at https://console.firebase.google.com
- Add an Android app and download `google-services.json` to `android/app/`
- Add an iOS app and download `GoogleService-Info.plist` to `ios/Runner/`
- (Optional) Run `flutterfire configure` to auto-generate `lib/firebase_options.dart`

### Web
- Generate `firebase_options.dart` via `flutterfire configure` or manually provide FirebaseOptions in `main.dart`.

After Firebase is configured, run the app with `flutter run` (choose an emulator or device).

This starter includes:
- `lib/main.dart`
- `lib/screens/home_screen.dart`
- `lib/screens/add_edit_recipe.dart`
- `lib/screens/recipe_detail.dart`
- `lib/models/recipe.dart`

Firestore collection used: `recipes`
Each document fields: `title` (string), `ingredients` (array), `instructions` (string), `imageUrl` (string)