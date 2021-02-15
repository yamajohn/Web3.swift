//
//  ABIDecoder.swift
//  Web3
//
//  Created by Josh Pyles on 5/21/18.
//

import Foundation
import BigInt
#if !Web3CocoaPods
    import Web3
#endif

class ABIDecoder {
    
    enum Error: Swift.Error {
        case typeNotSupported(type: ABIType)
        case couldNotParseLength
        case doesNotMatchSignature(event: SolidityEvent, log: EthereumLogObject)
        case associatedTypeNotFound(type: ABIType)
        case couldNotDecodeType(type: ABIType, string: String)
        case unknownError
    }

    // MARK: - Decoding
    
    public class func decode(_ type: ABIType, from hexString: String) throws -> Any {
        if let decoded = try decode([type], from: hexString).first {
            return decoded
        }
        throw Error.unknownError
    }
    
    public class func decode(_ types: ABIType..., from hexString: String) throws -> [Any] {
        return try decode(types, from: hexString)
    }
    
    public class func decode(_ types: [ABIType], from hexString: String) throws -> [Any] {
        // Strip out leading 0x if included
        let hexString = hexString.replacingOccurrences(of: "0x", with: "")
        let data = Data(hex: hexString)
        let decoder = InternalABIDecoder(data: data)
        let values = try decoder.decodeTuple(types: types)
        return values.map(\.nativeValue)
    }
    
    public class func decode(outputs: [SolidityParameter], from hexString: String) throws -> [String: Any] {
        let types = outputs.map(\.type)
        let hexString = hexString.replacingOccurrences(of: "0x", with: "")
        let data = Data(hex: hexString)
        let decoder = InternalABIDecoder(data: data)
        let values = try decoder.decodeTuple(types: types)

        var result = [String: Any]()
        for (parameter, value) in zip(outputs, values) {
            result[parameter.name] = try value.mapParameter(parameter)
        }
        return result
    }

    // MARK: Event Values
    
    static func decode(event: SolidityEvent, from log: EthereumLogObject) throws -> [String: Any] {
        typealias Param = SolidityEvent.Parameter
        var values = [String: Any]()
        // determine if this event is eligible to be decoded from this log
        var topics = log.topics.makeIterator()
        // anonymous events don't include their signature in the topics
        if !event.anonymous {
            if let signatureTopic = topics.next() {
                let eventSignature = ABI.encodeEventSignature(event)
                if signatureTopic.hex() != eventSignature {
                    throw Error.doesNotMatchSignature(event: event, log: log)
                }
            }
        }
        //split indexed and non-indexed parameters
        let splitParams: (([Param], [Param]), Param) -> ([Param], [Param]) = { accumulator, value in
            var (indexed, nonIndexed) = accumulator
            if value.indexed {
                indexed.append(value)
            } else {
                nonIndexed.append(value)
            }
            return (indexed, nonIndexed)
        }
        
        let (indexedParameters, nonIndexedParameters) = event.inputs.reduce(([], []), splitParams)
        // decode indexed values
        for param in indexedParameters {
            if let topicData = topics.next() {
                if !param.type.isDynamic {
                    values[param.name] = try decode(param.type, from: topicData.hex())
                } else {
                    values[param.name] = topicData.hex()
                }
            }
        }
        // decode non-indexed values
        if nonIndexedParameters.count > 0 {
            for (key, value) in try decode(outputs: nonIndexedParameters, from: log.data.hex()) {
                values[key] = value
            }
        }
        return values
    }
}

extension ABIValue {
    func mapParameter(_ parameter: SolidityParameter) throws -> Any {
        switch self {
        case let .tuple(values):
            if let components = parameter.components {
                var internals = [String: Any]()
                for (component, value) in zip(components, values) {
                    internals[component.name] = try value.mapParameter(component)
                }
                return internals
            }
            else {
                return [parameter.name: values]
            }
        case let .dynamicArray(_, values):
            var internals = [Any]()
            for value in values {
                internals.append(try value.mapParameter(parameter))
            }
            return internals
        case let .array(_, values):
            var internals = [Any]()
            for value in values {
                internals.append(try value.mapParameter(parameter))
            }
            return internals
        case .function:
            throw ABIDecoder.Error.typeNotSupported(type: self.type)
        default:
            break
        }
        return nativeValue
    }
}
