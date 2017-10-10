/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

import Test
import Stream
import MessagePack

class TimestampTests: TestCase {
    func testEncode4() {
        do {
            let expected: [UInt8] = [
                0xd6, UInt8(bitPattern: -1),
                0x00, 0x00, 0x00, 0x01]

            let timestamp = Timestamp(seconds: 1, nanoseconds: 0)

            var writer = MessagePackWriter(OutputByteStream())
            try writer.encode(timestamp)
            assertEqual(writer.stream.bytes, expected)
        } catch {
            fail(String(describing: error))
        }
    }

    func testEncode8() {
        do {
            let expected: [UInt8] = [
                0xd7, UInt8(bitPattern: -1),
                0xff, 0xff, 0xff, 0xff,
                0xff, 0xff, 0xff, 0xff]

            let timestamp = Timestamp(
                seconds: 0x0003_ffff_ffff,
                nanoseconds: 0x3fff_ffff)

            var writer = MessagePackWriter(OutputByteStream())
            try writer.encode(timestamp)
            assertEqual(writer.stream.bytes, expected)
        } catch {
            fail(String(describing: error))
        }
    }

    func testEncode12() {
        do {
            let expected: [UInt8] = [
                0xc7, 12, UInt8(bitPattern: -1),
                0x00, 0x00, 0x00, 0x01,
                0x7f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff]

            let timestamp = Timestamp(seconds: Int.max, nanoseconds: 1)

            var writer = MessagePackWriter(OutputByteStream())
            try writer.encode(timestamp)
            assertEqual(writer.stream.bytes, expected)
        } catch {
            fail(String(describing: error))
        }
    }

    func testDecode4() {
        do {
            let expected = Timestamp(seconds: 1, nanoseconds: 0)

            let encoded: [UInt8] = [
                0xd6, UInt8(bitPattern: -1),
                0x00, 0x00, 0x00, 0x01]

            var reader = MessagePackReader(InputByteStream(encoded))
            let decoded = try reader.decode(Timestamp.self)
            assertEqual(decoded, expected)
        } catch {
            fail(String(describing: error))
        }
    }

    func testDecode8() {
        do {
            let expected = Timestamp(
                seconds: 0x0003_ffff_ffff,
                nanoseconds: 0x3fff_ffff)

            let encoded: [UInt8] = [
                0xd7, UInt8(bitPattern: -1),
                0xff, 0xff, 0xff, 0xff,
                0xff, 0xff, 0xff, 0xff]

            var reader = MessagePackReader(InputByteStream(encoded))
            let decoded = try reader.decode(Timestamp.self)
            assertEqual(decoded, expected)
        } catch {
            fail(String(describing: error))
        }
    }

    func testDecode12() {
        do {
            let expected = Timestamp(seconds: 1, nanoseconds: 1)

            let encoded: [UInt8] = [
                0xc7, 12, UInt8(bitPattern: -1),
                0x00, 0x00, 0x00, 0x01,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01]

            var reader = MessagePackReader(InputByteStream(encoded))
            let decoded = try reader.decode(Timestamp.self)
            assertEqual(decoded, expected)
        } catch {
            fail(String(describing: error))
        }
    }

    static var allTests = [
        ("testEncode4", testEncode4),
        ("testEncode8", testEncode8),
        ("testEncode12", testEncode12),
        ("testDecode4", testDecode4),
        ("testDecode8", testDecode8),
        ("testDecode12", testDecode12),
    ]
}