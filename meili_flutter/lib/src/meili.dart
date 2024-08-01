import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:meili_flutter/src/model/meili_params.dart';

class Meili {
  static const MethodChannel _iosChannel = MethodChannel('meili_flutter_ios');
  static const MethodChannel _androidChannel =
      MethodChannel('meili_flutter_android');

  /// Opens the Meili view with the given parameters.
  ///
  /// [params] The parameters required to open the Meili view.
  static Future<void> openMeiliView(MeiliParams params) async {
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await _iosChannel.invokeMethod(
          'openMeiliViewController',
          params.toMap(),
        );
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        // Placeholder for Android until the native implementation is available

        throw PlatformException(
          code: 'UNSUPPORTED_PLATFORM',
          message: 'Android platform view is not yet supported',
        );
      } else {}
    } on PlatformException catch (e) {
      print("Failed to open MeiliView: '${e.message}'.");
    }
  }
}
