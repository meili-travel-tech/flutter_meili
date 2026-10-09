# 1. Wrappers conform to the native SDKs

Date: 2026-10-09
Status: Accepted

MPD-11767 · Flutter host params and events conform to the native SDKs

## Context

The Flutter plugin grew its own host contract next to the SDKs': its own spellings for the
environment (`'pre_prod'` opened dev on iOS), its own blank and zero handling, its own date
format, and keys that one platform adapter read and the other ignored. The same Dart call opened
different funnels on iOS and Android, and SNCF integrates through Flutter. More wrappers (React
Native, Cordova) are expected, and each would repeat the drift.

## Decision

The native SDKs' public params and callbacks are the host contract, and the web app (meili-car) is
the reference for how the SDKs behave. A wrapper conforms to them:

- It maps keys one-to-one onto the SDK's params and callbacks, with the SDK's names and types.
- It does not normalise values. Empty-value rules, defaults and parsing live in the SDKs, once.
- It rejects what the SDK cannot represent, such as an unknown environment, with an error to the
  host instead of substituting a default.
- A change to the host contract is made in both SDKs first, then followed by the wrappers.

## Consequences

- The Flutter model carries the SDK's names. `MeiliCarEnv` mirrors `MeiliCarEnvironment`, and a
  value the SDKs do not accept is a compile error in Dart and a `PlatformException` over the
  channel.
- One channel fixture (`meili_flutter_car_platform_interface/test/fixtures/channel_contract.json`)
  is asserted from Dart, from the Android plugin's JVM tests and from the example app's
  `RunnerTests`, so drift between the three fails a test.
- A wrapper release depends on the SDK releases that carry the contract it exposes.
