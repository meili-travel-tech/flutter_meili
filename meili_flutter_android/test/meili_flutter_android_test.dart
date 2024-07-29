import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meili_flutter_android/meili_flutter_android.dart';
import 'package:meili_flutter_platform_interface/meili_flutter_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MeiliFlutterAndroid', () {
    const kPlatformName = 'Android';
    late MeiliFlutterAndroid meiliFlutter;
    late List<MethodCall> log;

    setUp(() async {
      meiliFlutter = MeiliFlutterAndroid();

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
      MeiliFlutterAndroid.registerWith();
      expect(MeiliFlutterPlatform.instance, isA<MeiliFlutterAndroid>());
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
