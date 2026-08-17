import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meili_flutter_platform_interface/meili_flutter_platform_interface.dart';

class _MockMeiliFlutter extends MeiliFlutterPlatform {
  bool opened = false;
  bool poppedToRoot = false;
  bool funnelAvailabilityQueried = false;
  final StreamController<MeiliEvent> controller =
      StreamController<MeiliEvent>.broadcast();

  @override
  Future<void> openMeiliView(MeiliParams params) async {
    opened = true;
  }

  @override
  Stream<MeiliEvent> get events => controller.stream;

  @override
  Future<void> popToRoot() async {
    poppedToRoot = true;
  }

  @override
  Future<bool> nativeFunnelAvailable() async {
    funnelAvailabilityQueried = true;
    return false;
  }
}

/// Implements nothing beyond the required surface, so the base class's
/// `UnimplementedError` defaults are reachable.
class _BareMeiliFlutter extends MeiliFlutterPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MeiliFlutterPlatform', () {
    late _MockMeiliFlutter mock;

    setUp(() {
      mock = _MockMeiliFlutter();
      MeiliFlutterPlatform.instance = mock;
    });

    test('openMeiliView delegates to the instance', () async {
      await MeiliFlutterPlatform.instance.openMeiliView(
        MeiliParams(ptid: '1', flow: FlowType.direct, env: 'dev'),
      );
      expect(mock.opened, isTrue);
    });

    test('popToRoot delegates to the instance', () async {
      await MeiliFlutterPlatform.instance.popToRoot();
      expect(mock.poppedToRoot, isTrue);
    });

    test('nativeFunnelAvailable delegates to the instance', () async {
      final available =
          await MeiliFlutterPlatform.instance.nativeFunnelAvailable();
      expect(mock.funnelAvailabilityQueried, isTrue);
      expect(available, isFalse);
    });

    test('nativeFunnelAvailable throws UnimplementedError by default', () {
      expect(
        _BareMeiliFlutter().nativeFunnelAvailable,
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('events surfaces emitted MeiliEvents', () {
      expect(
        MeiliFlutterPlatform.instance.events,
        emitsInOrder(<Matcher>[
          isA<MeiliFlowDismissed>(),
          isA<MeiliAnalyticsEvent>(),
        ]),
      );
      mock.controller
        ..add(const MeiliFlowDismissed())
        ..add(const MeiliAnalyticsEvent(name: 'screen_viewed'));
    });
  });
}
