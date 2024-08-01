class AvailParams {
  final String pickupLocation;
  final String dropoffLocation;
  final DateTime pickupDateTime;
  final DateTime dropoffDateTime;
  final int driverAge;
  final String currencyCode;
  final String residency;

  AvailParams({
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.pickupDateTime,
    required this.dropoffDateTime,
    required this.driverAge,
    required this.currencyCode,
    required this.residency,
  });

  Map<String, dynamic> toMap() {
    return {
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'pickupDateTime': pickupDateTime.toIso8601String(),
      'dropoffDateTime': dropoffDateTime.toIso8601String(),
      'driverAge': driverAge,
      'currencyCode': currencyCode,
      'residency': residency,
    };
  }
}
