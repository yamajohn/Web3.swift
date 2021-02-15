//
//  WrappedValueTests.swift
//  Web3_Tests
//
//  Created by Josh Pyles on 6/7/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import BigInt
import Web3
#if canImport(Web3ContractABI)
    @testable import Web3ContractABI
#endif

class SolidityWrappedValueTests: XCTestCase {
    
    func testUInt() {
        let uint8 = UInt8(0)
        let uint16 = UInt16(0)
        let uint32 = UInt32(0)
        let uint64 = UInt64(0)
        let uint256 = BigUInt(0)
        
        XCTAssertEqual(SolidityWrappedValue.uint(uint8).type, .uint(bits: 8))
        XCTAssertEqual(SolidityWrappedValue.uint(uint16).type, .uint(bits: 16))
        XCTAssertEqual(SolidityWrappedValue.uint(uint32).type, .uint(bits: 32))
        XCTAssertEqual(SolidityWrappedValue.uint(uint64).type, .uint(bits: 64))
        XCTAssertEqual(SolidityWrappedValue.uint(uint256).type, .uint(bits: 256))
    }
    
    func testInt() {
        let int8 = Int8(0)
        let int16 = Int16(0)
        let int32 = Int32(0)
        let int64 = Int64(0)
        let int256 = BigInt(0)
        
        XCTAssertEqual(SolidityWrappedValue.int(int8).type, .int(bits: 8))
        XCTAssertEqual(SolidityWrappedValue.int(int16).type, .int(bits: 16))
        XCTAssertEqual(SolidityWrappedValue.int(int32).type, .int(bits: 32))
        XCTAssertEqual(SolidityWrappedValue.int(int64).type, .int(bits: 64))
        XCTAssertEqual(SolidityWrappedValue.int(int256).type, .int(bits: 256))
    }
    
    func testString() {
        let string = SolidityWrappedValue.string("hi!")
        XCTAssertEqual(string.type, .string)
    }
    
    func testBytes() {
        let bytes = Data("hi!".utf8)
        XCTAssertEqual(SolidityWrappedValue.bytes(bytes).type, .dynamicBytes)
        XCTAssertEqual(SolidityWrappedValue.fixedBytes(bytes).type, .bytes(bytes.count))
    }
    
    func testArray() {
        let array = ["one", "two", "three"]
        XCTAssertEqual(SolidityWrappedValue.array(array).type, .dynamicArray(.string))
        XCTAssertEqual(SolidityWrappedValue.fixedArray(array).type, .array(.string, 3))
    }
    
    func testNestedArray() {
        let array = [["one", "two"], ["three"]]
        let deepNestedArray = [[["one"], ["two"]], [["three"]]]
        XCTAssertEqual(SolidityWrappedValue.array(array).type, .dynamicArray(.dynamicArray(.string)))
        XCTAssertEqual(SolidityWrappedValue.array(deepNestedArray).type, .dynamicArray(.dynamicArray(.dynamicArray(.string))))
    }
    
    func testAddress() {
        let address = EthereumAddress.testAddress
        XCTAssertEqual(SolidityWrappedValue.address(address).type, .address)
    }
    
    func testBool() {
        let bool = false
        XCTAssertEqual(SolidityWrappedValue.bool(bool).type, .bool)
    }
    
}
