//
//  File.swift
//  
//
//  Created by Andrew Podkovyrin on 17.07.2021.
//

import XCTest
import BigInt
import Web3

class EthereumTransactionV2Tests: XCTestCase {
    func testEstimation() throws {
        let call = EthereumCall(
            from: try EthereumAddress(hex: "0x1d23118D0Dd260547610b5326C2E62bE7F5f6fAa", eip55: true),
            to: try EthereumAddress(hex: "0x083fc10cE7e97CaFBaE0fE332a9c4384c5f54E45", eip55: true),
            maxPriorityFeePerGas: EthereumQuantity(quantity: 10.gwei),
            maxFeePerGas: EthereumQuantity(quantity: 80.gwei),
            value: EthereumQuantity(quantity: 1337),
            data: EthereumData([])
        )

        let web3 = Web3(rpcURL: "https://ropsten.infura.io/v3/0cbb4b8535bc4a928548b4d16ccf6bfa")

        let exp = expectation(description: "call is estimated")
        web3.eth.estimateGas(call: call, block: .latest) { response in
            switch response.status {
            case .success(let quantity):
                XCTAssertEqual(quantity, EthereumQuantity(quantity: 21000))
            case .failure(let error):
                XCTFail("\(error)")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 60)
    }

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
        
        Task {
            do {
                let nonce = try await web3.eth.getTransactionCount(address: privateKey.address, block: .latest)
                let tx = try EthereumTransactionV2(
                    nonce: nonce,
                    maxPriorityFeePerGas: EthereumQuantity(quantity: 10.gwei),
                    maxFeePerGas: EthereumQuantity(quantity: 80.gwei),
                    gas: 21000,
                    to: EthereumAddress(hex: "0x083fc10cE7e97CaFBaE0fE332a9c4384c5f54E45", eip55: true),
                    value: EthereumQuantity(quantity: BigUInt(1337))
                )
                let signed = try tx.sign(with: privateKey, chainId: 3) // 3 - ropsten
                
                let hash = try await web3.eth.sendRawTransaction(transaction: signed.rawTransaction())
                print(hash.hex())
                exp.fulfill()
            }
            catch {
                XCTFail("Failed to send tx \(error)")
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 60)
    }
}


