package com.flutter.meili

import android.view.View
import androidx.activity.ComponentActivity
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.ViewCompositionStrategy
import com.meili.travel.api.MeiliCompose
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView

internal class MeiliPlatformView(
    private val activity: ComponentActivity,
    viewId: Int,
    creationParams: Map<*, *>,
    messenger: BinaryMessenger,
) : PlatformView {

    private val composeView = ComposeView(activity).apply {
        setViewCompositionStrategy(ViewCompositionStrategy.DisposeOnDetachedFromWindow)

        val ptid = creationParams["ptid"] as? String ?: ""
        val env = parseEnv(creationParams["env"] as? String)
        val flow = parseFlow(creationParams["currentFlow"] as? String)
        val availParams = parseAvailParams(creationParams["availParams"] as? Map<*, *>)
        val additionalParams = parseAdditionalParams(creationParams["bookingParams"] as? Map<*, *>)

        setContent {
            MeiliCompose(
                ptid = ptid,
                env = env,
                flow = flow,
                availParams = availParams,
                additionalParams = additionalParams,
            )
        }
    }

    override fun getView(): View = composeView

    override fun dispose() {}
}
