package com.flutter.meili

import android.view.View
import android.widget.FrameLayout
import androidx.activity.ComponentActivity
import com.meili.travel.api.AvailParams
import com.meili.travel.api.MeiliActivity
import com.meili.travel.api.MeiliComposeListener
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.platform.PlatformView

internal class MeiliPlatformView(
    private val activity: ComponentActivity,
    viewId: Int,
    creationParams: Map<*, *>,
    messenger: BinaryMessenger,
    private val eventSinkProvider: () -> EventChannel.EventSink?,
) : PlatformView {

    private val view = FrameLayout(activity)

    init {
        val ptid = creationParams["ptid"] as? String ?: ""
        val env = parseEnv(creationParams["env"] as? String)
        val flow = parseFlow(creationParams["flow"] as? String)
        val availParams = parseAvailParams(creationParams["availParams"] as? Map<*, *>)
            ?: AvailParams(null, null, null, null, null, null, null, null, null)
        val additionalParams = parseAdditionalParams(creationParams["bookingParams"] as? Map<*, *>)

        MeiliActivity.start(
            context = activity,
            ptid = ptid,
            env = env,
            flow = flow,
            availParams = availParams,
            additionalParams = additionalParams,
            listener = object : MeiliComposeListener {},
            onBack = {
                eventSinkProvider()?.success(mapOf("type" to "flowDismissed"))
            },
        )
    }

    override fun getView(): View = view

    override fun dispose() {}
}
