import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:meili_flutter_platform_interface/meili_flutter_platform_interface.dart';

/// The iOS implementation of [MeiliFlutterPlatform].
class MeiliFlutterIOS extends MeiliFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('meili_flutter_ios');

  /// Registers this class as the default instance of [MeiliFlutterPlatform]
  static void registerWith() {
    MeiliFlutterPlatform.instance = MeiliFlutterIOS();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
