# meili_flutter_car_ios AI Notes

Purpose: iOS implementation of the Meili Flutter Car plugin.

Key code
- FlutterMethodChannel: `meili_flutter_car` in `MeiliFlutterPlugin`. FlutterEventChannel:
  `meili_flutter_car/events` in `MeiliEventDispatcher`.
- UIKit wrapper: `MeiliViewController` embeds SwiftUI `MeiliCarView` from `MeiliCarSDK`, via the
  plugin-internal `MeiliWrapperView`.
- `MeiliWrapperView` sets the SDK's `dismissAction`, `onEndBookingFlow` (argument-less) and
  `onBookingSucceeded`; the last decodes its reservation JSON with `bookingSucceededEvent(reservationJson:)`
  (an undecodable or non-object body gives an empty `reservation`) and sends `bookingSucceeded`.
- `MeiliFlutterAnalyticsProvider` registers with `MeiliCarAnalytics.shared.addProvider(_:)` and
  forwards every SDK analytics event to Dart through `MeiliEventDispatcher`.
- Swift sources live in `ios/meili_flutter_car_ios/Sources/meili_flutter_car_ios/`. Both build
  systems compile this one copy.

Tests
- Swift Testing tests live in the example app's `RunnerTests` target
  (`meili_flutter_car/example/ios/RunnerTests/`) and read the platform interface's channel fixture
  by repo path. Run from `meili_flutter_car/example/ios` after `flutter pub get` and
  `flutter build ios --config-only --simulator`: `xcodebuild test -workspace Runner.xcworkspace
  -scheme Runner -destination 'id=<simulator UDID>' -only-testing:RunnerTests`.

Build systems (both supported)
- CocoaPods: `ios/meili_flutter_car_ios.podspec` (default path). `source_files`
  points at the shared `Sources/` dir; depends on `MeiliCarSDK` from the
  meili-ios-pods spec repo.
- SwiftPM: `ios/meili_flutter_car_ios/Package.swift` (used when the host app runs
  `flutter config --enable-swift-package-manager`). Depends on `MeiliCarSDK` via the
  `ux-native-ios` binary package. `Flutter` is injected by Flutter tooling and is
  NOT declared as a SwiftPM dependency.
- Both channels pin the SAME version and resolve the SAME
  `MeiliCarSDK.xcframework.zip` (the meili-ios-pods podspec sources the ux-native-ios
  release zip). Read the current version off the two files rather than from this
  doc, and keep the two pins in lockstep when bumping — the podspec pins an exact
  version while `Package.swift` uses `from:`, so they can silently diverge.
- iOS 15.0 floor (both channels).
