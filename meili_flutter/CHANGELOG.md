# Changelog

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
