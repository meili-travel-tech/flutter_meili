# meili_flutter_car_platform_interface AI Notes

Purpose: Platform interface package for the federated `meili_flutter_car` plugin.

Notes
- Both `meili_flutter_car_ios` and `meili_flutter_car_android` contribute native code only; the
  default `MethodChannelMeiliCarFlutter` implementation here (channel `meili_flutter_car`, event
  channel `meili_flutter_car/events`) is shared by both platforms.
- Models: `MeiliCarParams`, `AvailParams`, `AdditionalParams` (`BookingParams` is a deprecated
  alias), `FlowType`, `MeiliCarEnv`, `MeiliCarEvent` and its subclasses.
- `toMap` on the params models leaves out nulls only; `AvailParams` splits `pickupDateTime` /
  `dropoffDateTime` into `pickupDate`/`pickupTime` (and drop-off) and never sends the `DateTime`s.
  Blanks and zeros pass through: the SDKs own the empty-value rule.
- `test/fixtures/channel_contract.json` is the one channel-message fixture (`params` holds the
  canonical `MeiliCarParams.toMap()` output, `paramsBlank` a map of blanks and zeros that must
  reach the SDK params unchanged). The Dart tests, the Android plugin's JVM tests and
  the example's iOS `RunnerTests` all read it by repo path; extend it, never copy it. See
  `docs/adr/0001-wrappers-conform-to-the-native-sdks.md`.
