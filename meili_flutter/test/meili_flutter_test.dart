import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meili_flutter/meili_flutter.dart';
import 'package:meili_flutter_platform_interface/meili_flutter_platform_interface.dart';

class MockMeiliPlatform extends MeiliFlutterPlatform {
  MeiliParams? lastParams;
  Object? errorToThrow;

  @override
  Future<void> openMeiliView(MeiliParams params) async {
    if (errorToThrow != null) throw errorToThrow!;
    lastParams = params;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockMeiliPlatform mock;

  setUp(() {
    mock = MockMeiliPlatform();
    MeiliFlutterPlatform.instance = mock;
  });

  final params = MeiliParams(
    ptid: '100.10',
    flow: FlowType.direct,
    env: 'dev',
  );

  test('openMeiliView delegates to platform instance', () async {
    await Meili.openMeiliView(params);
    expect(mock.lastParams, params);
  });

  test('openMeiliView propagates PlatformException from native side', () {
    mock.errorToThrow =
        PlatformException(code: 'ERROR', message: 'native fail');
    expect(
      () => Meili.openMeiliView(params),
      throwsA(isA<PlatformException>()),
    );
  });

  test('unregistered platform throws MissingPluginException', () {
    MeiliFlutterPlatform.instance = MethodChannelMeiliFlutter();
    expect(
      () => Meili.openMeiliView(params),
      throwsA(isA<MissingPluginException>()),
    );
  });
}
