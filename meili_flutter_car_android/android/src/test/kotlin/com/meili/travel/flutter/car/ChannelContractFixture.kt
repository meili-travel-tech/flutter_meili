package com.meili.travel.flutter.car

import java.io.File
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonArray
import kotlinx.serialization.json.JsonElement
import kotlinx.serialization.json.JsonNull
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.JsonPrimitive
import kotlinx.serialization.json.booleanOrNull
import kotlinx.serialization.json.doubleOrNull
import kotlinx.serialization.json.longOrNull

internal typealias ChannelMap = Map<String, Any?>

/** The platform interface's channel fixture, decoded the way the standard method codec delivers it. */
internal object ChannelContractFixture {
    private val file = File("../../meili_flutter_car_platform_interface/test/fixtures/channel_contract.json")

    private val root: ChannelMap by lazy { decode(Json.parseToJsonElement(file.readText())).asMap() }

    val params: ChannelMap get() = root.getValue("params").asMap()

    val availParams: ChannelMap get() = params.getValue("availParams").asMap()

    val additionalParams: ChannelMap get() = params.getValue("additionalParams").asMap()

    @Suppress("UNCHECKED_CAST")
    private fun Any?.asMap() = this as ChannelMap

    private fun decode(element: JsonElement): Any? = when (element) {
        is JsonNull -> null
        is JsonObject -> element.mapValues { decode(it.value) }
        is JsonArray -> element.map { decode(it) }
        is JsonPrimitive -> decodePrimitive(element)
    }

    private fun decodePrimitive(element: JsonPrimitive): Any? {
        if (element.isString) return element.content
        element.booleanOrNull?.let { return it }
        element.longOrNull?.let { return if (it in Int.MIN_VALUE..Int.MAX_VALUE) it.toInt() else it }
        return element.doubleOrNull
    }
}
