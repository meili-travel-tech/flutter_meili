package com.meili.travel.flutter.car

import com.meili.travel.car.api.AdditionalParams
import com.meili.travel.car.api.AvailParams
import com.meili.travel.car.api.DevelopmentEnvironment
import com.meili.travel.car.api.MeiliCarEnvironment
import com.meili.travel.car.api.MeiliCarFlow
import com.meili.travel.car.api.PreProductionEnvironment
import com.meili.travel.car.api.ProductionEnvironment
import com.meili.travel.car.api.SupplierLoyaltyAccount
import com.meili.travel.car.api.UatEnvironment

internal fun parseEnv(envName: String?): MeiliCarEnvironment? = when (envName) {
    "prod" -> ProductionEnvironment()
    "preProd" -> PreProductionEnvironment()
    "uat" -> UatEnvironment()
    "dev" -> DevelopmentEnvironment()
    else -> null
}

internal fun parseFlow(flowName: String?): MeiliCarFlow = when (flowName?.lowercase()) {
    "bookingmanager" -> MeiliCarFlow.BookingManager
    else -> MeiliCarFlow.Direct
}

internal fun parseAvailParams(map: Map<*, *>?): AvailParams? {
    map ?: return null
    return AvailParams(
        pickupLocation = map["pickupLocation"] as? String,
        dropoffLocation = map["dropoffLocation"] as? String,
        pickupDate = map["pickupDate"] as? String,
        pickupTime = map["pickupTime"] as? String,
        dropoffDate = map["dropoffDate"] as? String,
        dropoffTime = map["dropoffTime"] as? String,
        driverAge = (map["driverAge"] as? Number)?.toInt(),
        currencyCode = map["currencyCode"] as? String,
        residency = map["residency"] as? String,
        discountRequested = map["discountRequested"] as? Boolean,
        partnerLoyaltyAccountTier = map["partnerLoyaltyAccountTier"] as? String,
    )
}

internal fun parseAdditionalParams(map: Map<*, *>?): AdditionalParams? {
    map ?: return null
    return AdditionalParams(
        passengerNameRecord = map["passengerNameRecord"] as? String,
        partnerLoyaltyAccount = map["partnerLoyaltyAccount"] as? String,
        partnerLoyaltyAccountTier = map["partnerLoyaltyAccountTier"] as? String,
        numberOfPassengers = (map["numberOfPassengers"] as? Number)?.toInt(),
        customerPartnerCode = map["customerPartnerCode"] as? String,
        flightNumber = map["flightNumber"] as? String,
        superPassengerNameRecord = map["superPassengerNameRecord"] as? String,
        infant = (map["infant"] as? Number)?.toInt(),
        child = (map["child"] as? Number)?.toInt(),
        teenager = (map["teenager"] as? Number)?.toInt(),
        supplierLoyaltyAccounts = parseSupplierLoyaltyAccounts(map["supplierLoyaltyAccounts"]),
        corporateCode = map["corporateCode"] as? String,
        fareTypeAndFlex = map["fareTypeAndFlex"] as? String,
        departureAirport = map["departureAirport"] as? String,
        arrivalAirport = map["arrivalAirport"] as? String,
        ancillaryActivity = map["ancillaryActivity"] as? String,
        airlineFareAmount = (map["airlineFareAmount"] as? Number)?.toDouble(),
        airlineFareCurrency = map["airlineFareCurrency"] as? String,
        partnerCustomerID = map["partnerCustomerID"] as? String,
        firstName = map["firstName"] as? String,
        lastName = map["lastName"] as? String,
        email = map["email"] as? String,
        phoneNumbers = (map["phoneNumbers"] as? List<*>)?.filterIsInstance<String>(),
        companyName = map["companyName"] as? String,
        addressLine1 = map["addressLine1"] as? String,
        postCode = map["postCode"] as? String,
        city = map["city"] as? String,
        state = map["state"] as? String,
        confirmationId = map["confirmationId"] as? String,
        prefillOnly = map["prefillOnly"] as? Boolean,
        givenName = map["givenName"] as? String,
    )
}

private fun parseSupplierLoyaltyAccounts(value: Any?): List<SupplierLoyaltyAccount>? =
    (value as? List<*>)?.mapNotNull { element ->
        val account = element as? Map<*, *> ?: return@mapNotNull null
        val customerAccount = account["customerAccount"] as? String ?: return@mapNotNull null
        SupplierLoyaltyAccount(customerAccount, account["supplierName"] as? String)
    }
