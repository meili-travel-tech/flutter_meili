import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:meili_flutter_platform_interface/meili_flutter_platform_interface.dart';

/// The Android implementation of [MeiliFlutterPlatform].
class MeiliFlutterAndroid extends MeiliFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('meili_flutter_android');

  /// Registers this class as the default instance of [MeiliFlutterPlatform]
  static void registerWith() {
    MeiliFlutterPlatform.instance = MeiliFlutterAndroid();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
