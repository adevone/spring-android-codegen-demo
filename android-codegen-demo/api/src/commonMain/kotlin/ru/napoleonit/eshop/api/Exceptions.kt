package client

class ApiRequestException(cause: Throwable? = null) : RuntimeException(cause)

class GetCacheException(cause: Throwable? = null) : RuntimeException(cause)

class ParseException(cause: Throwable, message: String = cause.message ?: "") : RuntimeException(message, cause)

class ResultNotMatchException(val result: PossibleResult<*>) : RuntimeException()

class ResultKeyUndefinedException : RuntimeException()

class UndefinedResultException(result: String) : RuntimeException(result)

class NoETagException(val url: String) : RuntimeException()

/**
 * При обработке с помощью when всегда должна быть ниже всех своих наследников
 */
abstract class ApiException(
    val httpCode: Int = 500,
    message: String = "",
    cause: Throwable? = null
) : RuntimeException(
    message,
    cause
)

class UndefinedApiException(
    httpCode: Int = 500,
    message: String = "undefined exception occurred httpCode=$httpCode",
    cause: Throwable? = null
) : ApiException(
    httpCode = httpCode,
    message = message,
    cause = cause
)