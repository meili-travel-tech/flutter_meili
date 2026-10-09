package com.meili.travel.flutter.car

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlin.test.Test
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

        verify(result).error("NO_ACTIVITY", "Activity not available", null)
        verifyNoMoreInteractions(result)
    }
}
