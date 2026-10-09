import 'package:flutter_test/flutter_test.dart';
import 'package:meili_flutter_car_platform_interface/meili_flutter_car_platform_interface.dart';

void main() {
  test('a currency-only AvailParams sends only the currency', () {
    expect(AvailParams(currencyCode: 'EUR').toMap(), {'currencyCode': 'EUR'});
  });

  test('every field is carried when supplied', () {
    final map = AvailParams(
      pickupLocation: 'DUB',
      dropoffLocation: 'DUB',
      pickupDate: '2026-10-05',
      pickupTime: '10:00',
      dropoffDate: '2026-10-09',
      dropoffTime: '10:00',
      driverAge: 30,
      currencyCode: 'EUR',
      residency: 'IE',
      discountRequested: true,
      partnerLoyaltyAccountTier: 'CARD',
    ).toMap();

    expect(map, {
      'pickupLocation': 'DUB',
      'dropoffLocation': 'DUB',
      'pickupDate': '2026-10-05',
      'pickupTime': '10:00',
      'dropoffDate': '2026-10-09',
      'dropoffTime': '10:00',
      'driverAge': 30,
      'currencyCode': 'EUR',
      'residency': 'IE',
      'discountRequested': true,
      'partnerLoyaltyAccountTier': 'CARD',
    });
  });

  test('discountRequested: false is carried, not dropped as if unset', () {
    expect(AvailParams(discountRequested: false).toMap(), {
      'discountRequested': false,
    });
  });

  group('DateTime split', () {
    test('writes the date and time keys and never the DateTime keys', () {
      final map = AvailParams(
        pickupDateTime: DateTime(2026, 11, 5, 10, 30),
        dropoffDateTime: DateTime(2026, 11, 12, 16, 45),
      ).toMap();

      expect(map, {
        'pickupDate': '2026-11-05',
        'pickupTime': '10:30',
        'dropoffDate': '2026-11-12',
        'dropoffTime': '16:45',
      });
    });

    test('zero-pads single-digit month, day, hour and minute', () {
      final map = AvailParams(
        pickupDateTime: DateTime(2026, 1, 2, 3, 4),
        dropoffDateTime: DateTime(2026, 9, 8),
      ).toMap();

      expect(map['pickupDate'], '2026-01-02');
      expect(map['pickupTime'], '03:04');
      expect(map['dropoffDate'], '2026-09-08');
      expect(map['dropoffTime'], '00:00');
    });

    test('pads the year to four digits', () {
      final map = AvailParams(pickupDateTime: DateTime(987, 3, 4)).toMap();

      expect(map['pickupDate'], '0987-03-04');
    });

    test('formats a UTC DateTime by its own fields, without converting', () {
      final map = AvailParams(
        pickupDateTime: DateTime.utc(2026, 11, 5, 23, 59),
      ).toMap();

      expect(map['pickupDate'], '2026-11-05');
      expect(map['pickupTime'], '23:59');
    });

    test('a pickup DateTime leaves the drop-off strings alone', () {
      final map = AvailParams(
        pickupDateTime: DateTime(2026, 11, 5, 10, 30),
        dropoffDate: '2026-11-12',
        dropoffTime: '16:45',
      ).toMap();

      expect(map['pickupDate'], '2026-11-05');
      expect(map['dropoffDate'], '2026-11-12');
      expect(map['dropoffTime'], '16:45');
    });

    test('a DateTime together with its date string is an assertion error', () {
      expect(
        () => AvailParams(
          pickupDateTime: DateTime(2026, 11, 5, 10, 30),
          pickupDate: '2026-11-05',
        ),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => AvailParams(
          dropoffDateTime: DateTime(2026, 11, 12, 16, 45),
          dropoffDate: '2026-11-12',
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('a DateTime together with its time string is an assertion error', () {
      expect(
        () => AvailParams(
          pickupDateTime: DateTime(2026, 11, 5, 10, 30),
          pickupTime: '10:30',
        ),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => AvailParams(
          dropoffDateTime: DateTime(2026, 11, 12, 16, 45),
          dropoffTime: '16:45',
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('null omission only', () {
    test('blanks and zeros are passed through for the SDKs to normalise', () {
      final map = AvailParams(
        pickupLocation: '',
        dropoffLocation: '   ',
        pickupDate: '',
        pickupTime: ' ',
        currencyCode: '',
        residency: ' ',
        driverAge: 0,
        partnerLoyaltyAccountTier: ' ',
      ).toMap();

      expect(map, {
        'pickupLocation': '',
        'dropoffLocation': '   ',
        'pickupDate': '',
        'pickupTime': ' ',
        'currencyCode': '',
        'residency': ' ',
        'driverAge': 0,
        'partnerLoyaltyAccountTier': ' ',
      });
    });

    test('a negative driver age is passed through', () {
      expect(AvailParams(driverAge: -1).toMap(), {'driverAge': -1});
    });

    test('an empty AvailParams sends an empty map', () {
      expect(AvailParams().toMap(), isEmpty);
    });
  });
}
