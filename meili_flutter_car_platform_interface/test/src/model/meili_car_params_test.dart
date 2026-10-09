import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:meili_flutter_car_platform_interface/meili_flutter_car_platform_interface.dart';

Map<String, dynamic> _fixture() =>
    jsonDecode(File('test/fixtures/channel_contract.json').readAsStringSync())
        as Map<String, dynamic>;

void main() {
  test('a fully populated MeiliCarParams sends the fixture params map', () {
    final params = MeiliCarParams(
      ptid: '100.9',
      flow: FlowType.bookingManager,
      env: MeiliCarEnv.preProd,
      availParams: AvailParams(
        pickupLocation: 'LHR',
        dropoffLocation: 'CDG',
        pickupDate: '2026-11-05',
        pickupTime: '10:30',
        dropoffDate: '2026-11-12',
        dropoffTime: '16:45',
        pickupDateTime: DateTime.utc(2026, 11, 5, 10, 30),
        dropoffDateTime: DateTime.utc(2026, 11, 12, 16, 45),
        driverAge: 34,
        currencyCode: 'GBP',
        residency: 'FR',
        discountRequested: true,
        partnerLoyaltyAccountTier: 'TIER-AVAIL',
      ),
      additionalParams: AdditionalParams(
        partnerLoyaltyAccount: 'PLA-1001',
        partnerLoyaltyAccountTier: 'TIER-ADDITIONAL',
        numberOfPassengers: 3,
        customerPartnerCode: 'CPC-1002',
        flightNumber: 'BA1003',
        passengerNameRecord: 'PNR1004',
        superPassengerNameRecord: 'SPNR1005',
        infant: 1,
        child: 2,
        teenager: 4,
        supplierLoyaltyAccounts: [
          const SupplierLoyaltyAccount(
            customerAccount: 'SLA-1006',
            supplierName: 'Hertz',
          ),
          const SupplierLoyaltyAccount(customerAccount: 'SLA-1007'),
        ],
        corporateCode: 'CORP-1012',
        fareTypeAndFlex: 'FLEX-1008',
        departureAirport: 'DUB',
        arrivalAirport: 'NCE',
        ancillaryActivity: 'ACT-1009',
        airlineFareAmount: 199.5,
        airlineFareCurrency: 'EUR',
        partnerCustomerID: 'PCID-1010',
        firstName: 'Ada',
        lastName: 'Lovelace',
        email: 'ada.lovelace@example.com',
        phoneNumbers: ['+353871234567', '+442071234567'],
        companyName: 'Analytical Engines Ltd',
        addressLine1: '12 Babbage Street',
        postCode: 'D02 X285',
        city: 'Dublin',
        state: 'Leinster',
        confirmationId: 'CONF-1011',
        prefillOnly: true,
        givenName: 'Augusta',
      ),
    );

    expect(params.toMap(), equals(_fixture()['params']));
  });

  test('every MeiliCarEnv is sent as its name', () {
    for (final env in MeiliCarEnv.values) {
      final map =
          MeiliCarParams(ptid: '1', flow: FlowType.direct, env: env).toMap();

      expect(map['env'], env.name);
    }
    expect(
      MeiliCarEnv.values.map((env) => env.name),
      ['prod', 'preProd', 'uat', 'dev'],
    );
  });

  test('SupplierLoyaltyAccount sends its customerAccount and supplierName', () {
    expect(
      const SupplierLoyaltyAccount(customerAccount: '123', supplierName: 'Avis')
          .toMap(),
      {'customerAccount': '123', 'supplierName': 'Avis'},
    );
    expect(
      const SupplierLoyaltyAccount(customerAccount: '123').toMap(),
      {'customerAccount': '123', 'supplierName': null},
    );
  });

  test('AdditionalParams sends the new fields as the SDKs name them', () {
    final map = AdditionalParams(
      supplierLoyaltyAccounts: [
        const SupplierLoyaltyAccount(customerAccount: '1'),
      ],
      phoneNumbers: ['+0044'],
      givenName: 'Ada',
      corporateCode: 'ACME',
    ).toMap();

    expect(map['supplierLoyaltyAccounts'], [
      {'customerAccount': '1', 'supplierName': null},
    ]);
    expect(map['phoneNumbers'], ['+0044']);
    expect(map['givenName'], 'Ada');
    expect(map['corporateCode'], 'ACME');
  });

  test('unset AdditionalParams fields are sent as null', () {
    final map = AdditionalParams().toMap();

    expect(map['supplierLoyaltyAccounts'], isNull);
    expect(map['phoneNumbers'], isNull);
    expect(map['givenName'], isNull);
    expect(map['corporateCode'], isNull);
  });
}
