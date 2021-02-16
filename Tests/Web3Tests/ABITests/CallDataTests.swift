//
//  File.swift
//  
//
//  Created by Andrew Podkovyrin on 14.02.2021.
//

import XCTest
@testable import Web3
import BigInt
import Foundation
#if canImport(Web3ContractABI)
@testable import Web3ContractABI
#endif


class CallDataTests: XCTestCase {
    func testDecoding1inchCallData() throws {
        let abiJSON = """
        [{"inputs":[{"internalType":"contract IOneInchCaller","name":"caller","type":"address"},{"components":[{"internalType":"contract IERC20","name":"srcToken","type":"address"},{"internalType":"contract IERC20","name":"dstToken","type":"address"},{"internalType":"address","name":"srcReceiver","type":"address"},{"internalType":"address","name":"dstReceiver","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"uint256","name":"minReturnAmount","type":"uint256"},{"internalType":"uint256","name":"guaranteedAmount","type":"uint256"},{"internalType":"uint256","name":"flags","type":"uint256"},{"internalType":"address","name":"referrer","type":"address"},{"internalType":"bytes","name":"permit","type":"bytes"}],"internalType":"struct OneInchExchange.SwapDescription","name":"desc","type":"tuple"},{"components":[{"internalType":"uint256","name":"targetWithMandatory","type":"uint256"},{"internalType":"uint256","name":"gasLimit","type":"uint256"},{"internalType":"uint256","name":"value","type":"uint256"},{"internalType":"bytes","name":"data","type":"bytes"}],"internalType":"struct IOneInchCaller.CallDescription[]","name":"calls","type":"tuple[]"}],"name":"swap","outputs":[{"internalType":"uint256","name":"returnAmount","type":"uint256"}],"stateMutability":"payable","type":"function"}]
        """

        let calldata = "0x90411a32000000000000000000000000e069cb01d06ba617bcdf789bf2ff0d5e5ca20c71000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000001c0000000000000000000000000111111111117dc0aa78b770fa6a738034120c302000000000000000000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00000000000000000000000026aad2da94c59524ac0d93f6d6cbf9071d7086f20000000000000000000000001d23118d0dd260547610b5326c2e62be7f5f6faa0000000000000000000000000000000000000000000000008ac7230489e800000000000000000000000000000000000000000000000000000063a28bb60d81200000000000000000000000000000000000000000000000000066b76871c94db300000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000014000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000001c000000000000000000000000000000000000000000000000000000000000003e0800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000a4c9f12e9d00000000000000000000000026aad2da94c59524ac0d93f6d6cbf9071d7086f2000000000000000000000000111111111117dc0aa78b770fa6a738034120c302000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2000000000000000000000003e069cb01d06ba617bcdf789bf2ff0d5e5ca20c7100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000164b3af37c000000000000000000000000000000000000000000000000000000000000000808000000000000000000000000000000000000000000000000000000000000004000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc20000000000000000000000000000001400000000000000000000000000000014000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000242e1a7d4d00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000001a4b3af37c000000000000000000000000000000000000000000000000000000000000000808000000000000000000000000000000000000000000000000000000000000044000000000000000000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000000000000000000000000010000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000064d1660f99000000000000000000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000000000001d23118d0dd260547610b5326c2e62be7f5f6faa00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"

        let web3 = Web3(rpcURL: "https://mainnet.infura.io/v3/")
        let eth = web3.eth
        let abiData = abiJSON.data(using: .utf8)!
        let contract = try eth.Contract(json: abiData, abiKey: nil, address: nil)
        let swap = contract.methods["swap"]!

        let fn = ABI.encodeFunctionSignature(swap)
        let fnsign = swap.signature
        if fn == calldata.prefix(10) {
            let decoded = try ABI.decodeParameters(swap.inputs, from: String(calldata.dropFirst(10)))
            XCTAssertNotNil(decoded)
            print(decoded)
        }
        else {
            XCTFail("ABI or call data is invalid")
        }
    }

    func testEncoding() throws {
        let enc = try ABI.encodeParameters(types: [.dynamicArray(.array(.uint(bits: 32), 3))],
                                           values: [[[1,2,3],[4,5,6]]])
        print(enc)
//        let enc = ABI.encode
    }
}
