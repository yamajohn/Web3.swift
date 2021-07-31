//
//  EthereumTransactionContainer.swift
//  
//
//  Created by Andrew Podkovyrin on 18.07.2021.
//

import Foundation

public enum EthereumTransactionContainer {
    /// Legacy (0xC0) transaction
    case legacy(EthereumTransaction)
    /// EIP-1559 (0x02) transaction
    case v2(EthereumTransactionV2)
}

extension EthereumTransactionContainer {
    var from: EthereumAddress? {
        switch self {
        case let .legacy(tx):
            return tx.from
        case let .v2(tx):
            return tx.from
        }
    }
}
