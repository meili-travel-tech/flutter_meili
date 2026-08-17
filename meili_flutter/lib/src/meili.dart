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
}
