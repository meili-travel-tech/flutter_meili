# meili_flutter_car AI Notes

Purpose: App-facing Dart package for the Meili Flutter Car plugin.

Key APIs
- `MeiliCar.open(MeiliCarParams)` calls through to the shared
  `MethodChannelMeiliCarFlutter` (channel `meili_flutter_car`) in
  `meili_flutter_car_platform_interface`; both platform packages contribute
  native code only, no per-platform Dart override.
- `MeiliCar.events` is a broadcast `Stream<MeiliCarEvent>` sourced from the
  `meili_flutter_car/events` EventChannel — lifecycle events
  (`MeiliCarFlowDismissed`, `MeiliCarBookingFlowEnded`), booking success
  (`MeiliCarBookingSucceeded`, the raw reservation response plus `meiliSessionId`) plus
  forwarded analytics (`MeiliCarAnalyticsEvent`) and SDK failures (`MeiliCarErrorEvent`,
  from the native `onError`). Both platforms forward the lifecycle, booking-success and error
  events; forwarded analytics events are iOS-only for now — see
  `meili_flutter_car_android/AI.md`.
- There is no `popToRoot`: the SDK resets itself to its search panel on its own after
  `MeiliCarBookingFlowEnded`.

Models (`meili_flutter_car_platform_interface`)
- `MeiliCarParams`: ptid, flow (`FlowType`), env (`MeiliCarEnv`), availParams, additionalParams.
- `AvailParams`: pickup/dropoff info, dates/times (or a `DateTime` per leg, split into date and time strings in Dart), driverAge, currency, residency — every field optional.
- `AdditionalParams`: booking/customer details (`BookingParams` is a deprecated alias).
- `MeiliCarEvent`: sealed hierarchy — `MeiliCarFlowDismissed`, `MeiliCarBookingFlowEnded`, `MeiliCarBookingSucceeded`, `MeiliCarAnalyticsEvent`, `MeiliCarErrorEvent`, `MeiliCarUnknownEvent`.
