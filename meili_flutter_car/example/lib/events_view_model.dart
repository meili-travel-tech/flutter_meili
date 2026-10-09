import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:meili_flutter_car/meili_flutter_car.dart';

/// A single received event tagged with a stable id (for list keys).
typedef EventRecord = ({int id, MeiliCarEvent event});

/// Subscribes to [MeiliCar.events] and exposes the received events as immutable
/// state for the UI (MVVM, per the project's Flutter architecture skill).
class EventsViewModel extends ChangeNotifier {
  /// Creates the view model and begins listening.
  ///
  /// [events] is injectable for testing; it defaults to [MeiliCar.events].
  EventsViewModel({Stream<MeiliCarEvent>? events}) {
    _subscription = (events ?? MeiliCar.events).listen(_onEvent);
  }

  late final StreamSubscription<MeiliCarEvent> _subscription;
  final List<EventRecord> _records = <EventRecord>[];
  int _nextId = 0;

  /// The received events, newest first. Immutable snapshot.
  List<EventRecord> get records => List<EventRecord>.unmodifiable(_records);

  void _onEvent(MeiliCarEvent event) {
    if (event is MeiliCarBookingSucceeded) {
      printReservation(event.reservation);
    }
    _records.insert(0, (id: _nextId++, event: event));
    notifyListeners();
  }

  /// Clears the received events.
  void clear() {
    _records.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// Prints [reservation] as JSON in numbered pieces, each prefixed
/// `MeiliCarBookingSucceeded [n] ::`. `print` output is cut at about 1000
/// characters per line on iOS and Android, so a longer line loses its tail.
void printReservation(
  Map<String, dynamic> reservation, {
  int chunkSize = 800,
}) {
  final json = jsonEncode(reservation);
  for (var start = 0, n = 1; start < json.length; start += chunkSize, n++) {
    final end = min(start + chunkSize, json.length);
    // ignore: avoid_print
    print('MeiliCarBookingSucceeded [$n] :: ${json.substring(start, end)}');
  }
}
