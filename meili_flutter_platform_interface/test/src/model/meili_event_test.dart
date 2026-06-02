import 'package:flutter_test/flutter_test.dart';
import 'package:meili_flutter_platform_interface/meili_flutter_platform_interface.dart';

void main() {
  group('MeiliEvent.fromMap', () {
    test('parses flowDismissed', () {
      expect(
        MeiliEvent.fromMap({'type': 'flowDismissed'}),
        isA<MeiliFlowDismissed>(),
      );
    });

    test('parses bookingFlowEnded', () {
      expect(
        MeiliEvent.fromMap({'type': 'bookingFlowEnded'}),
        isA<MeiliBookingFlowEnded>(),
      );
    });

    test('parses analytics with name and properties', () {
      final event = MeiliEvent.fromMap({
        'type': 'analytics',
        'name': 'screen_viewed',
        'properties': {'screen_name': 'home'},
      });
      expect(event, isA<MeiliAnalyticsEvent>());
      final analytics = event as MeiliAnalyticsEvent;
      expect(analytics.name, 'screen_viewed');
      expect(analytics.properties['screen_name'], 'home');
    });

    test('analytics defaults properties to empty when missing', () {
      final event = MeiliEvent.fromMap({'type': 'analytics', 'name': 'x'})
          as MeiliAnalyticsEvent;
      expect(event.properties, isEmpty);
    });

    test('well-formed unknown type becomes MeiliUnknownEvent', () {
      final event = MeiliEvent.fromMap({'type': 'somethingNew', 'foo': 1});
      expect(event, isA<MeiliUnknownEvent>());
      final unknown = event as MeiliUnknownEvent;
      expect(unknown.type, 'somethingNew');
      expect(unknown.raw['foo'], 1);
    });

    test('analytics without a name falls back to unknown', () {
      expect(
        MeiliEvent.fromMap({'type': 'analytics'}),
        isA<MeiliUnknownEvent>(),
      );
    });

    test('missing type throws FormatException', () {
      expect(
        () => MeiliEvent.fromMap({'foo': 'bar'}),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('MeiliEvent.toMap', () {
    test('round-trips each variant', () {
      expect(const MeiliFlowDismissed().toMap(), {'type': 'flowDismissed'});
      expect(
        const MeiliBookingFlowEnded().toMap(),
        {'type': 'bookingFlowEnded'},
      );
      expect(
        const MeiliAnalyticsEvent(name: 'e', properties: {'a': 1}).toMap(),
        {
          'type': 'analytics',
          'name': 'e',
          'properties': {'a': 1},
        },
      );
    });
  });
}
