// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import BigInt
import Foundation
import Web3

final class InternalABIDecoder {
    static let encodedIntSize = 32

    let data: Data
    var offset = 0

    /// Creates an `ABIDecoder`.
    init(data: Data) {
        self.data = data
    }

    /// Decodes an `ABIValue`
    func decode(type: ABIType) throws -> ABIValue {
        switch type {
        case .uint(let bits):
            return .uint(bits: bits, decodeUInt())
        case .int(let bits):
            return .int(bits: bits, decodeInt())
        case .address:
            return .address(decodeAddress())
        case .bool:
            return .bool(decodeBool())
        case .fixed(let bits, let scale):
            return .fixed(bits: bits, scale, decodeInt())
        case .ufixed(let bits, let scale):
            return .ufixed(bits: bits, scale, decodeUInt())
        case .bytes(let count):
            return .bytes(decodeBytes(count: count))
        case .function(let f):
            return try decode(function: f)
        case .array(let type, let count):
            return .array(type, try decodeArray(type: type, count: count))
        case .dynamicBytes:
            return .dynamicBytes(decodeBytes())
        case .string:
            return .string(try decodeString())
        case .dynamicArray(let type):
            return .dynamicArray(type, try decodeArray(type: type))
        case .tuple(let types):
            return .tuple(try decodeTuple(types: types))
        }
    }

    /// Decodes a dynamic array
    func decodeArray(type: ABIType) throws -> [ABIValue] {
        if case let .array(elemType, count) = type {
            return try decodeArray(type: elemType, count: count)
        }
        else {
            let count = Int(decodeUInt())
            return try decodeArray(type: type, count: count)
        }
    }

    /// Decodes a static array
    func decodeArray(type: ABIType, count: Int) throws -> [ABIValue] {
        return try decodeTuple(types: Array(repeating: type, count: count))
    }

    /// Decodes a tuple
    func decodeTuple(types: [ABIType]) throws -> [ABIValue] {
        let baseOffset = offset

        var values = [ABIValue]()
        for subtype in types {
            let value: ABIValue
            if subtype.isDynamic {
                let count = Int(decodeUInt())
                let savedOffset = offset
                offset = baseOffset + count
                value = try decode(type: subtype)
                offset = savedOffset
            } else {
                value = try decode(type: subtype)
            }
            values.append(value)
        }
        return values
    }

    /// Decodes a function call
    ///
    /// - Throws: `ABIError.functionSignatureMismatch` if the decoded signature hash doesn't match the specified function.
    func decode(function: ABIFunction) throws -> ABIValue {
        let funcSignatureString = function.description.sha3(.keccak256).prefix(8)
        let decoded = decodeSignature().toHexString()
        if funcSignatureString != decoded {
            throw ABIError.functionSignatureMismatch
        }
        let arguments = try decodeTuple(types: function.parameters)
        return .function(function, arguments)
    }

    /// Decodes a boolean field.
    func decodeBool() -> Bool {
        return decodeUInt() != BigInt(0)
    }

    /// Decodes an unsigned integer.
    func decodeUInt() -> BigUInt {
        assert(offset + Self.encodedIntSize <= data.count)
        let value = BigUInt(data.subdata(in: offset ..< offset + Self.encodedIntSize))
        offset += Self.encodedIntSize
        return value
    }

    /// Decodes a `BigInt` field.
    func decodeInt() -> BigInt {
        let unsigned = decodeUInt()
        if unsigned.leadingZeroBitCount != 0 {
            return BigInt(sign: .plus, magnitude: unsigned)
        }

        let max = BigInt(1) << (Self.encodedIntSize * 8)
        let num = BigInt(sign: .plus, magnitude: unsigned)
        return -(max - num)
    }

    /// Decodes a dynamic byte array
    func decodeBytes() -> Data {
        return decodeBytes(count: Int(decodeUInt()))
    }

    /// Decodes a static byte array
    func decodeBytes(count: Int) -> Data {
        let value = data.subdata(in: offset ..< offset + count)
        offset += count
        return value
    }

    /// Decodes an address
    func decodeAddress() -> EthereumAddress {
        let addressLength = 20
        let addressData = data.subdata(in: offset + Self.encodedIntSize - addressLength ..< offset + Self.encodedIntSize)
        let address = try! EthereumAddress(addressData)
        offset += Self.encodedIntSize
        return address
    }

    /// Decodes a string
    ///
    /// - Throws: `ABIError.invalidUTF8String` if the string cannot be decoded as UTF8.
    func decodeString() throws -> String {
        let count = Int(decodeUInt())
        guard let string = String(data: data.subdata(in: offset ..< offset + count), encoding: .utf8) else {
            throw ABIError.invalidUTF8String
        }
        offset += count
        return string
    }

    /// Decodes a function signature
    func decodeSignature() -> Data {
        let value = data.subdata(in: offset ..< offset + 4)
        offset += 4
        return value
    }
}
