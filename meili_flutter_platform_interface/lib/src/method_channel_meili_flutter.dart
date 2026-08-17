import 'package:flutter/services.dart';

import 'meili_flutter_platform_interface.dart';
import 'model/meili_event.dart';
import 'model/meili_params.dart';

/// Default [MeiliFlutterPlatform] implementation, shared by all platforms
/// (iOS and Android use the same channel and method names). Platform packages
/// only provide native code; they do not override this Dart layer.
class MethodChannelMeiliFlutter extends MeiliFlutterPlatform {
  static const _channel = MethodChannel('meili_flutter');
  static const _eventChannel = EventChannel('meili_flutter/events');

  Stream<MeiliEvent>? _events;

  @override
  Future<void> openMeiliView(MeiliParams params) {
    return _channel.invokeMethod('openMeiliViewController', params.toMap());
  }

  @override
  Stream<MeiliEvent> get events {
    return _events ??= _eventChannel
        .receiveBroadcastStream()
        .map((dynamic event) =>
            MeiliEvent.fromMap(Map<String, dynamic>.from(event as Map)))
        .asBroadcastStream();
  }

  @override
  Future<void> popToRoot() {
    return _channel.invokeMethod('popToRoot');
  }
}
