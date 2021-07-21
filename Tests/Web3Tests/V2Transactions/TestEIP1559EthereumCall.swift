//
//  File.swift
//  
//
//  Created by Andrew Podkovyrin on 21.07.2021.
//

import Foundation

import XCTest
import BigInt
import Web3
import PromiseKit
import Web3PromiseKit
import Web3ContractABI

class TestEIP1559EthereumCall: XCTestCase {
    let web3 = Web3(rpcURL: "https://ropsten.infura.io/v3/0cbb4b8535bc4a928548b4d16ccf6bfa")

    func testEstimationEIP1559SendEthCall() throws {
        let exp = expectation(description: "v2 eth tx is estimated")

        let call = EthereumCall(
            from: try EthereumAddress(hex: "0x20E63D1A00a054525877C1EE4405c379F6e86168", eip55: true),
            to: try EthereumAddress(hex: "0x083fc10cE7e97CaFBaE0fE332a9c4384c5f54E45", eip55: true),
            gas: nil,
            maxPriorityFeePerGas: EthereumQuantity(quantity: 10.gwei),
            maxFeePerGas: EthereumQuantity(quantity: 80.gwei),
            value: EthereumQuantity(quantity: 1337),
            data: EthereumData([])
        )
        web3.eth.estimateGas(call: call, block: .latest) { response in
            switch response.status {
            case let .success(quantity):
                XCTAssert(quantity.quantity >= 21000)
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 60)
    }

    func testEstimationEIP1559SendTokenCall() throws {
        let exp = expectation(description: "v2 token tx is estimated")

        // DAI
        let tokenAddress = try EthereumAddress(hex: "0xad6d458402f60fd3bd25163575031acdce07538d", eip55: false)
        let contract = GenericERC20Contract(address: tokenAddress, eth: web3.eth)
        let transfer = contract.transfer(
            to: try EthereumAddress(hex: "0x083fc10cE7e97CaFBaE0fE332a9c4384c5f54E45", eip55: true),
            value: 1337
        )

        transfer.estimateGas(
            from: try EthereumAddress(hex: "0x29da7fc907ad1c59395dd196033e14e97017b791", eip55: false),
            maxPriorityFeePerGas: EthereumQuantity(quantity: 10.gwei),
            maxFeePerGas: EthereumQuantity(quantity: 80.gwei)
        ) { quantity, error in
            if let quantity = quantity {
                XCTAssert(quantity.quantity >= 51000)
            }
            else if let error = error {
                XCTFail(error.localizedDescription)
            }
            else {
                // invalid invariant
                XCTFail("Estimate: Neither quantity nor error were returned")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 60)
    }
}
