package client

interface HeadersProvider {
    fun deviceOS(): String?
    fun deviceId(): String?
    fun apiVersion(): String?
}