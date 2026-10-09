//
//  MeiliParamsParser.swift
//  meili_flutter_car_ios
//

import Foundation
import MeiliCarSDK

func parseEnvironment(named name: String) -> MeiliCarEnvironment? {
    MeiliCarEnvironment(rawValue: name)
}

func parseBookingParams(from dict: [String: Any]) -> AdditionalParams? {
    return AdditionalParams(
        partnerLoyaltyAccount: dict["partnerLoyaltyAccount"] as? String,
        partnerLoyaltyAccountTier: dict["partnerLoyaltyAccountTier"] as? String,
        numberOfPassengers: dict["numberOfPassengers"] as? Int,
        customerPartnerCode: dict["customerPartnerCode"] as? String,
        flightNumber: dict["flightNumber"] as? String,
        passengerNameRecord: dict["passengerNameRecord"] as? String,
        superPassengerNameRecord: dict["superPassengerNameRecord"] as? String,
        infant: dict["infant"] as? Int,
        child: dict["child"] as? Int,
        teenager: dict["teenager"] as? Int,
        supplierLoyaltyAccounts: parseSupplierLoyaltyAccounts(dict["supplierLoyaltyAccounts"]),
        fareTypeAndFlex: dict["fareTypeAndFlex"] as? String,
        departureAirport: dict["departureAirport"] as? String,
        arrivalAirport: dict["arrivalAirport"] as? String,
        ancillaryActivity: dict["ancillaryActivity"] as? String,
        airlineFareAmount: dict["airlineFareAmount"] as? Double,
        airlineFareCurrency: dict["airlineFareCurrency"] as? String,
        partnerCustomerID: dict["partnerCustomerID"] as? String,
        firstName: dict["firstName"] as? String,
        lastName: dict["lastName"] as? String ?? "",
        email: dict["email"] as? String,
        phoneNumbers: (dict["phoneNumbers"] as? [Any])?.compactMap { $0 as? String },
        companyName: dict["companyName"] as? String,
        corporateCode: dict["corporateCode"] as? String,
        addressLine1: dict["addressLine1"] as? String,
        postCode: dict["postCode"] as? String,
        city: dict["city"] as? String,
        state: dict["state"] as? String,
        confirmationId: dict["confirmationId"] as? String ?? "",
        prefillOnly: dict["prefillOnly"] as? Bool,
        givenName: dict["givenName"] as? String
    )
}

private func parseSupplierLoyaltyAccounts(_ value: Any?) -> [SupplierLoyaltyAccount]? {
    guard let elements = value as? [Any] else { return nil }
    return elements.compactMap { element in
        guard let account = element as? [String: Any],
              let customerAccount = account["customerAccount"] as? String
        else { return nil }
        return SupplierLoyaltyAccount(
            customerAccount: customerAccount,
            supplierName: account["supplierName"] as? String
        )
    }
}

// Every AvailParams field is optional on the SDK side. The Dart model makes most of them
// required, so hosts that only want to set the currency send "" and 0 to mean "not set".
func parseAvailParams(from dict: [String: Any]) -> AvailParams? {
    AvailParams(
        pickupLocation: dict.nonBlankString("pickupLocation"),
        dropoffLocation: dict.nonBlankString("dropoffLocation"),
        pickupDate: dict.nonBlankString("pickupDate"),
        pickupTime: dict.nonBlankString("pickupTime"),
        dropoffDate: dict.nonBlankString("dropoffDate"),
        dropoffTime: dict.nonBlankString("dropoffTime"),
        driverAge: (dict["driverAge"] as? Int).flatMap { $0 > 0 ? $0 : nil },
        currencyCode: dict.nonBlankString("currencyCode"),
        residency: dict.nonBlankString("residency"),
        discountRequested: dict["discountRequested"] as? Bool,
        partnerLoyaltyAccountTier: dict.nonBlankString("partnerLoyaltyAccountTier"),
        pickupDateTime: dict.nonBlankString("pickupDateTime"),
        dropoffDateTime: dict.nonBlankString("dropoffDateTime")
    )
}

private extension Dictionary where Key == String, Value == Any {
    func nonBlankString(_ key: String) -> String? {
        (self[key] as? String).flatMap { $0.trimmingCharacters(in: .whitespaces).isEmpty ? nil : $0 }
    }
}
