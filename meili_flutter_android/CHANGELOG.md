# Changelog

## 0.4.7

Stable release of the `0.4.7-beta.x` line.

- Updated Meili Android SDK dependency to 1.8.1.

## 0.4.7-beta.2

- Updated Meili Android SDK dependency to 1.8.1.

## 0.4.7-beta.1

- Updated Meili Android SDK dependency to 1.8.0.

## 0.4.6

- Removed the slide-up entrance transition added in `0.4.5-beta.1`. In practice it produced a black flash on some devices (the revealed/covered host activity surface isn't always redrawn in time around the transition) and interacted badly with back-press timing. `Meili.openMeiliView()` now opens with the plain system default transition; the flow itself is otherwise unaffected.

## 0.4.5-beta.2

- BREAKING: removed the Android platform view behind the retired `MeiliView` widget; `Meili.openMeiliView()` is the only Android entry point.
- Updated Meili Android SDK dependency to 1.7.2, which centralizes back handling: dismissing the flow via the system back button/gesture at the flow root now reliably invokes the dismiss callback, so `flowDismissed` is delivered for every back affordance (previously it was silently missed on system back — the root cause of the blank-host-page report in MPD-10997).

## 0.4.5-beta.1

- MPD-10997: present the Meili booking flow as a modal with a slide-up entrance, approximating iOS's page-sheet presentation. The host screen stays visible beneath the transition.
- Forward `bookingFlowEnded` through the `meili_flutter/events` channel (previously iOS-only).

## 0.4.3

- Updated Meili Android SDK dependency to 1.7.1. `1.7.0` was published from a commit that predated the material3 fix and did not actually contain it; `1.7.1` is the correct, verified fix — tested against host apps on Compose BOM 2026.01.01 (material3 1.4.0, compose-ui/foundation 1.10.2) with no `NoSuchMethodError`.

## 0.4.2

- Updated Meili Android SDK dependency to 1.7.0, fixing a `NoSuchMethodError` crash (`TopAppBarColors.copy`) on host apps resolving `androidx.compose.material3:material3` 1.4.0+. Built and tested against Compose BOM 2025.11.01 (material3 1.4.0, compose-ui 1.10.6).

## 0.4.0

- Stable release. Updated Meili Android SDK dependency to 1.6.9 (via public Maven repository).

## 0.3.0-beta.5

- Made the Android Gradle build compatible with Android Gradle Plugin 9 (new DSL) while keeping AGP 8 support, using property-assignment syntax (`compileSdk`, `minSdk`, `compose`, `namespace`) and the `packaging { jniLibs { pickFirsts } }` block.
- Bundled the Compose compiler plugin (`compose-compiler-gradle-plugin`) so host apps no longer need to declare `org.jetbrains.kotlin.plugin.compose` themselves.
- Stopped pinning the Android Gradle Plugin in the plugin buildscript; it is now inherited from the host app, which avoids AGP version conflicts on AGP 9 hosts.
- Resolve the Meili Android SDK from the public GitHub Pages Maven repository (`https://meili-travel-tech.github.io/ux-native-android/`); host apps no longer need GitHub Packages credentials (`MEILI_GITHUB_USERNAME` / `MEILI_GITHUB_TOKEN`).
- Updated the Meili Android SDK dependency to 1.6.8.

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
