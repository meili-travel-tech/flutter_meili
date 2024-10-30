import 'package:meili_flutter/src/model/avail_params.dart';
import 'package:meili_flutter/src/model/booking_params.dart';
import 'package:meili_flutter/src/model/flow_enum.dart';

/// Represents the parameters required to open the Meili view.
class MeiliParams {
  /// Creates an instance of [MeiliParams].
  MeiliParams({
    required this.ptid,
    required this.currentFlow,
    required this.env,
    this.availParams,
    this.bookingParams,
  });

  /// The ptid (possibly partner ID) for the Meili view.
  final String ptid;

  /// The current flow type for the Meili view.
  final FlowType currentFlow;

  /// The environment for the Meili view (e.g., dev, prod).
  final String env;

  /// The availability parameters for the Meili view.
  final AvailParams? availParams;

  /// The booking parameters for the Meili view.
  final BookingParams? bookingParams;

  /// Converts the [MeiliParams] instance to a map.
  Map<String, dynamic> toMap() {
    return {
      'ptid': ptid,
      'currentFlow': currentFlow.toString().split('.').last,
      'env': env,
      'availParams': availParams?.toMap(),
      'bookingParams': bookingParams?.toMap(),
    };
  }
}
