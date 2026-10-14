import Foundation
import Testing

enum ChannelContractFixture {
    private static let url = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appendingPathComponent("meili_flutter_car_platform_interface/test/fixtures/channel_contract.json")

    static func params() throws -> [String: Any] {
        try section("params", of: root())
    }

    static func availParams() throws -> [String: Any] {
        try section("availParams", of: params())
    }

    static func additionalParams() throws -> [String: Any] {
        try section("additionalParams", of: params())
    }

    static func availParamsBlank() throws -> [String: Any] {
        try section("availParams", of: section("paramsBlank", of: root()))
    }

    static func bookingSucceededEvent() throws -> [String: Any] {
        try section("bookingSucceeded", of: section("events", of: root()))
    }

    static func bookingSucceededReservationJson() throws -> String {
        let reservation = try #require(bookingSucceededEvent()["reservation"])
        let data = try JSONSerialization.data(withJSONObject: reservation)
        return try #require(String(data: data, encoding: .utf8))
    }

    private static func root() throws -> [String: Any] {
        let data = try Data(contentsOf: url)
        return try #require(try JSONSerialization.jsonObject(with: data) as? [String: Any])
    }

    private static func section(_ key: String, of map: [String: Any]) throws -> [String: Any] {
        try #require(map[key] as? [String: Any])
    }
}
