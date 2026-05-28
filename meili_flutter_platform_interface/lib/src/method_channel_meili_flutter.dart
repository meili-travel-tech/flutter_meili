import 'package:flutter/services.dart';

import 'meili_flutter_platform_interface.dart';
import 'model/meili_params.dart';

class MethodChannelMeiliFlutter extends MeiliFlutterPlatform {
  static const _channel = MethodChannel('meili_flutter');

  @override
  Future<void> openMeiliView(MeiliParams params) {
    return _channel.invokeMethod('openMeiliViewController', params.toMap());
  }
}
