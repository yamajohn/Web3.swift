//
//  SolidityTypeTests.swift
//  Web3_Tests
//
//  Created by Josh Pyles on 6/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import Web3
import BigInt
#if canImport(Web3ContractABI)
    @testable import Web3ContractABI
#endif

class SolidityTypeTests: XCTestCase {
    
    func testDecodingStringType() {
        XCTAssertEqual(try? ABIType("string"), .string, "String type should be parsed")
        XCTAssertEqual(ABIType.string.description, "string", "Should return the correct string representation")
    }
    
    func testDecodingBoolType() {
        XCTAssertEqual(try? ABIType("bool"), .bool, "Bool type should be parsed")
        XCTAssertEqual(ABIType.bool.description, "bool", "Should return the correct string representation")
    }
    
    func testDecodingAddressType() {
        XCTAssertEqual(try? ABIType("address"), .address, "Address type should be parsed")
        XCTAssertEqual(ABIType.address.description, "address", "Should return the correct string representation")
    }
    
    func testDecodingBytesType() {
        XCTAssertEqual(try? ABIType("bytes"), .dynamicBytes, "Bytes type should be parsed")
        XCTAssertEqual(ABIType.dynamicBytes.description, "bytes", "Should return the correct string representation")
        XCTAssertEqual(try? ABIType("bytes5"), .bytes(5), "Bytes5 type should be parsed")
        XCTAssertEqual(ABIType.bytes(5).description, "bytes5", "Should return the correct string representation")
    }
    
    func testDecodingNumberTypes() {
        // uint
        XCTAssertEqual(try? ABIType("uint"), .uint(bits: 256), "Uint type should be parsed")
        XCTAssertEqual(ABIType.uint(bits: 256).description, "uint256", "Should return the correct string representation")
        XCTAssertEqual(try? ABIType("uint8"), .uint(bits: 8), "Uint8 type should be parsed")
        XCTAssertEqual(ABIType.uint(bits: 8).description, "uint8", "Should return the correct string representation")
        XCTAssertEqual(try? ABIType("uint16"), .uint(bits: 16), "Uint16 type should be parsed")
        XCTAssertEqual(ABIType.uint(bits: 16).description, "uint16", "Should return the correct string representation")
        // int
        XCTAssertEqual(try? ABIType("int"), .int(bits: 256), "Int type should be parsed")
        XCTAssertEqual(ABIType.int(bits: 256).description, "int256", "Should return the correct string representation")
        XCTAssertEqual(try? ABIType("int8"), .int(bits: 8), "Int8 type should be parsed")
        XCTAssertEqual(ABIType.int(bits: 8).description, "int8", "Should return the correct string representation")
        XCTAssertEqual(try? ABIType("int16"), .int(bits: 16), "Int16 type should be parsed")
        XCTAssertEqual(ABIType.int(bits: 16).description, "int16", "Should return the correct string representation")
    }
    
    func testDecodingArrayType() {
        XCTAssertEqual(try? ABIType("string[]"), .dynamicArray(.string), "dynamic array type should be parsed")
        XCTAssertEqual(try? ABIType("int32[]"), .dynamicArray(.int(bits: 32)), "dynamic array type should be parsed")
        XCTAssertEqual(try? ABIType("string[4]"), .array(.string, 4), "fixed array type should be parsed")
        XCTAssertEqual(try? ABIType("bytes3[10]"), .array(.bytes(3), 10), "fixed array type should be parsed")
        XCTAssertEqual(try? ABIType("string[][]"), .dynamicArray(.dynamicArray(.string)), "dynamic nested array should be parsed")
        XCTAssertEqual(try? ABIType("string[3][]"), .dynamicArray(.array(.string, 3)), "dynamic array of fixed array should be parsed")
        XCTAssertEqual(try? ABIType("string[][7]"), .array(.dynamicArray(.string), 7), "fixed array of dynamic array should be parsed")
        XCTAssertEqual(try? ABIType("string[1][2]"), .array(.array(.string, 1), 2), "fixed nested array should be parsed")
        XCTAssertEqual(try? ABIType("string[][][2]"), .array(.dynamicArray(.dynamicArray(.string)), 2), "dynamic nested array should be parsed")
    }
    
}
