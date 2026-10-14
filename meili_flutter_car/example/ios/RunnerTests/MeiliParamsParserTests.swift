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
        #expect(try #require(stored["currencyCode"]) == nil)
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
        ("phoneNumbers", ["+353871234567", "+442071234567"]),
        ("corporateCode", "CORP-1012"),
        ("companyName", "Analytical Engines Ltd"),
        ("addressLine1", "12 Babbage Street"),
        ("postCode", "D02 X285"),
        ("city", "Dublin"),
        ("state", "Leinster"),
        ("confirmationId", "CONF-1011"),
        ("prefillOnly", true),
        ("givenName", "Augusta"),
    ])
    func fixtureAdditionalParamsReachTheSDKParams(key: String, expected: any Hashable & Sendable) throws {
        let params = try #require(parseBookingParams(from: try ChannelContractFixture.additionalParams()))

        #expect(storedProperties(of: params)[key] == AnyHashable(expected))
    }

    @Test
    func fixtureSupplierLoyaltyAccountsReachTheSDKParams() throws {
        let params = try #require(parseBookingParams(from: try ChannelContractFixture.additionalParams()))
        let accounts = try #require(params.supplierLoyaltyAccounts)

        #expect(accounts.map(\.customerAccount) == ["SLA-1006", "SLA-1007"])
        #expect(accounts.map(\.supplierName) == ["Hertz", nil])
    }

    @Test
    func skipsLoyaltyElementsWithoutAUsableCustomerAccount() throws {
        let valid: [String: Any] = ["customerAccount": "OK-1", "supplierName": "Avis"]
        let elements: [Any] = [
            ["supplierName": "Hertz"],
            NSNull(),
            "SLA-123",
            ["customerAccount": 42],
            valid,
        ]

        let params = try #require(parseBookingParams(from: ["supplierLoyaltyAccounts": elements]))
        let accounts = try #require(params.supplierLoyaltyAccounts)

        #expect(accounts.map(\.customerAccount) == ["OK-1"])
        #expect(accounts.map(\.supplierName) == ["Avis"])
    }

    @Test
    func dropsAWrongTypedSupplierNameButKeepsTheAccount() throws {
        let elements: [Any] = [["customerAccount": "OK-1", "supplierName": 7]]

        let params = try #require(parseBookingParams(from: ["supplierLoyaltyAccounts": elements]))
        let accounts = try #require(params.supplierLoyaltyAccounts)

        #expect(accounts.map(\.customerAccount) == ["OK-1"])
        #expect(accounts.map(\.supplierName) == [nil])
    }

    @Test
    func ignoresASupplierLoyaltyAccountsValueThatIsNotAList() throws {
        let params = try #require(parseBookingParams(from: ["supplierLoyaltyAccounts": "SLA-123"]))

        #expect(params.supplierLoyaltyAccounts == nil)
    }

    @Test
    func skipsNonStringPhoneNumbers() throws {
        let numbers: [Any] = ["+44123", 4412, NSNull(), "+353871234567"]

        let params = try #require(parseBookingParams(from: ["phoneNumbers": numbers]))

        #expect(params.phoneNumbers == ["+44123", "+353871234567"])
    }

    @Test
    func ignoresWrongTypedGivenNameAndCorporateCode() throws {
        let params = try #require(parseBookingParams(from: ["givenName": 1, "corporateCode": ["x"]]))

        #expect(params.givenName == nil)
        #expect(params.corporateCode == nil)
    }
}
