//
//  RawEthereumTransaction.swift
//  
//
//  Created by Andrew Podkovyrin on 18.07.2021.
//

import Foundation

public protocol RawTransactionConvertible {
    func rawTransaction() -> String
}
