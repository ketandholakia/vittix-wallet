package com.example.expense_tracker

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.provider.Telephony

class SmsCaptureReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Telephony.Sms.Intents.SMS_RECEIVED_ACTION) return

        val store = SmsCaptureStore(context)
        for (message in Telephony.Sms.Intents.getMessagesFromIntent(intent)) {
            val body = message.messageBody ?: continue
            store.append(
                CapturedSms(
                    id = "${message.originatingAddress ?: "unknown"}:${message.timestampMillis}:${body.hashCode()}",
                    address = message.originatingAddress ?: "",
                    body = body,
                    date = message.timestampMillis,
                )
            )
        }
    }
}
