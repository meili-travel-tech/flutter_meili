import 'package:meili_flutter_platform_interface/src/model/meili_event.dart';
import 'package:meili_flutter_platform_interface/src/model/meili_params.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_meili_flutter.dart';

abstract class MeiliFlutterPlatform extends PlatformInterface {
  MeiliFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static MeiliFlutterPlatform _instance = MethodChannelMeiliFlutter();

  static MeiliFlutterPlatform get instance => _instance;

  static set instance(MeiliFlutterPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Presents the Meili UI modally.
  Future<void> openMeiliView(MeiliParams params) {
    throw UnimplementedError('openMeiliView() has not been implemented.');
  }

  /// A broadcast stream of [MeiliEvent]s emitted by the native SDK
  /// (lifecycle events plus forwarded analytics).
  Stream<MeiliEvent> get events {
    throw UnimplementedError('events has not been implemented.');
  }

  /// Invokes the SDK's retained `popToRoot` action, typically in response to a
  /// [MeiliBookingFlowEnded] event. No-op if there is nothing to pop.
  Future<void> popToRoot() {
    throw UnimplementedError('popToRoot() has not been implemented.');
  }

  /// Whether the native booking funnel can render on this device — `false` on
  /// iOS 15, always `true` on Android. Device capability, not configuration.
  Future<bool> nativeFunnelAvailable() {
    throw UnimplementedError('nativeFunnelAvailable() has not been implemented.');
  }
}
