package com.meili.travel.flutter.car

import com.meili.travel.car.api.DevelopmentEnvironment
import com.meili.travel.car.api.PreProductionEnvironment
import com.meili.travel.car.api.ProductionEnvironment
import com.meili.travel.car.api.UatEnvironment
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertIs
import kotlin.test.assertNotNull
import kotlin.test.assertNull

class MeiliParamsParserTest {

    @Test
    fun `the fixture env name maps to the pre-production environment`() {
        assertIs<PreProductionEnvironment>(parseEnv(ChannelContractFixture.params["env"] as String))
    }

    @Test
    fun `every Dart env name maps to its typed environment`() {
        assertIs<ProductionEnvironment>(parseEnv("prod"))
        assertIs<PreProductionEnvironment>(parseEnv("preProd"))
        assertIs<UatEnvironment>(parseEnv("uat"))
        assertIs<DevelopmentEnvironment>(parseEnv("dev"))
    }

    @Test
    fun `anything but the four env names is rejected`() {
        listOf("pre_prod", "production", "PROD", "Dev", "preprod", "", "staging", null).forEach {
            assertNull(parseEnv(it), "env: $it")
        }
    }

    @Test
    fun `the fixture availParams produce the SDK availParams`() {
        val params = assertNotNull(parseAvailParams(ChannelContractFixture.availParams))

        assertEquals("LHR", params.pickupLocation)
        assertEquals("CDG", params.dropoffLocation)
        assertEquals("2026-11-05", params.pickupDate)
        assertEquals("10:30", params.pickupTime)
        assertEquals("2026-11-12", params.dropoffDate)
        assertEquals("16:45", params.dropoffTime)
        assertEquals(34, params.driverAge)
        assertEquals("GBP", params.currencyCode)
        assertEquals("FR", params.residency)
        assertEquals(true, params.discountRequested)
        assertEquals("TIER-AVAIL", params.partnerLoyaltyAccountTier)
    }

    @Test
    fun `the fixture additionalParams produce the SDK additionalParams`() {
        val params = assertNotNull(parseAdditionalParams(ChannelContractFixture.additionalParams))

        assertEquals("PLA-1001", params.partnerLoyaltyAccount)
        assertEquals("TIER-ADDITIONAL", params.partnerLoyaltyAccountTier)
        assertEquals(3, params.numberOfPassengers)
        assertEquals("CPC-1002", params.customerPartnerCode)
        assertEquals("BA1003", params.flightNumber)
        assertEquals("PNR1004", params.passengerNameRecord)
        assertEquals("SPNR1005", params.superPassengerNameRecord)
        assertEquals(1, params.infant)
        assertEquals(2, params.child)
        assertEquals(4, params.teenager)
        assertEquals("SLA-1006", params.supplierLoyaltyAccount)
        assertEquals("FLEX-1008", params.fareTypeAndFlex)
        assertEquals("DUB", params.departureAirport)
        assertEquals("NCE", params.arrivalAirport)
        assertEquals("ACT-1009", params.ancillaryActivity)
        assertEquals(199.5, params.airlineFareAmount)
        assertEquals("EUR", params.airlineFareCurrency)
        assertEquals("PCID-1010", params.partnerCustomerID)
        assertEquals("Ada", params.firstName)
        assertEquals("Lovelace", params.lastName)
        assertEquals("ada.lovelace@example.com", params.email)
        assertEquals(listOf("353871234567", "442071234567"), params.phoneNumbers)
        assertEquals("Analytical Engines Ltd", params.companyName)
        assertEquals("12 Babbage Street", params.addressLine1)
        assertEquals("D02 X285", params.postCode)
        assertEquals("Dublin", params.city)
        assertEquals("Leinster", params.state)
        assertEquals("CONF-1011", params.confirmationId)
        assertEquals(true, params.prefillOnly)
    }
}
