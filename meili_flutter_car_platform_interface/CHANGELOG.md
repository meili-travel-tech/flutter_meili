## Unreleased

- **Breaking:** `MeiliCarParams.env` is now a `MeiliCarEnv` (`prod`, `preProd`, `uat`, `dev`) instead of a `String`, sent over the channel as its name. Replace `env: 'prod'` with `env: MeiliCarEnv.prod`; the old `'pre_prod'` spelling becomes `MeiliCarEnv.preProd`. There is no string alias (MPD-11767).
- **Breaking:** `AdditionalParams.supplierLoyaltyAccounts` is now a `List<SupplierLoyaltyAccount>` (new, `customerAccount` required, `supplierName` optional) instead of a `List<String>`, and `phoneNumbers` is a `List<String>` in international format with a leading `+` instead of a `List<int>`. `AdditionalParams` gains `givenName` and `corporateCode`. Replace `supplierLoyaltyAccounts: ['123']` with `[SupplierLoyaltyAccount(customerAccount: '123')]` and `phoneNumbers: [353871234567]` with `['+353871234567']`. There are no aliases for the old types (MPD-11767).
- **Breaking:** `AvailParams.toMap` no longer sends `pickupDateTime`/`dropoffDateTime`. A `DateTime` is split into `pickupDate` (`yyyy-MM-dd`) and `pickupTime` (`HH:mm`), and the same for drop-off, so both SDKs parse it; setting a `DateTime` together with its separate strings is an assertion error. `toMap` on `MeiliCarParams`, `AvailParams` and `AdditionalParams` now leaves out null entries only and passes blanks and a `driverAge` of 0 through: the SDKs treat them as unset (MPD-11767).

## 0.6.0

- **New (breaking for exhaustive switches):** `MeiliCarErrorEvent`, a `MeiliCarEvent` forwarding SDK-internal failures (config,
  availability, costs, checkout, reservation, partner-content requests) reported by the native
  SDK's `onError` callback. Carries `area` (`MeiliCarErrorArea`), `kind` (`MeiliCarErrorKind`),
  an optional `httpCode`, and a release-safe `message`. Both enums fall back to `unknown` for a
  value a future native SDK might send that this version doesn't yet model (MPD-10790).
- Doc-only: corrects the `popToRoot` and `MeiliCarBookingFlowEnded` doc
  comments, which told hosts to call `popToRoot`. The SDK resets itself to
  its search panel on its own; `popToRoot` is kept only for older app
  packages that still call it (MPD-11466).

## 0.5.0

- **Renamed from `meili_flutter_platform_interface`** (MPD-11470). `MeiliFlutterPlatform` →
  `MeiliCarFlutterPlatform`, `MethodChannelMeiliFlutter` → `MethodChannelMeiliCarFlutter`,
  `MeiliParams` → `MeiliCarParams`, `MeiliEvent` → `MeiliCarEvent` (and its subclasses), and
  `openMeiliView(...)` → `open(...)` on both the platform interface and the method-channel
  implementation. `AvailParams`, `AdditionalParams`, `BookingParams` and `FlowType` are unchanged.
  Method/event channel names change internally: `meili_flutter` → `meili_flutter_car`,
  `meili_flutter/events` → `meili_flutter_car/events`. `meili_flutter_platform_interface` 0.4.x
  stays published and frozen.

## 0.4.1

- Added `discountRequested` and `partnerLoyaltyAccountTier` to `AvailParams`. They pre-tick the
  partner discount and loyalty card checkboxes on the search panel, and are carried to the native
  SDKs on the request's `partnerParams`. Both are optional, so existing code is unaffected.

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
