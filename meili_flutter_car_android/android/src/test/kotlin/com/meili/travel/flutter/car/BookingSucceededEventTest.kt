package com.meili.travel.flutter.car

import kotlin.test.Test
import kotlin.test.assertEquals

class BookingSucceededEventTest {

    @Test
    fun `the fixture reservation JSON produces the fixture event map`() {
        val event = bookingSucceededEvent(ChannelContractFixture.bookingSucceededReservationJson)

        assertEquals(ChannelContractFixture.bookingSucceededEvent, event)
    }

    @Test
    fun `a body that is not valid JSON produces an empty reservation`() {
        listOf("", "not json", "{\"confirmationId\": ").forEach { body ->
            assertEquals(
                mapOf("type" to "bookingSucceeded", "reservation" to emptyMap<String, Any?>()),
                bookingSucceededEvent(body),
                body,
            )
        }
    }

    @Test
    fun `a body that is not a JSON object produces an empty reservation`() {
        listOf("[1, 2]", "\"x\"", "42", "null").forEach { body ->
            assertEquals(emptyMap<String, Any?>(), decodeReservation(body), body)
        }
    }

    @Test
    fun `nested values keep their JSON types`() {
        val reservation = decodeReservation(
            """{"id":"A","count":2,"big":12345678901,"price":1.5,"paid":false,"note":null,"list":[{"k":"v"}]}""",
        )

        assertEquals(
            mapOf(
                "id" to "A",
                "count" to 2,
                "big" to 12345678901L,
                "price" to 1.5,
                "paid" to false,
                "note" to null,
                "list" to listOf(mapOf("k" to "v")),
            ),
            reservation,
        )
    }
}
