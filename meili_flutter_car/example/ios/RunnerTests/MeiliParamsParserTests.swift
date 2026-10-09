import MeiliCarSDK
import Testing

@testable import meili_flutter_car_ios

struct MeiliParamsParserTests {
    @Test(arguments: [
        ("prod", MeiliCarEnvironment.prod),
        ("preProd", .preProd),
        ("uat", .uat),
        ("dev", .dev),
    ])
    func mapsEveryEnvNameToItsEnvironment(name: String, expected: MeiliCarEnvironment) throws {
        let environment = try #require(parseEnvironment(named: name))

        #expect(environment == expected)
        #expect(environment.rawValue == name)
    }

    @Test(arguments: ["pre_prod", "production", "PROD", "Dev", "preprod", "", "staging"])
    func rejectsEveryOtherEnvName(name: String) {
        #expect(parseEnvironment(named: name) == nil)
    }

    @Test
    func fixtureEnvNameMapsToPreProd() throws {
        let name = try #require(try ChannelContractFixture.params()["env"] as? String)

        #expect(parseEnvironment(named: name) == .preProd)
    }

    @Test(arguments: [
        ("pickupLocation", "LHR" as any Hashable & Sendable),
        ("dropoffLocation", "CDG"),
        ("pickupDate", "2026-11-05"),
        ("pickupTime", "10:30"),
        ("dropoffDate", "2026-11-12"),
        ("dropoffTime", "16:45"),
        ("driverAge", 34),
        ("currencyCode", "GBP"),
        ("residency", "FR"),
        ("discountRequested", true),
        ("partnerLoyaltyAccountTier", "TIER-AVAIL"),
    ])
    func fixtureAvailParamsReachTheSDKParams(key: String, expected: any Hashable & Sendable) throws {
        let params = try #require(parseAvailParams(from: try ChannelContractFixture.availParams()))

        #expect(storedProperties(of: params)[key] == AnyHashable(expected))
    }

    @Test
    func blankAvailValuesReachTheSDKParamsUnchanged() throws {
        let params = try #require(parseAvailParams(from: try ChannelContractFixture.availParamsBlank()))
        let stored = storedProperties(of: params)

        #expect(stored["pickupLocation"] == AnyHashable(""))
        #expect(stored["driverAge"] == AnyHashable(0))
        #expect(stored["partnerLoyaltyAccountTier"] == AnyHashable(" "))
        #expect(stored["currencyCode"] == nil)
    }

    @Test(arguments: [
        ("partnerLoyaltyAccount", "PLA-1001" as any Hashable & Sendable),
        ("partnerLoyaltyAccountTier", "TIER-ADDITIONAL"),
        ("numberOfPassengers", 3),
        ("customerPartnerCode", "CPC-1002"),
        ("flightNumber", "BA1003"),
        ("passengerNameRecord", "PNR1004"),
        ("superPassengerNameRecord", "SPNR1005"),
        ("infant", 1),
        ("child", 2),
        ("teenager", 4),
        ("fareTypeAndFlex", "FLEX-1008"),
        ("departureAirport", "DUB"),
        ("arrivalAirport", "NCE"),
        ("ancillaryActivity", "ACT-1009"),
        ("airlineFareAmount", 199.5),
        ("airlineFareCurrency", "EUR"),
        ("partnerCustomerID", "PCID-1010"),
        ("firstName", "Ada"),
        ("lastName", "Lovelace"),
        ("email", "ada.lovelace@example.com"),
        ("phoneNumbers", [353_871_234_567, 442_071_234_567]),
        ("companyName", "Analytical Engines Ltd"),
        ("addressLine1", "12 Babbage Street"),
        ("postCode", "D02 X285"),
        ("city", "Dublin"),
        ("state", "Leinster"),
        ("confirmationId", "CONF-1011"),
        ("prefillOnly", true),
    ])
    func fixtureAdditionalParamsReachTheSDKParams(key: String, expected: any Hashable & Sendable) throws {
        let params = try #require(parseBookingParams(from: try ChannelContractFixture.additionalParams()))

        #expect(storedProperties(of: params)[key] == AnyHashable(expected))
    }
}
