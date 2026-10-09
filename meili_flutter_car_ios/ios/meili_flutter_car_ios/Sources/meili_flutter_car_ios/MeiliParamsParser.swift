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
        supplierLoyaltyAccounts: dict["supplierLoyaltyAccount"] as? [String],
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
        phoneNumbers: dict["phoneNumbers"] as? [Int],
        companyName: dict["companyName"] as? String,
        addressLine1: dict["addressLine1"] as? String,
        postCode: dict["postCode"] as? String,
        city: dict["city"] as? String,
        state: dict["state"] as? String,
        confirmationId: dict["confirmationId"] as? String ?? "",
        prefillOnly: dict["prefillOnly"] as? Bool
    )
}

func parseAvailParams(from dict: [String: Any]) -> AvailParams? {
    AvailParams(
        pickupLocation: dict["pickupLocation"] as? String,
        dropoffLocation: dict["dropoffLocation"] as? String,
        pickupDate: dict["pickupDate"] as? String,
        pickupTime: dict["pickupTime"] as? String,
        dropoffDate: dict["dropoffDate"] as? String,
        dropoffTime: dict["dropoffTime"] as? String,
        driverAge: dict["driverAge"] as? Int,
        currencyCode: dict["currencyCode"] as? String,
        residency: dict["residency"] as? String,
        discountRequested: dict["discountRequested"] as? Bool,
        partnerLoyaltyAccountTier: dict["partnerLoyaltyAccountTier"] as? String
    )
}
