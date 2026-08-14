import 'package:meili_flutter_platform_interface/meili_flutter_platform_interface.dart';

/// Entry point for driving the Meili SDK and observing its events.
class Meili {
  /// Presents the Meili UI modally using [params].
  static Future<void> openMeiliView(MeiliParams params) {
    return MeiliFlutterPlatform.instance.openMeiliView(params);
  }

  /// A broadcast stream of [MeiliEvent]s emitted by the native SDK:
  /// lifecycle events ([MeiliFlowDismissed], [MeiliBookingFlowEnded]) and
  /// forwarded analytics ([MeiliAnalyticsEvent]).
  ///
  /// Events emitted before the first listener subscribes are dropped.
  /// Currently sourced from iOS only; on Android the stream is open but
  /// emits nothing until the Android native layer forwards events.
  static Stream<MeiliEvent> get events => MeiliFlutterPlatform.instance.events;

  /// Invokes the SDK's retained `popToRoot` action — typically called by the
  /// host in response to a [MeiliBookingFlowEnded] event. No-op if there is
  /// nothing to pop.
  static Future<void> popToRoot() => MeiliFlutterPlatform.instance.popToRoot();

  /// Whether the native booking funnel can render on this device.
  ///
  /// `false` on iOS 15, where [openMeiliView] falls back to the web funnel in
  /// an in-app browser. Use it to route somewhere of your own — or, usually the
  /// better experience, to not show the entry point at all:
  ///
  /// ```dart
  /// if (await Meili.nativeFunnelAvailable()) {
  ///   await Meili.openMeiliView(params);
  /// }
  /// ```
  ///
  /// Answers **device capability**, not configuration: `true` does not promise
  /// the partner's config will load.
  static Future<bool> nativeFunnelAvailable() =>
      MeiliFlutterPlatform.instance.nativeFunnelAvailable();
}
