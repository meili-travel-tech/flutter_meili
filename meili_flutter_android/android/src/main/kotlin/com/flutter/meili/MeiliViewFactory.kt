package com.flutter.meili

import android.content.Context
import androidx.activity.ComponentActivity
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

internal class MeiliViewFactory(
    private val messenger: BinaryMessenger,
    private val activityProvider: () -> ComponentActivity?,
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val params = args as? Map<*, *> ?: emptyMap<String, Any>()
        return MeiliPlatformView(
            activity = activityProvider() ?: error("Activity not available for MeiliPlatformView"),
            viewId = viewId,
            creationParams = params,
            messenger = messenger,
        )
    }
}
