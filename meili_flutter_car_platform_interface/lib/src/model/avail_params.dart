/// Search criteria to prefill the MeiliCar Direct flow. Every field is optional;
/// anything left out keeps the funnel's own default.
///
/// The native SDKs treat a blank string (empty or whitespace only) and a
/// non-positive [driverAge] as unset. The plugin passes them through as given.
class AvailParams {
  /// Creates search criteria.
  ///
  /// Set the pickup either through [pickupDateTime] or through [pickupDate]
  /// and [pickupTime], never both; the same goes for the drop-off.
  AvailParams({
    this.pickupLocation,
    this.dropoffLocation,
    this.pickupDate,
    this.pickupTime,
    this.dropoffDate,
    this.dropoffTime,
    this.driverAge,
    this.currencyCode,
    this.residency,
    this.pickupDateTime,
    this.dropoffDateTime,
    this.discountRequested,
    this.partnerLoyaltyAccountTier,
  }) : assert(
         pickupDateTime == null || (pickupDate == null && pickupTime == null),
         'Set pickupDateTime or pickupDate/pickupTime, not both.',
       ),
       assert(
         dropoffDateTime == null ||
             (dropoffDate == null && dropoffTime == null),
         'Set dropoffDateTime or dropoffDate/dropoffTime, not both.',
       );

  final String? pickupLocation;
  final String? dropoffLocation;

  /// Pickup date as `yyyy-MM-dd`. Exclusive with [pickupDateTime].
  final String? pickupDate;

  /// Pickup time as `HH:mm`. Exclusive with [pickupDateTime].
  final String? pickupTime;

  /// Drop-off date as `yyyy-MM-dd`. Exclusive with [dropoffDateTime].
  final String? dropoffDate;

  /// Drop-off time as `HH:mm`. Exclusive with [dropoffDateTime].
  final String? dropoffTime;

  /// Pickup as a wall-clock date and time. It never crosses the channel:
  /// [toMap] writes its fields as `pickupDate` and `pickupTime`, in the
  /// `DateTime`'s own time zone with no conversion.
  final DateTime? pickupDateTime;

  /// Drop-off counterpart of [pickupDateTime].
  final DateTime? dropoffDateTime;

  /// Driver age in years. The SDKs treat 0 or less as unset.
  final int? driverAge;
  final String? currencyCode;
  final String? residency;

  /// Pre-ticks the partner discount checkbox on the search panel, when the
  /// partner has one configured.
  final bool? discountRequested;

  /// Pre-ticks the partner loyalty card checkbox on the search panel, when the
  /// partner declares a single loyalty tier. Pass the tier value itself, for
  /// example `CARD`.
  final String? partnerLoyaltyAccountTier;

  /// The channel map: null entries are left out, blanks and zeros are kept.
  Map<String, dynamic> toMap() {
    final pickup = pickupDateTime;
    final dropoff = dropoffDateTime;
    return <String, dynamic>{
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'pickupDate': pickup == null ? pickupDate : _date(pickup),
      'pickupTime': pickup == null ? pickupTime : _time(pickup),
      'dropoffDate': dropoff == null ? dropoffDate : _date(dropoff),
      'dropoffTime': dropoff == null ? dropoffTime : _time(dropoff),
      'driverAge': driverAge,
      'currencyCode': currencyCode,
      'residency': residency,
      'discountRequested': discountRequested,
      'partnerLoyaltyAccountTier': partnerLoyaltyAccountTier,
    }..removeWhere((_, value) => value == null);
  }
}

String _pad(int value, int width) => value.toString().padLeft(width, '0');

String _date(DateTime value) =>
    '${_pad(value.year, 4)}-${_pad(value.month, 2)}-${_pad(value.day, 2)}';

String _time(DateTime value) =>
    '${_pad(value.hour, 2)}:${_pad(value.minute, 2)}';
