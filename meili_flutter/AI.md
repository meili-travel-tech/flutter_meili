# meili_flutter AI Notes

Purpose: App-facing Dart package for the Meili Flutter plugin.

Key APIs
- Meili.openMeiliView(MeiliParams) uses MethodChannel `meili_flutter_ios` / `meili_flutter_android`.
- MeiliConnectWidget embeds the iOS platform view `flutter_meili/meili_view`.

Models
- MeiliParams: ptid, flow (FlowType), env, availParams, additionalParams.
- AvailParams: pickup/dropoff info, dates/times, driverAge, currency, residency.
- AdditionalParams: booking/customer details.

Notes
- Android is now supported via `meili_flutter_android` (GitHub Packages
  `meili.travel:ux-native-android-sdk`). `Meili.openMeiliView` dispatches to
  the `meili_flutter_android` channel and `MeiliConnectWidget` embeds the
  `flutter_meili/meili_view` PlatformView via `AndroidView`.
- Docs should reference `flow` (not `currentFlow`) to match MeiliParams.
