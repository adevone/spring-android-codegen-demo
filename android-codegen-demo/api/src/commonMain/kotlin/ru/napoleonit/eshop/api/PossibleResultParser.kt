package client

import kotlinx.serialization.json.Json

interface PossibleResultParser<TModel, TResult : PossibleResult<TModel>> {
    fun fromString(input: String, json: Json): TResult
}