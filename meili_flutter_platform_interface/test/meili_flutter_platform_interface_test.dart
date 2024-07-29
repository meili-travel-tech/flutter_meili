import 'package:flutter_test/flutter_test.dart';
import 'package:meili_flutter_platform_interface/meili_flutter_platform_interface.dart';

class MeiliFlutterMock extends MeiliFlutterPlatform {
  static const mockPlatformName = 'Mock';

  @override
  Future<String?> getPlatformName() async => mockPlatformName;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('MeiliFlutterPlatformInterface', () {
    late MeiliFlutterPlatform meiliFlutterPlatform;

    setUp(() {
      meiliFlutterPlatform = MeiliFlutterMock();
      MeiliFlutterPlatform.instance = meiliFlutterPlatform;
    });

    group('getPlatformName', () {
      test('returns correct name', () async {
        expect(
          await MeiliFlutterPlatform.instance.getPlatformName(),
          equals(MeiliFlutterMock.mockPlatformName),
        );
      });
    });
  });
}
