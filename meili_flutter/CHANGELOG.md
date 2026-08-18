# Changelog

## 0.4.8

Stable release of the `0.4.8-beta.x` line.

- **iOS 15 is now supported.** `meili_flutter_ios` lowers its deployment target to 15.0 (MPD-11195). A host app must also lower its own `IPHONEOS_DEPLOYMENT_TARGET` to 15.0 to inherit this. On iOS 15 the native funnel cannot render, so `Meili.openMeiliView()` presents the web funnel automatically — no host code required, and `Meili.events` still delivers analytics and `MeiliFlowDismissed` as usual. Android and iOS 16+ are unaffected.
- Bumped `meili_flutter_ios` to `^0.4.5` (MeiliSDK 1.9.3) and `meili_flutter_android` to `^0.4.7` (Meili Android SDK 1.8.1).
- The iOS funnel now takes its display language from the device instead of the host app's declared localisations, so a stock Flutter project no longer forces English (MPD-11229).

## 0.4.8-beta.4

- Removed `Meili.nativeFunnelAvailable()`, added in `0.4.8-beta.3`. It shipped against a `meili_flutter_platform_interface` change that was never published, so `0.4.8-beta.3` fails to compile for every consumer. The API was informational only — `openMeiliView()` already falls back to the web funnel on iOS 15 on its own, so nothing about the fallback changes. Hosts that want to vary their own UI on iOS 15 can check the OS version directly.
- Bumped `meili_flutter_ios` dependency to `^0.4.5-beta.4`.

## 0.4.8-beta.3

- Bumped `meili_flutter_ios` dependency to `^0.4.5-beta.3` (MeiliSDK 1.9.3). The iOS funnel now takes its display language from the device instead of the host app's declared localisations, so a stock Flutter project no longer forces English (MPD-11229).

## 0.4.8-beta.2

- Bumped `meili_flutter_android` dependency to `^0.4.7-beta.2` (Meili Android SDK 1.8.1) and `meili_flutter_ios` dependency to `^0.4.5-beta.2` (MeiliSDK 1.9.2).

## 0.4.8-beta.1

- Bumped `meili_flutter_android` dependency to `^0.4.7-beta.1` (Meili Android SDK 1.8.0) and `meili_flutter_ios` dependency to `^0.4.5-beta.1` (MeiliSDK 1.8.0).

## 0.4.7

- BREAKING: the `MeiliView` embedded-widget class is removed from the public API entirely (bumped `meili_flutter_ios` dependency to `^0.4.4`). `Meili.openMeiliView()` is now the only way to present the booking flow on both platforms. Android already threw `UnsupportedError` for `MeiliView` since `0.4.5-beta.2`; iOS's previously-working inline embedding is retired for API symmetry and to keep a single, documented integration path (MPD-10997).
- README updated: the "Embedded widget" section is removed; "Full-screen modal" is now the only usage section.

## 0.4.6

- Bumped `meili_flutter_android` dependency to `^0.4.6`, which removes the slide-up entrance transition on Android (it caused a black flash on some devices). `Meili.openMeiliView()` now opens with the plain system default transition.

## 0.4.5-beta.2

- BREAKING (Android): the `MeiliView` widget now throws `UnsupportedError` on Android with migration guidance. It never rendered inline there — it launched the full-screen flow as a side effect and left a blank host page on return. Use `Meili.openMeiliView()` from your UI action instead. iOS behaviour unchanged.
- MPD-10997: via `meili_flutter_android` `0.4.5-beta.2` (Meili Android SDK 1.7.2), dismissing the flow from every back affordance (app-bar chevron, back button, back gesture) now reliably emits `MeiliFlowDismissed` on `Meili.events`. Previously the system back button at the flow root dismissed silently.

## 0.4.5-beta.1

- MPD-10997: `Meili.openMeiliView()` on Android presents the booking flow as a slide-up modal over the current screen.
- `bookingFlowEnded` is now delivered on `Meili.events` on Android as well as iOS.

## 0.4.4

- Bumped `meili_flutter_ios` dependency to `^0.4.3` (MeiliSDK 1.7.2).

## 0.4.3

- Bumped `meili_flutter_android` dependency to `^0.4.3`. `0.4.2` referenced Android SDK `1.7.0`, which was published from a stale commit and did not actually contain the material3 fix; `0.4.3` pulls in the verified `1.7.1`.

## 0.4.2

- Bumped `meili_flutter_android` dependency to `^0.4.2`, fixing a `NoSuchMethodError` crash on host apps resolving `androidx.compose.material3:material3` 1.4.0+.

- Bumped `meili_flutter_ios` dependency to `^0.4.2` (MeiliSDK 1.7.1).


## 0.4.1

- Bumped `meili_flutter_ios` dependency to `^0.4.0`.

## 0.4.0

- Stable release. Bumped `meili_flutter_android` dependency to `^0.4.0` and `meili_flutter_ios` dependency to `^0.4.0`.

## 0.3.1-beta.5

- Bumped `meili_flutter_android` dependency to `^0.3.0-beta.5` (Android Gradle Plugin 9 compatibility and a bundled Compose compiler plugin).

## 0.3.1-beta.4

- Bumped `meili_flutter_android` dependency to `^0.3.0-beta.3`.

## 0.3.1-beta.3

- Migrated to federated plugin architecture using `meili_flutter_platform_interface`.
- `Meili.openMeiliView()` now delegates to the platform interface instance.
- Exported `MeiliParams`, `AvailParams`, `BookingParams`, `FlowType` from the platform interface.

## [0.1.0+1] - 2024-08-01

### Added

## [0.1.1] - 2024-08-02

### Added

## [0.1.2] - 2024-08-02

### Added

## [0.2.0] - 2024-10-30

### Added

## [0.3.0] - 2024-10-30

### Added
