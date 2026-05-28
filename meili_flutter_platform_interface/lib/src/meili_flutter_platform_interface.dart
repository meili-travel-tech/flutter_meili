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

  Future<void> openMeiliView(MeiliParams params) {
    throw UnimplementedError('openMeiliView() has not been implemented.');
  }
}
