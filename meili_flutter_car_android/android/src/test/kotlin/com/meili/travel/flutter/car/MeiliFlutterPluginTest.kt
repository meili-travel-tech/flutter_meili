package com.meili.travel.flutter.car

import android.app.Activity
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlin.test.Test
import org.mockito.Mockito.`when`
import org.mockito.Mockito.mock
import org.mockito.Mockito.verify
import org.mockito.Mockito.verifyNoMoreInteractions

class MeiliFlutterPluginTest {

    private fun open(env: String?): MethodChannel.Result {
        val result = mock(MethodChannel.Result::class.java)
        val arguments = ChannelContractFixture.params + ("env" to env)
        MeiliFlutterPlugin().onMethodCall(MethodCall("openMeiliViewController", arguments), result)
        return result
    }

    @Test
    fun `an unknown env fails open with INVALID_ARGUMENT`() {
        listOf("pre_prod", "production", "PROD", "", "staging", null).forEach { env ->
            val result = open(env)

            verify(result).error("INVALID_ARGUMENT", "env must be one of prod, preProd, uat, dev", null)
            verifyNoMoreInteractions(result)
        }
    }

    @Test
    fun `a valid env gets past validation to the activity check`() {
        val result = open("preProd")

        verify(result).error("NO_ACTIVITY", "No Android Activity is attached to the Flutter engine.", null)
        verifyNoMoreInteractions(result)
    }

    @Test
    fun `a host activity that is not a ComponentActivity is named in the NO_ACTIVITY error`() {
        val hostActivity = mock(Activity::class.java)
        val plugin = pluginAttachedTo(hostActivity)
        val result = mock(MethodChannel.Result::class.java)

        plugin.onMethodCall(MethodCall("openMeiliViewController", ChannelContractFixture.params), result)

        verify(result).error(
            "NO_ACTIVITY",
            "Your MainActivity must extend FlutterFragmentActivity. The Meili plugin needs " +
                "an androidx ComponentActivity host, but the attached activity " +
                "(${hostActivity.javaClass.name}) is not one.",
            null,
        )
        verifyNoMoreInteractions(result)
    }

    @Test
    fun `a detached activity goes back to the nothing attached message`() {
        val plugin = pluginAttachedTo(mock(Activity::class.java))
        plugin.onDetachedFromActivity()
        val result = mock(MethodChannel.Result::class.java)

        plugin.onMethodCall(MethodCall("openMeiliViewController", ChannelContractFixture.params), result)

        verify(result).error("NO_ACTIVITY", "No Android Activity is attached to the Flutter engine.", null)
        verifyNoMoreInteractions(result)
    }

    @Test
    fun `popToRoot is no longer a method`() {
        val result = mock(MethodChannel.Result::class.java)

        MeiliFlutterPlugin().onMethodCall(MethodCall("popToRoot", null), result)

        verify(result).notImplemented()
    }

    private fun pluginAttachedTo(activity: Activity): MeiliFlutterPlugin {
        val binding = mock(ActivityPluginBinding::class.java)
        `when`(binding.activity).thenReturn(activity)
        return MeiliFlutterPlugin().also { it.onAttachedToActivity(binding) }
    }
}
