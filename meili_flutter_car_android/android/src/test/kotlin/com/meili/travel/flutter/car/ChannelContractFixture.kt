package com.meili.travel.flutter.car

import java.io.File
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.jsonObject

internal typealias ChannelMap = Map<String, Any?>

/** The platform interface's channel fixture, decoded the way the standard method codec delivers it. */
internal object ChannelContractFixture {
    private val file = File("../../meili_flutter_car_platform_interface/test/fixtures/channel_contract.json")

    private val rootElement: JsonObject by lazy { Json.parseToJsonElement(file.readText()).jsonObject }

    private val root: ChannelMap by lazy { rootElement.toChannelValue().asMap() }

    val params: ChannelMap get() = root.getValue("params").asMap()

    val availParams: ChannelMap get() = params.getValue("availParams").asMap()

    val additionalParams: ChannelMap get() = params.getValue("additionalParams").asMap()

    val availParamsBlank: ChannelMap
        get() = root.getValue("paramsBlank").asMap().getValue("availParams").asMap()

    val bookingSucceededEvent: ChannelMap
        get() = root.getValue("events").asMap().getValue("bookingSucceeded").asMap()

    val bookingSucceededReservationJson: String
        get() = rootElement.getValue("events").jsonObject
            .getValue("bookingSucceeded").jsonObject
            .getValue("reservation").toString()

    @Suppress("UNCHECKED_CAST")
    private fun Any?.asMap() = this as ChannelMap
}
