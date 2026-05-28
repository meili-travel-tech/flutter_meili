import 'package:meili_flutter_platform_interface/meili_flutter_platform_interface.dart';

class Meili {
  static Future<void> openMeiliView(MeiliParams params) {
    return MeiliFlutterPlatform.instance.openMeiliView(params);
  }
}
