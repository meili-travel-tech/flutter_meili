import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meili_flutter_platform_interface/src/method_channel_meili_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const kPlatformName = 'platformName';

  group('$MethodChannelMeiliFlutter', () {
    late MethodChannelMeiliFlutter methodChannelMeiliFlutter;
    final log = <MethodCall>[];

    setUp(() async {
      methodChannelMeiliFlutter = MethodChannelMeiliFlutter();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        methodChannelMeiliFlutter.methodChannel,
        (methodCall) async {
          log.add(methodCall);
          switch (methodCall.method) {
            case 'getPlatformName':
              return kPlatformName;
            default:
              return null;
          }
        },
      );
    });

    tearDown(log.clear);

    test('getPlatformName', () async {
      final platformName = await methodChannelMeiliFlutter.getPlatformName();
      expect(
        log,
        <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      );
      expect(platformName, equals(kPlatformName));
    });
  });
}
