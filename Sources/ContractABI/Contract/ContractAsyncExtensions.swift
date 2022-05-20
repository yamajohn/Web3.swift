import Foundation
import Web3

// MARK: - Extensions

public extension SolidityInvocation {
    func call(block: EthereumQuantityTag = .latest) async throws -> [String: Any] {
        try await withCheckedThrowingContinuation { continuation in
            call(block: block) { response, error in
                if let response = response {
                    continuation.resume(returning: response)
                }
                else {
                    continuation.resume(throwing: error ?? InvocationError.invalidInvocation)
                }
            }
        }
    }
    
    func estimateGas(
        from: EthereumAddress? = nil,
        gas: EthereumQuantity? = nil,
        gasPrice: EthereumQuantity? = nil,
        value: EthereumQuantity? = nil
    ) async throws -> EthereumQuantity {
        try await withCheckedThrowingContinuation { continuation in
            estimateGas(from: from, gas: gas, gasPrice: gasPrice, value: value) { response, error in
                if let response = response {
                    continuation.resume(returning: response)
                }
                else {
                    continuation.resume(throwing: error ?? InvocationError.invalidInvocation)
                }
            }
        }
    }
    
    func estimateGas(
        from: EthereumAddress? = nil,
        gas: EthereumQuantity? = nil,
        maxPriorityFeePerGas: EthereumQuantity?,
        maxFeePerGas: EthereumQuantity?,
        value: EthereumQuantity? = nil
    ) async throws -> EthereumQuantity {
        try await withCheckedThrowingContinuation { continuation in
            estimateGas(from: from, gas: gas, maxPriorityFeePerGas: maxPriorityFeePerGas, maxFeePerGas: maxFeePerGas, value: value) { response, error in
                if let response = response {
                    continuation.resume(returning: response)
                }
                else {
                    continuation.resume(throwing: error ?? InvocationError.invalidInvocation)
                }
            }
        }
    }
}
