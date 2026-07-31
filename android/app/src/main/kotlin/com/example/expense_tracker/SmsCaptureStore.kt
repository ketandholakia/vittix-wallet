package com.example.expense_tracker

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject

data class CapturedSms(
    val id: String,
    val address: String,
    val body: String,
    val date: Long,
)

class SmsCaptureStore(private val context: Context) {
    private val prefs = context.getSharedPreferences("sms_capture_queue", Context.MODE_PRIVATE)
    private val key = "pending_sms"

    fun append(entry: CapturedSms) {
        val items = readAllJson()
        items.put(entry.toJson())
        prefs.edit().putString(key, items.toString()).apply()
    }

    fun pullAll(): List<Map<String, Any?>> {
        val items = readAllJson()
        prefs.edit().remove(key).apply()
        val result = ArrayList<Map<String, Any?>>(items.length())
        for (i in 0 until items.length()) {
            val json = items.getJSONObject(i)
            result.add(
                mapOf(
                    "id" to json.optString("id"),
                    "address" to json.optString("address"),
                    "body" to json.optString("body"),
                    "date" to json.optLong("date"),
                )
            )
        }
        return result
    }

    private fun readAllJson(): JSONArray {
        val raw = prefs.getString(key, null) ?: return JSONArray()
        return JSONArray(raw)
    }
}

private fun CapturedSms.toJson(): JSONObject = JSONObject()
    .put("id", id)
    .put("address", address)
    .put("body", body)
    .put("date", date)
