import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:meili_flutter_example/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E', () {
    testWidgets('launches with the supported flow tabs and an empty Events tab',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Only Direct and Booking Manager flows are exposed (Connect removed),
      // plus the Events tab.
      expect(find.text('Direct'), findsOneWidget);
      expect(find.text('Booking Manager'), findsOneWidget);
      expect(find.text('Events'), findsOneWidget);

      await tester.tap(find.text('Events'));
      await tester.pumpAndSettle();
      expect(find.textContaining('No Meili events yet'), findsOneWidget);
    });
  });
}
