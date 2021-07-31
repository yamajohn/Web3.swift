//
//  File.swift
//  
//
//  Created by Andrew Podkovyrin on 17.07.2021.
//

import XCTest
import BigInt
import Web3
import PromiseKit
import Web3PromiseKit

class EthereumTransactionV2Tests: XCTestCase {
    func testV2TransactionSignature() throws {
        let privateKey = try! EthereumPrivateKey(hexPrivateKey: "0xdf09d380d685a8233cda012eae34caa49e2a74e0ee1406fe6004b60144410a19")

        let tx = try EthereumTransactionV2(
            nonce: 1,
            maxPriorityFeePerGas: EthereumQuantity(quantity: 10.gwei),
            maxFeePerGas: EthereumQuantity(quantity: 80.gwei),
            gas: 21000,
            to: EthereumAddress(hex: "0x083fc10cE7e97CaFBaE0fE332a9c4384c5f54E45", eip55: true),
            value: EthereumQuantity(quantity: BigUInt(1337))
        )

        let signed = try tx.sign(with: privateKey, chainId: 3)

        let rawTx = signed.rawTransaction()
        let expectedTx = "0x02f86e03018502540be4008512a05f200082520894083fc10ce7e97cafbae0fe332a9c4384c5f54e4582053980c080a098ba1d12e23853a635ce66dca4a4820ca9d2a1206e32571def66b2e8ce78cf75a040e5a4558cbefadf49ad476c00ae8fc21bf39d02d8a168ed5f6c207b6d414a09"
        XCTAssertEqual(rawTx, expectedTx)

        XCTAssertTrue(signed.verifySignature(), "v2 tx signature verification failed")
    }

    // rm prefix `manual_` to test
    func manual_testSendV2Transaction() throws  {
        let exp = expectation(description: "v2 tx is sent")

        let web3 = Web3(rpcURL: "https://ropsten.infura.io/v3/0cbb4b8535bc4a928548b4d16ccf6bfa")

        let privateKey = try! EthereumPrivateKey(hexPrivateKey: "0xdf09d380d685a8233cda012eae34caa49e2a74e0ee1406fe6004b60144410a19")
        firstly {
            web3.eth.getTransactionCount(address: privateKey.address, block: .latest)
        }
        .then { nonce -> Promise<EthereumSignedTransactionV2> in
            let tx = try EthereumTransactionV2(
                nonce: nonce,
                maxPriorityFeePerGas: EthereumQuantity(quantity: 10.gwei),
                maxFeePerGas: EthereumQuantity(quantity: 80.gwei),
                gas: 21000,
                to: EthereumAddress(hex: "0x083fc10cE7e97CaFBaE0fE332a9c4384c5f54E45", eip55: true),
                value: EthereumQuantity(quantity: BigUInt(1337))
            )
            let signed = try tx.sign(with: privateKey, chainId: 3) // 3 - ropsten
            return signed.promise
        }
        .then { tx in
            web3.eth.sendRawTransaction(transaction: tx.rawTransaction())
        }
        .done { hash in
            print(hash.hex())
            exp.fulfill()
        }
        .catch { error in
            XCTFail("Failed to send tx \(error)")
            exp.fulfill()
        }

        wait(for: [exp], timeout: 60)
    }
}


