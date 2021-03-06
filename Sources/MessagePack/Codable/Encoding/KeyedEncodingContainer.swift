/******************************************************************************
 *                                                                            *
 * Tris Foundation disclaims copyright to this source code.                   *
 * In place of a legal notice, here is a blessing:                            *
 *                                                                            *
 *     May you do good and not evil.                                          *
 *     May you find forgiveness for yourself and forgive others.              *
 *     May you share freely, never taking more than you give.                 *
 *                                                                            *
 ******************************************************************************/

final class TypeErasedMessagePackKeyedEncodingContainer: MessagePackContainer {
    var values: [MessagePack : MessagePackContainerType] = [:]

    var value: MessagePack {
        var values = [MessagePack : MessagePack]()
        for (key, value) in self.values {
            switch value {
            case .value(let value):
                values[key] = value
            case .container(let container):
                values[key] = container.value
            }
        }
        return .map(values)
    }
}

final class MessagePackKeyedEncodingContainer<K : CodingKey>
: KeyedEncodingContainerProtocol {
    typealias Key = K

    var codingPath: [CodingKey] {
        return []
    }

    let encoder: MessagePackEncoder
    let container: TypeErasedMessagePackKeyedEncodingContainer

    init(
        encoder: MessagePackEncoder,
        container: TypeErasedMessagePackKeyedEncodingContainer
    ) {
        self.encoder = encoder
        self.container = container
    }

    func encodeNil(forKey key: K) throws {
        container.values[key.messagePackKey] = .value(.nil)
    }

    func encode(_ value: Bool, forKey key: K) throws {
        container.values[key.messagePackKey] = .value(.bool(value))
    }

    func encode(_ value: Int, forKey key: K) throws {
        container.values[key.messagePackKey] = .value(.int(value))
    }

    func encode(_ value: Int8, forKey key: K) throws {
        container.values[key.messagePackKey] = .value(.int(Int(value)))
    }

    func encode(_ value: Int16, forKey key: K) throws {
        container.values[key.messagePackKey] = .value(.int(Int(value)))
    }

    func encode(_ value: Int32, forKey key: K) throws {
        container.values[key.messagePackKey] = .value(.int(Int(value)))
    }

    func encode(_ value: Int64, forKey key: K) throws {
        container.values[key.messagePackKey] = .value(.int(Int(value)))
    }

    func encode(_ value: UInt, forKey key: K) throws {
        container.values[key.messagePackKey] = .value(.uint(UInt(value)))
    }

    func encode(_ value: UInt8, forKey key: K) throws {
        container.values[key.messagePackKey] = .value(.uint(UInt(value)))
    }

    func encode(_ value: UInt16, forKey key: K) throws {
        container.values[key.messagePackKey] = .value(.uint(UInt(value)))
    }

    func encode(_ value: UInt32, forKey key: K) throws {
        container.values[key.messagePackKey] = .value(.uint(UInt(value)))
    }

    func encode(_ value: UInt64, forKey key: K) throws {
        container.values[key.messagePackKey] = .value(.uint(UInt(value)))
    }

    func encode(_ value: Float, forKey key: K) throws {
        container.values[key.messagePackKey] = .value(.float(value))
    }

    func encode(_ value: Double, forKey key: K) throws {
        container.values[key.messagePackKey] = .value(.double(value))
    }

    func encode(_ value: String, forKey key: K) throws {
        container.values[key.messagePackKey] = .value(.string(value))
    }

    func encode<T>(
        _ value: T, forKey key: K
    ) throws where T : Encodable {
        let encoder = MessagePackEncoder()
        try value.encode(to: encoder)
        container.values[key.messagePackKey] = .value(encoder.value)
    }

    func nestedContainer<NestedKey>(
        keyedBy keyType: NestedKey.Type, forKey key: K
    ) -> KeyedEncodingContainer<NestedKey> {
        let typeErasedContainer = TypeErasedMessagePackKeyedEncodingContainer()
        let container = MessagePackKeyedEncodingContainer<NestedKey>(
            encoder: encoder, container: typeErasedContainer)
        self.container.values[key.messagePackKey] = .container(
            typeErasedContainer)
        return KeyedEncodingContainer(container)
    }

    func nestedUnkeyedContainer(
        forKey key: K
    ) -> UnkeyedEncodingContainer {
        let container = MessagePackUnkeyedEncodingContainer(encoder)
        self.container.values[key.messagePackKey] = .container(container)
        return container
    }

    func superEncoder() -> Encoder {
        return encoder
    }

    func superEncoder(forKey key: K) -> Encoder {
        // NOTE: actually works as nested container
        let encoder = MessagePackEncoder()
        container.values[key.messagePackKey] = .container(encoder)
        return encoder
    }
}
