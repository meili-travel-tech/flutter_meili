//
//  MeiliParamsParser.swift
//  meili_flutter_ios
//

import Foundation
import MeiliSDK

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
        lastName: dict["lastName"] as! String,
        email: dict["email"] as? String,
        phoneNumbers: dict["phoneNumbers"] as? [Int],
        companyName: dict["companyName"] as? String,
        addressLine1: dict["addressLine1"] as? String,
        postCode: dict["postCode"] as? String,
        city: dict["city"] as? String,
        state: dict["state"] as? String,
        confirmationId: dict["confirmationId"] as! String,
        prefillOnly: dict["prefillOnly"] as? Bool
    )
}

func parseAvailParams(from dict: [String: Any]) -> AvailParams? {
    guard let pickupLocation = dict["pickupLocation"] as? String,
          let dropoffLocation = dict["dropoffLocation"] as? String,
          let pickupTime = dict["pickupTime"] as? String,
          let pickupDate = dict["pickupDate"] as? String,
          let dropoffTime = dict["dropoffTime"] as? String,
          let dropoffDate = dict["dropoffDate"] as? String,
          let pickupDateTime = dict["pickupDateTime"] as? String,
          let dropoffDateTime = dict["dropoffDateTime"] as? String,
          let driverAge = dict["driverAge"] as? Int,
          let currencyCode = dict["currencyCode"] as? String,
          let residency = dict["residency"] as? String else {
        return nil
    }

    return AvailParams(
        pickupLocation: pickupLocation,
        dropoffLocation: dropoffLocation,
        pickupDate: pickupDate,
        pickupTime: pickupTime,
        dropoffDate: dropoffDate,
        dropoffTime: dropoffTime,
        driverAge: driverAge,
        currencyCode: currencyCode,
        residency: residency,
        pickupDateTime: pickupDateTime,
        dropoffDateTime: dropoffDateTime
    )
}
