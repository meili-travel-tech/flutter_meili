import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meili_flutter_car/meili_flutter_car.dart';
import 'package:meili_flutter_car_example/events_view_model.dart';
import 'package:meili_flutter_car_example/widgets/events_panel.dart';

void main() {
  testWidgets('EventsPanel renders events from the view model', (tester) async {
    final controller = StreamController<MeiliCarEvent>.broadcast();
    addTearDown(controller.close);
    final viewModel = EventsViewModel(events: controller.stream);
    addTearDown(viewModel.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: EventsPanel(viewModel: viewModel)),
      ),
    );

    expect(find.textContaining('No MeiliCar events yet'), findsOneWidget);

    controller.add(
      const MeiliCarAnalyticsEvent(
        name: 'screen_viewed',
        properties: {'screen_name': 'home'},
      ),
    );
    await tester.pump();
    expect(find.textContaining('Analytics · screen_viewed'), findsOneWidget);

    controller.add(const MeiliCarFlowDismissed());
    await tester.pump();
    expect(find.text('Flow dismissed'), findsOneWidget);

    controller.add(
      const MeiliCarBookingSucceeded(
        reservation: {
          'confirmationId': 'CONF-1',
          'meiliSessionId': 'SESSION-1',
        },
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Booking succeeded'), findsOneWidget);
    expect(find.textContaining('confirmationId: CONF-1'), findsOneWidget);
    expect(find.textContaining('meiliSessionId: SESSION-1'), findsOneWidget);
  });

  test('printReservation prints the reservation in numbered pieces', () {
    final lines = <String>[];
    runZoned(
      () => printReservation({'k': 'v' * 25}, chunkSize: 10),
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, line) => lines.add(line),
      ),
    );

    expect(lines, hasLength(4));
    expect(lines.first, startsWith('MeiliCarBookingSucceeded [1] :: '));
    expect(lines.last, startsWith('MeiliCarBookingSucceeded [4] :: '));
    expect(
      lines.map((line) => line.split(' :: ').last).join(),
      '{"k":"${'v' * 25}"}',
    );
  });
}
