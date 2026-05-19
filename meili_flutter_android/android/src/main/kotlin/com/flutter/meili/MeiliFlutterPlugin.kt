package com.flutter.meili

import android.content.Intent
import androidx.activity.ComponentActivity
import com.meili.travel.api.MeiliActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class MeiliFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel
    private var activity: ComponentActivity? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "meili_flutter_android")
        channel.setMethodCallHandler(this)

        binding.platformViewRegistry.registerViewFactory(
            "flutter_meili/meili_view",
            MeiliViewFactory(binding.binaryMessenger) { activity },
        )
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "openMeiliViewController" -> {
                val act = activity ?: run {
                    result.error("NO_ACTIVITY", "Activity not available", null)
                    return
                }
                @Suppress("UNCHECKED_CAST")
                val args = call.arguments as Map<String, Any?>
                val ptid = args["ptid"] as? String ?: run {
                    result.error("MISSING_PTID", "ptid is required", null)
                    return
                }
                val envName = parseEnv(args["env"] as? String).name

                val intent = Intent(act, MeiliActivity::class.java).apply {
                    putExtra("PTID", ptid)
                    putExtra("ENV", envName)
                }
                act.startActivity(intent)
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity as? ComponentActivity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity as? ComponentActivity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}
