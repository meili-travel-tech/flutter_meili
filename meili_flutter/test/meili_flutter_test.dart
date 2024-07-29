import 'package:flutter_test/flutter_test.dart';
import 'package:meili_flutter/meili_flutter.dart';
import 'package:meili_flutter_platform_interface/meili_flutter_platform_interface.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMeiliFlutterPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements MeiliFlutterPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MeiliFlutter', () {
    late MeiliFlutterPlatform meiliFlutterPlatform;

    setUp(() {
      meiliFlutterPlatform = MockMeiliFlutterPlatform();
      MeiliFlutterPlatform.instance = meiliFlutterPlatform;
    });

    group('getPlatformName', () {
      test('returns correct name when platform implementation exists',
          () async {
        const platformName = '__test_platform__';
        when(
          () => meiliFlutterPlatform.getPlatformName(),
        ).thenAnswer((_) async => platformName);

        final actualPlatformName = await getPlatformName();
        expect(actualPlatformName, equals(platformName));
      });

      test('throws exception when platform implementation is missing',
          () async {
        when(
          () => meiliFlutterPlatform.getPlatformName(),
        ).thenAnswer((_) async => null);

        expect(getPlatformName, throwsException);
      });
    });
  });
}
