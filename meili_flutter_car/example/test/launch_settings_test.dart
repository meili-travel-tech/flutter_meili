import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meili_flutter_car/meili_flutter_car.dart';
import 'package:meili_flutter_car_example/launch_view_model.dart';
import 'package:meili_flutter_car_example/meili_settings.dart';
import 'package:meili_flutter_car_example/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MeiliSettings', () {
    test('defaults match the iOS Sample App', () {
      const settings = MeiliSettings();
      expect(settings.ptid, '100.9');
      expect(settings.env, MeiliEnv.dev);
      expect(settings.flow, FlowType.direct);
      expect(settings.overrideCurrency, isFalse);
      expect(settings.currency, 'EUR');
      expect(settings.showBookingToast, isFalse);
    });

    test('toMeiliParams maps core fields and omits empty extras', () {
      const settings = MeiliSettings(env: MeiliEnv.prod);
      final params = settings.toMeiliParams();
      expect(params.ptid, '100.9');
      expect(params.env, MeiliCarEnv.prod);
      expect(params.flow, FlowType.direct);
      expect(params.availParams, isNull);
      expect(params.additionalParams, isNull);
    });

    test('every picker env maps to its MeiliCarEnv and persists by name', () {
      for (final env in MeiliEnv.values) {
        final settings = MeiliSettings(env: env);

        expect(settings.toMeiliParams().env, env.carEnv);
        expect(settings.toJson()['env'], env.carEnv.name);
        expect(MeiliSettings.fromJson(settings.toJson()).env, env);
      }
      expect(MeiliEnv.preProd.carEnv, MeiliCarEnv.preProd);
    });

    test('toMeiliParams includes booking + currency when set', () {
      const settings = MeiliSettings(
        flow: FlowType.bookingManager,
        overrideCurrency: true,
        currency: 'USD',
        confirmationId: 'ABC123',
        lastName: 'Doe',
        prefillOnly: true,
      );
      final params = settings.toMeiliParams();
      expect(params.flow, FlowType.bookingManager);
      expect(params.availParams?.currencyCode, 'USD');
      expect(params.additionalParams?.confirmationId, 'ABC123');
      expect(params.additionalParams?.lastName, 'Doe');
      expect(params.additionalParams?.prefillOnly, isTrue);
    });

    test('seeds pickup and drop-off DateTimes when overriding dates', () {
      const settings = MeiliSettings(overrideDates: true);
      final params = settings.toMeiliParams(now: DateTime(2026, 10, 28, 9));

      expect(params.availParams?.pickupDateTime, DateTime(2026, 11, 4, 10, 30));
      expect(
        params.availParams?.dropoffDateTime,
        DateTime(2026, 11, 11, 16, 45),
      );
      expect(params.availParams?.currencyCode, isNull);
      expect(params.toMap()['availParams'], {
        'pickupDate': '2026-11-04',
        'pickupTime': '10:30',
        'dropoffDate': '2026-11-11',
        'dropoffTime': '16:45',
      });
    });

    test('round-trips through JSON', () {
      const settings = MeiliSettings(
        ptid: '42',
        env: MeiliEnv.uat,
        flow: FlowType.bookingManager,
        overrideCurrency: true,
        currency: 'GBP',
        overrideDates: true,
        confirmationId: 'X1',
        lastName: 'Smith',
        prefillOnly: true,
        showBookingToast: true,
      );
      final restored = MeiliSettings.fromJson(settings.toJson());
      expect(restored.toJson(), settings.toJson());
    });
  });

  group('SettingsRepository', () {
    test('returns defaults when nothing is stored', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final repository = SettingsRepository(
        await SharedPreferences.getInstance(),
      );
      expect(repository.load().toJson(), const MeiliSettings().toJson());
    });

    test('persists and reloads settings', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final repository = SettingsRepository(
        await SharedPreferences.getInstance(),
      );
      const settings = MeiliSettings(ptid: '7', env: MeiliEnv.prod);
      await repository.save(settings);
      expect(repository.load().toJson(), settings.toJson());
    });
  });

  group('LaunchViewModel', () {
    late SettingsRepository repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      repository = SettingsRepository(await SharedPreferences.getInstance());
    });

    test('update persists and resetToDefaults restores', () {
      final events = StreamController<MeiliCarEvent>.broadcast();
      addTearDown(events.close);
      final viewModel = LaunchViewModel(
        repository: repository,
        events: events.stream,
      );
      addTearDown(viewModel.dispose);

      viewModel.update(const MeiliSettings(ptid: '999'));
      expect(viewModel.settings.ptid, '999');
      expect(repository.load().ptid, '999');

      viewModel.resetToDefaults();
      expect(viewModel.settings.ptid, '100.9');
    });

    test('emits a booking toast only when enabled', () async {
      final events = StreamController<MeiliCarEvent>.broadcast();
      addTearDown(events.close);
      final viewModel = LaunchViewModel(
        repository: repository,
        events: events.stream,
      );
      addTearDown(viewModel.dispose);

      final toasts = <String>[];
      final subscription = viewModel.toasts.listen(toasts.add);
      addTearDown(subscription.cancel);

      // Disabled by default: no toast.
      events.add(const MeiliCarBookingFlowEnded());
      await Future<void>.delayed(Duration.zero);
      expect(toasts, isEmpty);

      // Enabled: toast emitted.
      viewModel.update(const MeiliSettings(showBookingToast: true));
      events.add(const MeiliCarBookingFlowEnded());
      await Future<void>.delayed(Duration.zero);
      expect(toasts, <String>['Booking flow ended']);
    });
  });
}
