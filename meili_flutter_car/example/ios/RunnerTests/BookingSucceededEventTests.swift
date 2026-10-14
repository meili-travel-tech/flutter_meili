import Foundation
import Testing

@testable import meili_flutter_car_ios

struct BookingSucceededEventTests {
    private func normalised(_ object: Any) throws -> String {
        let data = try JSONSerialization.data(withJSONObject: object, options: [.sortedKeys])
        return try #require(String(data: data, encoding: .utf8))
    }

    @Test
    func fixtureReservationJsonProducesTheFixtureEventMap() throws {
        let event = bookingSucceededEvent(
            reservationJson: try ChannelContractFixture.bookingSucceededReservationJson()
        )

        #expect(try normalised(event) == normalised(ChannelContractFixture.bookingSucceededEvent()))
        #expect(event["type"] as? String == "bookingSucceeded")
    }

    @Test(arguments: ["", "not json", #"{"confirmationId": "#])
    func invalidJsonProducesAnEmptyReservation(body: String) throws {
        let event = bookingSucceededEvent(reservationJson: body)

        let reservation = try #require(event["reservation"] as? [String: Any])
        #expect(event["type"] as? String == "bookingSucceeded")
        #expect(reservation.isEmpty)
    }

    @Test(arguments: ["[1, 2]", #""x""#, "42", "null"])
    func aBodyThatIsNotAnObjectProducesAnEmptyReservation(body: String) throws {
        let event = bookingSucceededEvent(reservationJson: body)

        let reservation = try #require(event["reservation"] as? [String: Any])
        #expect(reservation.isEmpty)
    }

    @Test
    func nestedValuesKeepTheirJsonTypes() throws {
        let event = bookingSucceededEvent(
            reservationJson: #"{"id":"A","count":2,"price":1.5,"paid":false,"note":null,"list":[{"k":"v"}]}"#
        )

        let reservation = try #require(event["reservation"] as? [String: Any])
        #expect(reservation["id"] as? String == "A")
        #expect(reservation["count"] as? Int == 2)
        #expect(reservation["price"] as? Double == 1.5)
        #expect(reservation["paid"] as? Bool == false)
        #expect(reservation["note"] is NSNull)
        let list = try #require(reservation["list"] as? [[String: String]])
        #expect(list == [["k": "v"]])
    }
}
