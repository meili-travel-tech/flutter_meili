# Changelog

## 0.4.4

- BREAKING: removed the `MeiliView` embedded-widget platform view (`MeiliViewFactory`, `MeiliUIView`, `MeiliPlatformView`) and its `flutter_meili/meili_view` registration. `Meili.openMeiliView()` is now the only entry point on both platforms, matching Android since `meili_flutter_android 0.4.5-beta.2`.

## 0.4.3

- Bumped `MeiliSDK` to `1.7.2` (CocoaPods podspec and SwiftPM `Package.swift`).

## 0.4.2

- Bumped `MeiliSDK` to `1.7.1` (CocoaPods podspec and SwiftPM `Package.swift`).

## 0.4.1

- Point the SwiftPM `Package.swift` at the stable `ux-native-ios` 1.7.0 (was the 1.6.3 alpha), aligning the SwiftPM channel with the CocoaPods podspec.

## 0.4.0

- Stable release. Bumped `MeiliSDK` to `1.7.0`.

## 0.3.1-beta.4

- Bumped `MeiliSDK` to `1.6.3-alpha.10` on both channels (SwiftPM `ux-native-ios` pin and CocoaPods podspec).

## 0.3.1-beta.3

- Updated `meili_flutter_platform_interface` constraint to `^0.3.0`.

## 0.3.1-beta.2

- Updated license to proprietary.

## 0.3.1-beta.1

- Implemented `MeiliFlutterIos` with `registerWith()` for federated plugin registration.
- Unified method channel name to `meili_flutter`.
- Added `dartPluginClass` to pubspec for automatic platform registration.

## [0.1.0+1] - 2024-08-01

### Added

## [0.1.1] - 2024-08-01

### Added

## [0.1.2] - 2024-08-01

### Added
