package client

import com.fasterxml.jackson.annotation.JsonProperty


/**
 * About
 */
data class About(
    @get:JsonProperty("title") override val title: String = "",
    @get:JsonProperty("text") override val text: String = ""
) : AboutContract 

interface AboutContract {
    val title: String
    val text: String
}
