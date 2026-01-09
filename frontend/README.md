# MedShare (Flutter)

## Configure API base URL

The app uses `ApiClient` with a configurable base URL.

- Default: `http://localhost:5149/api`
- Override at build/run time:

```bash
# Android Emulator
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5149/api

# iOS Simulator / macOS / Windows / Linux desktop
flutter run --dart-define=API_BASE_URL=http://localhost:5149/api
```

## Notes

- **Auth header**: automatically added by `ApiClient` from secure storage.
- **Images/files**: server-hosted paths like `/Uploads/...` are converted to absolute URLs using `ApiClient.publicUrl(...)`.

## Run

```bash
flutter pub get
flutter run
```
