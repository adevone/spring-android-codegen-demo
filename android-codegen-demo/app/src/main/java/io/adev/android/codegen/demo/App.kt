package io.adev.android.codegen.demo

import android.app.Application
import client.API_VERSION
import client.CodegenDependencies
import client.ETagCache
import client.HeadersProvider
import client.defaultApiModule
import io.ktor.client.HttpClient
import io.ktor.client.engine.okhttp.OkHttp
import io.ktor.client.features.defaultRequest
import io.ktor.client.request.host
import io.ktor.client.request.port
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonConfiguration
import org.kodein.di.Kodein
import org.kodein.di.KodeinAware
import org.kodein.di.erased.bind
import org.kodein.di.erased.singleton
import java.util.*

lateinit var di: Kodein

interface AppKodeinAware : KodeinAware {
    override val kodein: Kodein get() = di
}

class App : Application() {

    override fun onCreate() {
        super.onCreate()
        di = Kodein {
            import(defaultApiModule)

            bind() from singleton {
                CodegenDependencies(
                    client = HttpClient(OkHttp) {
                        defaultRequest {
                            host = "10.0.2.2"
                            port = 8080
                        }
                    },
                    headersProvider = object : HeadersProvider {

                        override fun apiVersion(): String? {
                            return API_VERSION
                        }

                        override fun deviceId(): String? {
                            return UUID.randomUUID().toString()
                        }

                        override fun deviceOS(): String? {
                            return "Android"
                        }

                    },
                    eTagCache = object : ETagCache {

                        override fun eTagFor(operationId: String): String? {
                            return null
                        }

                        override fun get(eTag: String): String {
                            return ""
                        }

                        override fun save(operationId: String, eTag: String, responseText: String) {
                            // do nothing
                        }
                    },
                    json = Json(JsonConfiguration.Stable.copy(isLenient = true))
                )
            }
        }
    }
}