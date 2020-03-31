package client

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

import kotlinx.serialization.*
import com.soywiz.klock.DateTimeTz

/**
 * About
 */
@Serializable
data class About(
    @SerialName("title") override val title: String = "",
    @SerialName("text") override val text: String = ""
) : AboutContract 

interface AboutContract {
    val title: String
    val text: String
}
