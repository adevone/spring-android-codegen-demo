package client

import com.soywiz.klock.DateFormat
import com.soywiz.klock.DateTimeTz
import com.soywiz.klock.parse
import kotlinx.serialization.Decoder
import kotlinx.serialization.Encoder
import kotlinx.serialization.KSerializer
import kotlinx.serialization.Serializer
import kotlinx.serialization.PrimitiveKind
import kotlinx.serialization.PrimitiveDescriptor

object DateTimeTzSerializer : KSerializer<DateTimeTz> {
    override val descriptor = PrimitiveDescriptor("DateTimeTz", PrimitiveKind.STRING)

    override fun deserialize(decoder: Decoder): DateTimeTz {
        val timeString = decoder.decodeString()
        return DateFormat.FORMAT1.parse(timeString)
    }

    override fun serialize(encoder: Encoder, value: DateTimeTz) {
        val timeString = DateFormat.FORMAT1.format(value)
        encoder.encodeString(timeString)
    }
}