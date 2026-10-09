import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:meili_flutter_car_platform_interface/meili_flutter_car_platform_interface.dart';

Map<String, dynamic> _fixtureEvent(String name) {
  final root = jsonDecode(
    File('test/fixtures/channel_contract.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  return (root['events'] as Map<String, dynamic>)[name] as Map<String, dynamic>;
}

void main() {
  group('MeiliCarEvent.fromMap', () {
    test('error tolerates a non-int httpCode', () {
      final fractional = MeiliCarEvent.fromMap({
        'type': 'error',
        'area': 'costs',
        'kind': 'http',
        'httpCode': 503.0,
        'message': 'costs request failed: HTTP 503',
      }) as MeiliCarErrorEvent;
      expect(fractional.httpCode, 503);

      final textual = MeiliCarEvent.fromMap({
        'type': 'error',
        'area': 'costs',
        'kind': 'http',
        'httpCode': '503',
        'message': 'costs request failed: HTTP 503',
      }) as MeiliCarErrorEvent;
      expect(textual.httpCode, isNull);
    });

    test('parses flowDismissed', () {
      expect(
        MeiliCarEvent.fromMap({'type': 'flowDismissed'}),
        isA<MeiliCarFlowDismissed>(),
      );
    });

    test('parses bookingFlowEnded', () {
      expect(
        MeiliCarEvent.fromMap({'type': 'bookingFlowEnded'}),
        isA<MeiliCarBookingFlowEnded>(),
      );
    });

    test('parses every fixture event map to its typed variant', () {
      expect(_fixtureEvent('flowDismissed'), isA<Map<String, dynamic>>());
      expect(
        MeiliCarEvent.fromMap(_fixtureEvent('flowDismissed')),
        isA<MeiliCarFlowDismissed>(),
      );
      expect(
        MeiliCarEvent.fromMap(_fixtureEvent('bookingFlowEnded')),
        isA<MeiliCarBookingFlowEnded>(),
      );
      final error =
          MeiliCarEvent.fromMap(_fixtureEvent('error')) as MeiliCarErrorEvent;
      expect(error.area, MeiliCarErrorArea.costs);
      expect(error.kind, MeiliCarErrorKind.http);
      expect(error.httpCode, 503);
      expect(error.message, 'costs request failed: HTTP 503');
      final analytics = MeiliCarEvent.fromMap(_fixtureEvent('analytics'))
          as MeiliCarAnalyticsEvent;
      expect(analytics.name, 'screen_viewed');
      expect(analytics.properties, {'screen_name': 'search'});
    });

    test('parses the fixture bookingSucceeded event', () {
      final map = _fixtureEvent('bookingSucceeded');

      final event = MeiliCarEvent.fromMap(map);

      expect(event, isA<MeiliCarBookingSucceeded>());
      final reservation = (event as MeiliCarBookingSucceeded).reservation;
      expect(reservation, map['reservation']);
      expect(reservation['confirmationId'], isNotNull);
      expect(reservation['meiliSessionId'], isNotNull);
      expect(event.toMap(), map);
    });

    test('bookingSucceeded rebuilds nested maps as Map<String, dynamic>', () {
      final event = MeiliCarEvent.fromMap(const {
        'type': 'bookingSucceeded',
        'reservation': <Object?, Object?>{
          'confirmationId': 'ABC',
          'drivers': [
            <Object?, Object?>{'firstName': 'Ada'},
          ],
          'isPrepaid': false,
          'execTime': 12,
          'notes': null,
        },
      }) as MeiliCarBookingSucceeded;

      expect(event.reservation['confirmationId'], 'ABC');
      expect(event.reservation['isPrepaid'], false);
      expect(event.reservation['execTime'], 12);
      expect(event.reservation['notes'], isNull);
      final drivers = event.reservation['drivers'] as List<dynamic>;
      final driver = drivers.single as Map<String, dynamic>;
      expect(driver['firstName'], 'Ada');
    });

    test(
        'bookingSucceeded with a missing, null or wrong-typed reservation '
        'still decodes with an empty reservation', () {
      final maps = <Map<String, dynamic>>[
        {'type': 'bookingSucceeded'},
        {'type': 'bookingSucceeded', 'reservation': null},
        {'type': 'bookingSucceeded', 'reservation': 'x'},
        {'type': 'bookingSucceeded', 'reservation': 42},
        {
          'type': 'bookingSucceeded',
          'reservation': ['a'],
        },
      ];

      for (final map in maps) {
        final event = MeiliCarEvent.fromMap(map);

        expect(event, isA<MeiliCarBookingSucceeded>(), reason: '$map');
        expect((event as MeiliCarBookingSucceeded).reservation, isEmpty);
      }
    });

    test('parses analytics with name and properties', () {
      final event = MeiliCarEvent.fromMap({
        'type': 'analytics',
        'name': 'screen_viewed',
        'properties': {'screen_name': 'home'},
      });
      expect(event, isA<MeiliCarAnalyticsEvent>());
      final analytics = event as MeiliCarAnalyticsEvent;
      expect(analytics.name, 'screen_viewed');
      expect(analytics.properties['screen_name'], 'home');
    });

    test('analytics defaults properties to empty when missing', () {
      final event = MeiliCarEvent.fromMap({'type': 'analytics', 'name': 'x'})
          as MeiliCarAnalyticsEvent;
      expect(event.properties, isEmpty);
    });

    test('well-formed unknown type becomes MeiliCarUnknownEvent', () {
      final event = MeiliCarEvent.fromMap({'type': 'somethingNew', 'foo': 1});
      expect(event, isA<MeiliCarUnknownEvent>());
      final unknown = event as MeiliCarUnknownEvent;
      expect(unknown.type, 'somethingNew');
      expect(unknown.raw['foo'], 1);
    });

    test('analytics without a name falls back to unknown', () {
      expect(
        MeiliCarEvent.fromMap({'type': 'analytics'}),
        isA<MeiliCarUnknownEvent>(),
      );
    });

    test('missing type throws FormatException', () {
      expect(
        () => MeiliCarEvent.fromMap({'foo': 'bar'}),
        throwsA(isA<FormatException>()),
      );
    });

    test('parses a full error event', () {
      final event = MeiliCarEvent.fromMap({
        'type': 'error',
        'area': 'checkout',
        'kind': 'http',
        'httpCode': 502,
        'message': 'checkout request failed: HTTP 502',
      });
      expect(event, isA<MeiliCarErrorEvent>());
      final error = event as MeiliCarErrorEvent;
      expect(error.area, MeiliCarErrorArea.checkout);
      expect(error.kind, MeiliCarErrorKind.http);
      expect(error.httpCode, 502);
      expect(error.message, 'checkout request failed: HTTP 502');
    });

    test('parses an error event with a null httpCode', () {
      final event = MeiliCarEvent.fromMap({
        'type': 'error',
        'area': 'availability',
        'kind': 'network',
        'httpCode': null,
        'message': 'no connectivity',
      }) as MeiliCarErrorEvent;
      expect(event.httpCode, isNull);
    });

    test('parses an error event with a missing httpCode', () {
      final event = MeiliCarEvent.fromMap({
        'type': 'error',
        'area': 'config',
        'kind': 'decode',
        'message': 'malformed config response',
      }) as MeiliCarErrorEvent;
      expect(event.httpCode, isNull);
    });

    test('parses every error area and kind', () {
      const areas = {
        'config': MeiliCarErrorArea.config,
        'availability': MeiliCarErrorArea.availability,
        'costs': MeiliCarErrorArea.costs,
        'checkout': MeiliCarErrorArea.checkout,
        'reservation': MeiliCarErrorArea.reservation,
        'partnerContent': MeiliCarErrorArea.partnerContent,
      };
      const kinds = {
        'network': MeiliCarErrorKind.network,
        'http': MeiliCarErrorKind.http,
        'decode': MeiliCarErrorKind.decode,
        'unexpected': MeiliCarErrorKind.unexpected,
      };
      for (final areaEntry in areas.entries) {
        for (final kindEntry in kinds.entries) {
          final event = MeiliCarEvent.fromMap({
            'type': 'error',
            'area': areaEntry.key,
            'kind': kindEntry.key,
            'message': 'm',
          }) as MeiliCarErrorEvent;
          expect(event.area, areaEntry.value);
          expect(event.kind, kindEntry.value);
        }
      }
    });

    test('an unrecognised error area falls back to unknown', () {
      final event = MeiliCarEvent.fromMap({
        'type': 'error',
        'area': 'somethingNew',
        'kind': 'network',
        'message': 'm',
      }) as MeiliCarErrorEvent;
      expect(event.area, MeiliCarErrorArea.unknown);
    });

    test('an unrecognised error kind falls back to unknown', () {
      final event = MeiliCarEvent.fromMap({
        'type': 'error',
        'area': 'config',
        'kind': 'somethingNew',
        'message': 'm',
      }) as MeiliCarErrorEvent;
      expect(event.kind, MeiliCarErrorKind.unknown);
    });

    test('an error event missing area, kind and message is still an error',
        () {
      final event = MeiliCarEvent.fromMap(const {'type': 'error', 'httpCode': 500});

      expect(event, isA<MeiliCarErrorEvent>());
      event as MeiliCarErrorEvent;
      expect(event.area, MeiliCarErrorArea.unknown);
      expect(event.kind, MeiliCarErrorKind.unknown);
      expect(event.httpCode, 500);
      expect(event.message, '');
    });

    test('non-string error fields decode as unknown and empty', () {
      final event = MeiliCarEvent.fromMap(const {
        'type': 'error',
        'area': 1,
        'kind': null,
        'message': 42,
      }) as MeiliCarErrorEvent;

      expect(event.area, MeiliCarErrorArea.unknown);
      expect(event.kind, MeiliCarErrorKind.unknown);
      expect(event.message, '');
    });
  });

  group('MeiliCarEvent.toMap', () {
    test('round-trips each variant', () {
      expect(const MeiliCarFlowDismissed().toMap(), {'type': 'flowDismissed'});
      expect(
        const MeiliCarBookingFlowEnded().toMap(),
        {'type': 'bookingFlowEnded'},
      );
      expect(
        const MeiliCarBookingSucceeded(reservation: {'confirmationId': 'ABC'})
            .toMap(),
        {
          'type': 'bookingSucceeded',
          'reservation': {'confirmationId': 'ABC'},
        },
      );
      expect(
        const MeiliCarAnalyticsEvent(name: 'e', properties: {'a': 1}).toMap(),
        {
          'type': 'analytics',
          'name': 'e',
          'properties': {'a': 1},
        },
      );
      expect(
        const MeiliCarErrorEvent(
          area: MeiliCarErrorArea.checkout,
          kind: MeiliCarErrorKind.http,
          httpCode: 502,
          message: 'm',
        ).toMap(),
        {
          'type': 'error',
          'area': 'checkout',
          'kind': 'http',
          'httpCode': 502,
          'message': 'm',
        },
      );
    });
  });
}
