package com.meili.travel.flutter.car

import kotlinx.serialization.SerializationException
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonArray
import kotlinx.serialization.json.JsonElement
import kotlinx.serialization.json.JsonNull
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.JsonPrimitive
import kotlinx.serialization.json.booleanOrNull
import kotlinx.serialization.json.doubleOrNull
import kotlinx.serialization.json.longOrNull

internal fun bookingSucceededEvent(reservationJson: String): Map<String, Any?> =
    mapOf("type" to "bookingSucceeded", "reservation" to decodeReservation(reservationJson))

/** An undecodable or non-object body becomes an empty map, like the Dart side expects. */
internal fun decodeReservation(reservationJson: String): Map<String, Any?> {
    val element = try {
        Json.parseToJsonElement(reservationJson)
    } catch (_: SerializationException) {
        return emptyMap()
    }
    return (element as? JsonObject)?.mapValues { it.value.toChannelValue() } ?: emptyMap()
}

/** Converts to the types the standard method codec carries; integral numbers narrow to Int when they fit. */
internal fun JsonElement.toChannelValue(): Any? = when (this) {
    is JsonNull -> null
    is JsonObject -> mapValues { it.value.toChannelValue() }
    is JsonArray -> map { it.toChannelValue() }
    is JsonPrimitive -> toChannelPrimitive()
}

private fun JsonPrimitive.toChannelPrimitive(): Any? {
    if (isString) return content
    booleanOrNull?.let { return it }
    longOrNull?.let { return if (it in Int.MIN_VALUE..Int.MAX_VALUE) it.toInt() else it }
    return doubleOrNull
}
