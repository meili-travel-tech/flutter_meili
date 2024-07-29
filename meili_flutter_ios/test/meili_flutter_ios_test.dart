import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meili_flutter_ios/meili_flutter_ios.dart';
import 'package:meili_flutter_platform_interface/meili_flutter_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MeiliFlutterIOS', () {
    const kPlatformName = 'iOS';
    late MeiliFlutterIOS meiliFlutter;
    late List<MethodCall> log;

    setUp(() async {
      meiliFlutter = MeiliFlutterIOS();

      log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(meiliFlutter.methodChannel, (methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'getPlatformName':
            return kPlatformName;
          default:
            return null;
        }
      });
    });

    test('can be registered', () {
      MeiliFlutterIOS.registerWith();
      expect(MeiliFlutterPlatform.instance, isA<MeiliFlutterIOS>());
    });

    test('getPlatformName returns correct name', () async {
      final name = await meiliFlutter.getPlatformName();
      expect(
        log,
        <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      );
      expect(name, equals(kPlatformName));
    });
  });
}
