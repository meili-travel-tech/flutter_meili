/// Search criteria to prefill the Meili Direct flow. Every field is optional;
/// anything left out keeps the funnel's own default.
class AvailParams {
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
  });

  final String? pickupLocation;
  final String? dropoffLocation;
  final String? pickupDate;
  final String? pickupTime;
  final String? dropoffDate;
  final String? dropoffTime;
  final DateTime? pickupDateTime;
  final DateTime? dropoffDateTime;
  final int? driverAge;
  final String? currencyCode;
  final String? residency;

  Map<String, dynamic> toMap() {
    return {
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'pickupDate': pickupDate,
      'pickupTime': pickupTime,
      'dropoffDate': dropoffDate,
      'dropoffTime': dropoffTime,
      'pickupDateTime': pickupDateTime?.toIso8601String(),
      'dropoffDateTime': dropoffDateTime?.toIso8601String(),
      'driverAge': driverAge,
      'currencyCode': currencyCode,
      'residency': residency,
    };
  }
}
