//
//  ContractPromiseExtensions.swift
//  BigInt
//
//  Created by Koray Koska on 23.06.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

#if canImport(PromiseKit)

import PromiseKit
import Web3

// MARK: - Extensions

public extension SolidityInvocation {

    func call(block: EthereumQuantityTag = .latest) -> Promise<[String: Any]> {
        return Promise { seal in
            self.call(block: block, completion: seal.resolve)
        }
    }

    func estimateGas(from: EthereumAddress? = nil, gas: EthereumQuantity? = nil, gasPrice: EthereumQuantity? = nil, value: EthereumQuantity? = nil) -> Promise<EthereumQuantity> {
        return Promise { seal in
            self.estimateGas(from: from, gas: gas, gasPrice: gasPrice, value: value, completion: seal.resolve)
        }
    }

    func estimateGas(from: EthereumAddress? = nil, gas: EthereumQuantity? = nil, maxPriorityFeePerGas: EthereumQuantity?, maxFeePerGas: EthereumQuantity?, value: EthereumQuantity? = nil) -> Promise<EthereumQuantity> {
        return Promise { seal in
            self.estimateGas(from: from, gas: gas, maxPriorityFeePerGas: maxPriorityFeePerGas, maxFeePerGas: maxFeePerGas, value: value, completion: seal.resolve)
        }
    }
}

#if canImport(Web3PromiseKit)
import Web3PromiseKit

// MARK: - Promisable and Guaranteeable

extension SolidityTuple: Guaranteeable {}
extension SolidityWrappedValue: Guaranteeable {}
extension ABIObject: Guaranteeable {}
extension SolidityEmittedEvent: Guaranteeable {}
extension SolidityEvent: Guaranteeable {}
extension SolidityFunctionParameter: Guaranteeable {}
extension SolidityReadInvocation: Guaranteeable {}
extension SolidityPayableInvocation: Guaranteeable {}
extension SolidityNonPayableInvocation: Guaranteeable {}
extension SolidityConstructorInvocation: Guaranteeable {}
#endif

#endif
