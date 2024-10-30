import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meili_flutter/meili_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockMethodChannel extends Mock implements MethodChannel {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const iosChannel = MethodChannel('meili_flutter_ios');
  const androidChannel = MethodChannel('meili_flutter_android');

  setUpAll(() {
    // Register fallback values for MethodCall to avoid errors
    registerFallbackValue(const MethodCall(''));
  });

  group('Meili', () {
    setUp(() {
      // Reset the mock channels before each test
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(iosChannel, null);
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(androidChannel, null);
    });

    test('openMeiliView on iOS invokes correct method', () async {
      final params = MeiliParams(
        ptid: '100.10',
        currentFlow: FlowType.bookingManager,
        env: 'dev',
      );

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(iosChannel, (MethodCall methodCall) async {
        expect(methodCall.method, 'openMeiliViewController');
        expect(methodCall.arguments, params.toMap());
        return null;
      });

      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      await Meili.openMeiliView(params);
    });

    tearDown(() {
      debugDefaultTargetPlatformOverride = null;
    });
  });
}
