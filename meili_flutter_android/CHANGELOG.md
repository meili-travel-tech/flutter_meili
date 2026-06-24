# Changelog

## 0.3.0-beta.5

- Made the Android Gradle build compatible with Android Gradle Plugin 9 (new DSL) while keeping AGP 8 support, using property-assignment syntax (`compileSdk`, `minSdk`, `compose`, `namespace`) and the `packaging { jniLibs { pickFirsts } }` block.
- Bundled the Compose compiler plugin (`compose-compiler-gradle-plugin`) so host apps no longer need to declare `org.jetbrains.kotlin.plugin.compose` themselves.
- Stopped pinning the Android Gradle Plugin in the plugin buildscript; it is now inherited from the host app, which avoids AGP version conflicts on AGP 9 hosts.

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
