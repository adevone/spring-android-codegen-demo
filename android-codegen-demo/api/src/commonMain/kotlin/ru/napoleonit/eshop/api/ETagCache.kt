package client

interface ETagCache {
    fun save(operationId: String, eTag: String, responseText: String)
    fun get(eTag: String): String
    fun eTagFor(operationId: String): String?
}