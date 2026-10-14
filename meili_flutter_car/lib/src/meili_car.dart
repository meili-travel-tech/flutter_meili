import 'package:meili_flutter_car_platform_interface/meili_flutter_car_platform_interface.dart';

/// Entry point for driving the MeiliCar SDK and observing its events.
class MeiliCar {
  /// Presents the MeiliCar UI modally using [params].
  static Future<void> open(MeiliCarParams params) {
    return MeiliCarFlutterPlatform.instance.open(params);
  }

  /// A broadcast stream of [MeiliCarEvent]s emitted by the native SDK:
  /// lifecycle events ([MeiliCarFlowDismissed], [MeiliCarBookingFlowEnded]),
  /// booking success ([MeiliCarBookingSucceeded]), SDK failures
  /// ([MeiliCarErrorEvent]) and forwarded analytics ([MeiliCarAnalyticsEvent]).
  ///
  /// Events emitted before the first listener subscribes are dropped.
  /// Both platforms forward every event except analytics, which is currently
  /// iOS-only. [MeiliCarBookingSucceeded] fires once per booking, right after
  /// the reservation succeeds, with the same payload keys on both platforms.
  /// [MeiliCarBookingFlowEnded] is a notification only — the SDK resets itself
  /// to its own search panel immediately after this event; no host action is
  /// required.
  static Stream<MeiliCarEvent> get events =>
      MeiliCarFlutterPlatform.instance.events;
}
