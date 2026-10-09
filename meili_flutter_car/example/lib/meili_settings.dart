import 'package:meili_flutter_car/meili_flutter_car.dart';

/// The API environment the sample app points the SDK at.
///
/// Mirrors the iOS Sample App's environment picker. [carEnv] is the value
/// passed to [MeiliCarParams.env]; [label] is what the picker shows.
enum MeiliEnv {
  dev(MeiliCarEnv.dev, 'Dev'),
  uat(MeiliCarEnv.uat, 'UAT'),
  preProd(MeiliCarEnv.preProd, 'Pre-Prod'),
  prod(MeiliCarEnv.prod, 'Prod');

  const MeiliEnv(this.carEnv, this.label);

  /// The value sent to the native SDK via [MeiliCarParams.env].
  final MeiliCarEnv carEnv;

  /// The human-readable label shown in the picker.
  final String label;

  /// Resolves a persisted [MeiliCarEnv] name back to an enum, defaulting to
  /// [dev].
  static MeiliEnv fromName(String? value) => MeiliEnv.values.firstWhere(
        (env) => env.carEnv.name == value,
        orElse: () => MeiliEnv.dev,
      );
}

/// Immutable snapshot of every launch setting a tester can configure.
///
/// Defaults match the iOS Sample App (`SettingsViewModel`) so the two sample
/// apps behave the same out of the box.
class MeiliSettings {
  /// Creates a settings snapshot. All fields default to the iOS values.
  const MeiliSettings({
    this.ptid = '100.9',
    this.env = MeiliEnv.dev,
    this.flow = FlowType.direct,
    this.overrideCurrency = false,
    this.currency = 'EUR',
    this.overrideDates = false,
    this.confirmationId = '',
    this.lastName = '',
    this.prefillOnly = false,
    this.showBookingToast = false,
  });

  /// Rebuilds a snapshot from its [toJson] representation.
  factory MeiliSettings.fromJson(Map<String, dynamic> json) => MeiliSettings(
        ptid: json['ptid'] as String? ?? '100.9',
        env: MeiliEnv.fromName(json['env'] as String?),
        flow: json['flow'] == 'bookingManager'
            ? FlowType.bookingManager
            : FlowType.direct,
        overrideCurrency: json['overrideCurrency'] as bool? ?? false,
        currency: json['currency'] as String? ?? 'EUR',
        overrideDates: json['overrideDates'] as bool? ?? false,
        confirmationId: json['confirmationId'] as String? ?? '',
        lastName: json['lastName'] as String? ?? '',
        prefillOnly: json['prefillOnly'] as bool? ?? false,
        showBookingToast: json['showBookingToast'] as bool? ?? false,
      );

  /// Partner / touchpoint id passed to [MeiliCarParams.ptid].
  final String ptid;

  /// Selected API environment.
  final MeiliEnv env;

  /// Selected booking flow.
  final FlowType flow;

  /// Whether to send a currency override via [AvailParams].
  final bool overrideCurrency;

  /// Currency code used when [overrideCurrency] is on.
  final String currency;

  /// Whether to seed the search with a pickup and drop-off [DateTime], sent
  /// through [AvailParams.pickupDateTime] and [AvailParams.dropoffDateTime].
  final bool overrideDates;

  /// Booking confirmation id for the Booking Manager flow.
  final String confirmationId;

  /// Customer last name for the Booking Manager flow.
  final String lastName;

  /// Whether the booking form should only be prefilled.
  final bool prefillOnly;

  /// Whether to show a toast when a booking flow ends.
  final bool showBookingToast;

  /// Returns a copy with the provided fields replaced.
  MeiliSettings copyWith({
    String? ptid,
    MeiliEnv? env,
    FlowType? flow,
    bool? overrideCurrency,
    String? currency,
    bool? overrideDates,
    String? confirmationId,
    String? lastName,
    bool? prefillOnly,
    bool? showBookingToast,
  }) {
    return MeiliSettings(
      ptid: ptid ?? this.ptid,
      env: env ?? this.env,
      flow: flow ?? this.flow,
      overrideCurrency: overrideCurrency ?? this.overrideCurrency,
      currency: currency ?? this.currency,
      overrideDates: overrideDates ?? this.overrideDates,
      confirmationId: confirmationId ?? this.confirmationId,
      lastName: lastName ?? this.lastName,
      prefillOnly: prefillOnly ?? this.prefillOnly,
      showBookingToast: showBookingToast ?? this.showBookingToast,
    );
  }

  /// Serializes the settings for persistence.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'ptid': ptid,
        'env': env.carEnv.name,
        'flow': flow.name,
        'overrideCurrency': overrideCurrency,
        'currency': currency,
        'overrideDates': overrideDates,
        'confirmationId': confirmationId,
        'lastName': lastName,
        'prefillOnly': prefillOnly,
        'showBookingToast': showBookingToast,
      };

  /// Builds the [MeiliCarParams] used to launch the SDK from these settings.
  ///
  /// [now] anchors the seeded dates and is injectable for testing.
  MeiliCarParams toMeiliParams({DateTime? now}) {
    return MeiliCarParams(
      ptid: ptid,
      flow: flow,
      env: env.carEnv,
      availParams: _availParams(now ?? DateTime.now()),
      additionalParams: _additionalParams(),
    );
  }

  /// Booking-manager params, or null when nothing meaningful is set.
  AdditionalParams? _additionalParams() {
    final hasConfirmation = confirmationId.isNotEmpty;
    final hasLastName = lastName.isNotEmpty;
    if (!hasConfirmation && !hasLastName && !prefillOnly) {
      return null;
    }
    return AdditionalParams(
      confirmationId: hasConfirmation ? confirmationId : null,
      lastName: hasLastName ? lastName : null,
      prefillOnly: prefillOnly,
    );
  }

  /// Search prefill, or null when neither the currency nor the dates are set.
  AvailParams? _availParams(DateTime now) {
    if (!overrideCurrency && !overrideDates) {
      return null;
    }
    return AvailParams(
      currencyCode: overrideCurrency ? currency : null,
      pickupDateTime: overrideDates
          ? DateTime(now.year, now.month, now.day + 7, 10, 30)
          : null,
      dropoffDateTime: overrideDates
          ? DateTime(now.year, now.month, now.day + 14, 16, 45)
          : null,
    );
  }
}
