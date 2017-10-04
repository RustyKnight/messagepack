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
import MessagePack

class ManualHeadersTests: TestCase {
    func testEncodeArray() {
        let expected = try! MessagePack.encode(.array(["one", "two", "three"]))
        var writer = MessagePackWriter(OuputByteStream())
        let items = ["one", "two", "three"]
        try? writer.encodeArrayItemsCount(items.count)
        for item in items {
            try? writer.encode(item)
        }
        assertEqual(writer.stream.bytes, expected)
    }

    func testDecodeArray() {
        let expected = ["one", "two", "three"]
        let encoded = try? MessagePack.encode(.array(["one", "two", "three"]))
        var reader = MessagePackReader(InputByteStream(encoded ?? []))
        var result = [String]()
        do {
            let itemsCount = try reader.decodeArrayItemsCount()
            for _ in 0..<itemsCount {
                result.append(try reader.decode(String.self))
            }
        } catch {
            fail(String(describing: error))
            return
        }
        assertEqual(result, expected)
    }

    func testEncodeMap() {
        let expected = try! MessagePack.encode(
            .map(["one" : 1, "two" : 2, "three" : 3]))
        var writer = MessagePackWriter(OuputByteStream())
        let items = ["one" : 1, "two" : 2, "three" : 3]
        try? writer.encodeMapItemsCount(items.count)
        for (key, value) in items {
            try? writer.encode(key)
            try? writer.encode(value)
        }
        assertEqual(writer.stream.bytes, expected)
    }

    func testDecodeMap() {
        let expected = ["one" : 1, "two" : 2, "three" : 3]
        let encoded = try? MessagePack.encode(
            .map(["one" : 1, "two" : 2, "three" : 3]))
        var reader = MessagePackReader(InputByteStream(encoded ?? []))
        var result = [String : Int]()
        do {
            let itemsCount = try reader.decodeMapItemsCount()
            for _ in 0..<itemsCount {
                let key = try reader.decode(String.self)
                let value = try reader.decode(Int.self)
                result[key] = value
            }
        } catch {
            fail(String(describing: error))
            return
        }
        assertEqual(result, expected)
    }


    static var allTests = [
        ("testEncodeArray", testEncodeArray),
        ("testDecodeArray", testDecodeArray),
        ("testEncodeMap", testEncodeMap),
        ("testDecodeMap", testDecodeMap)
    ]
}
