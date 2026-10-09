# meili_flutter_car_platform_interface AI Notes

Purpose: Platform interface package for the federated `meili_flutter_car` plugin.

Notes
- Both `meili_flutter_car_ios` and `meili_flutter_car_android` contribute native code only; the
  default `MethodChannelMeiliCarFlutter` implementation here (channel `meili_flutter_car`, event
  channel `meili_flutter_car/events`) is shared by both platforms.
- Models: `MeiliCarParams`, `AvailParams`, `AdditionalParams` (`BookingParams` is a deprecated
  alias), `SupplierLoyaltyAccount`, `FlowType`, `MeiliCarEnv`, `MeiliCarEvent` and its subclasses.
- `test/fixtures/channel_contract.json` is the one channel-message fixture (`params` holds the
  canonical `MeiliCarParams.toMap()` output). The Dart tests, the Android plugin's JVM tests and
  the example's iOS `RunnerTests` all read it by repo path; extend it, never copy it. See
  `docs/adr/0001-wrappers-conform-to-the-native-sdks.md`.
