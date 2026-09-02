## 0.4.0

- **Breaking:** every `AvailParams` field is now optional. Previously all of them were required, which
  forced integrators to pass `''` and `0` for values they did not want to set; the native SDKs then
  treated those placeholders as real values. Pass only the fields you want to prefill. Existing code
  that passes every field keeps working unchanged.

## 0.3.0

- Bumped to 0.3.0 to align with federated plugin versioning.

## 0.2.1

- Updated license to proprietary.

## 0.2.0

- Replaced `getPlatformName()` with `openMeiliView(MeiliParams)` as the core platform API.
- Added `MeiliParams`, `AvailParams`, `BookingParams`, and `FlowType` models.
- Implemented `MethodChannelMeiliFlutter` as the default channel implementation.
- Unified method channel name to `meili_flutter`.

## 0.1.0

- Initial release.
