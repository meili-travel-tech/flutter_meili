import 'package:flutter/foundation.dart';

/// Events emitted by the native Meili SDK and surfaced to Dart through
/// `MeiliFlutterPlatform.events`.
///
/// This is a sealed hierarchy, so consumers can exhaustively handle every
/// variant with a `switch` expression:
///
/// ```dart
/// Meili.events.listen((event) {
///   switch (event) {
///     case MeiliFlowDismissed():
///       // user closed the Meili UI
///     case MeiliBookingFlowEnded():
///       // booking flow reached its end
///     case MeiliAnalyticsEvent(:final name):
///       // an analytics event was tracked
///     case MeiliUnknownEvent():
///       // a future event type; safe to ignore
///   }
/// });
/// ```
@immutable
sealed class MeiliEvent {
  /// Const base constructor.
  const MeiliEvent();

  /// Builds a [MeiliEvent] from a raw event map sent over the platform
  /// channel.
  ///
  /// A well-formed map with an unrecognised `type` becomes a
  /// [MeiliUnknownEvent] (forward-compatible) rather than throwing, so a newer
  /// native SDK emitting a new event type never breaks an older Dart consumer.
  /// A map missing a `String` `type` is malformed and throws a
  /// [FormatException].
  factory MeiliEvent.fromMap(Map<String, dynamic> map) {
    return switch (map) {
      {'type': 'flowDismissed'} => const MeiliFlowDismissed(),
      {'type': 'bookingFlowEnded'} => const MeiliBookingFlowEnded(),
      {'type': 'analytics', 'name': final String name} => MeiliAnalyticsEvent(
          name: name,
          properties: _coerceProperties(map['properties']),
        ),
      {'type': final String type} => MeiliUnknownEvent(type: type, raw: map),
      _ => throw const FormatException(
          'Malformed MeiliEvent: missing or non-string "type"',
        ),
    };
  }

  /// Serialises this event back to its channel-map form. Inbound-only on the
  /// real channel path; provided for round-trip testing and symmetry.
  Map<String, dynamic> toMap();
}

Map<String, dynamic> _coerceProperties(Object? value) {
  if (value is Map) {
    return value.map((key, dynamic val) => MapEntry(key.toString(), val));
  }
  return const {};
}

/// The Meili UI was dismissed (maps to the SDK's `dismissAction`).
final class MeiliFlowDismissed extends MeiliEvent {
  /// Creates a dismissed event.
  const MeiliFlowDismissed();

  @override
  Map<String, dynamic> toMap() => {'type': 'flowDismissed'};
}

/// The booking flow reached its end (maps to the SDK's `onEndBookingFlow`).
///
/// Call `Meili.popToRoot()` from the app-facing package to invoke the SDK's
/// retained `popToRoot` action in response.
final class MeiliBookingFlowEnded extends MeiliEvent {
  /// Creates a booking-flow-ended event.
  const MeiliBookingFlowEnded();

  @override
  Map<String, dynamic> toMap() => {'type': 'bookingFlowEnded'};
}

/// An analytics event tracked by the SDK (forwarded from a registered
/// analytics provider). Includes `screen_viewed` events, whose [properties]
/// carry a `screen_name`.
final class MeiliAnalyticsEvent extends MeiliEvent {
  /// Creates an analytics event with the given [name] and [properties].
  const MeiliAnalyticsEvent({required this.name, this.properties = const {}});

  /// The tracked event name (e.g. `screen_viewed`, `booking_confirmed`).
  final String name;

  /// Arbitrary event properties, forwarded verbatim from native.
  final Map<String, dynamic> properties;

  @override
  Map<String, dynamic> toMap() => {
        'type': 'analytics',
        'name': name,
        'properties': properties,
      };
}

/// A well-formed event whose `type` this version of the plugin does not yet
/// model. Lets consumers ignore or inspect future event types without the
/// stream erroring.
final class MeiliUnknownEvent extends MeiliEvent {
  /// Creates an unknown event preserving its [type] and [raw] map.
  const MeiliUnknownEvent({required this.type, required this.raw});

  /// The raw `type` discriminator that was not recognised.
  final String type;

  /// The full raw event map, for inspection.
  final Map<String, dynamic> raw;

  @override
  Map<String, dynamic> toMap() => raw;
}
