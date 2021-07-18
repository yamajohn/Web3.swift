//
//  EthereumTransactionError.swift
//  
//
//  Created by Andrew Podkovyrin on 17.07.2021.
//

import Foundation

public enum EthereumTransactionError: Swift.Error {
    case transactionInvalid
    case rlpItemInvalid
    case signatureMalformed
}
