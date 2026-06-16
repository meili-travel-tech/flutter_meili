# Changelog

## 0.3.0-beta.3

- Updated Android SDK dependency to 1.6.1.
- Switched to public `com.meili.travel.api` imports for `AvailParams`, `AdditionalParams`, and `MeiliComposeListener`.
- Replaced direct `MeiliCompose` usage in `MeiliPlatformView` with `MeiliActivity.start()` to work with the published SDK.
- Fixed nullable `AvailParams` handling when calling `MeiliActivity.start()`.
- Removed `mavenLocal()` from Gradle repositories.

## 0.3.0-beta.2

- Updated license to proprietary.

## 0.3.0-beta.1

- Implemented `MeiliFlutterAndroid` with `registerWith()` for federated plugin registration.
- Unified method channel name to `meili_flutter`.
- Added `dartPluginClass` to pubspec for automatic platform registration.

## [0.1.0+1] - 2024-08-01

### Added

## [0.1.1] - 2024-08-02

### Added
