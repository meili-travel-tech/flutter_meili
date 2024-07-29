import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart';
import 'package:meili_flutter_platform_interface/meili_flutter_platform_interface.dart';

/// An implementation of [MeiliFlutterPlatform] that uses method channels.
class MethodChannelMeiliFlutter extends MeiliFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('meili_flutter');

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
