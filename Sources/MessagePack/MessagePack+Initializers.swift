/******************************************************************************
 *                                                                            *
 * Tris Foundation disclaims copyright to this source code.                   *
 * In place of a legal notice, here is a blessing:                            *
 *                                                                            *
 *     May you do good and not evil.                                          *
 *     May you find forgiveness for yourself and forgive others.              *
 *     May you share freely, never taking more than you give.                 *
 *                                                                            *
 ******************************************************************************
 *  This file contains code that has not yet been described                   *
 ******************************************************************************/

extension MessagePack {
    public init() {
        self = .`nil`
    }

    public init(_ value: Bool) {
        self = .bool(value)
    }

    public init(_ value: String) {
        self = .string(value)
    }

    public init(_ value: Float) {
        self = .float(value)
    }

    public init(_ value: Double) {
        self = .double(value)
    }

    public init(_ value: Int) {
        self = .int(value)
    }

    public init(_ value: Int8) {
        self = .int(Int(value))
    }

    public init(_ value: Int16) {
        self = .int(Int(value))
    }

    public init(_ value: Int32) {
        self = .int(Int(value))
    }

    public init(_ value: Int64) {
        self = .int(Int(value))
    }

    public init(_ value: UInt) {
        self = .uint(value)
    }

    public init(_ value: UInt8) {
        self = .uint(UInt(value))
    }

    public init(_ value: UInt16) {
        self = .uint(UInt(value))
    }

    public init(_ value: UInt32) {
        self = .uint(UInt(value))
    }

    public init(_ value: UInt64) {
        self = .uint(UInt(value))
    }

    public init(_ value: [MessagePack]) {
        self = .array(value)
    }

    public init(_ value: [MessagePack : MessagePack]) {
        self = .map(value)
    }

    public init(_ value: [UInt8]) {
        self = .binary(value)
    }

    public init(_ value: MessagePack.Extended) {
        self = .extended(value)
    }
}
