package client

import io.ktor.client.HttpClient
import kotlinx.serialization.json.Json

class CodegenDependencies(
    val client: HttpClient,
    val headersProvider: HeadersProvider,
    val eTagCache: ETagCache,
    val json: Json
)

const val API_VERSION = "0.1"