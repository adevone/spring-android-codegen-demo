package client

import kotlinx.serialization.json.Json
import kotlinx.serialization.builtins.list
import kotlinx.serialization.builtins.serializer
import client.*

sealed class PossibleResult<T> {
    abstract val model: T

    data class AnAbout(override val model: About) : PossibleResult<About>()  {
        companion object : PossibleResultParser<About, AnAbout> {
            override fun fromString(input: String, json: Json): AnAbout {
                val model = json.parse(About.serializer(), input)
                return AnAbout(model)
            }
        }
    }
    object None : PossibleResult<Unit>(), PossibleResultParser<Unit, None> {
        override val model = Unit
        override fun fromString(input: String, json: Json) = None
    }
}