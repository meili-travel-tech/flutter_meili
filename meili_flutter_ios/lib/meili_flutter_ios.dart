import 'package:flutter/services.dart';
import 'package:meili_flutter_platform_interface/meili_flutter_platform_interface.dart';

class MeiliFlutterIos extends MeiliFlutterPlatform {
  static const _channel = MethodChannel('meili_flutter');

  static void registerWith() {
    MeiliFlutterPlatform.instance = MeiliFlutterIos();
  }

  @override
  Future<void> openMeiliView(MeiliParams params) {
    return _channel.invokeMethod('openMeiliViewController', params.toMap());
  }
}
