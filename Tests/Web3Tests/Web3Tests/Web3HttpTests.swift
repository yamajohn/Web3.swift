//
//  Web3HttpTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 14.01.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Quick
import Nimble
@testable import Web3
import BigInt

class Web3HttpTests: QuickSpec {
    
    let infuraUrl = "https://mainnet.infura.io/v3/0cbb4b8535bc4a928548b4d16ccf6bfa"
    
    override func spec() {
        describe("http rpc requests") {
            
            let web3 = Web3(rpcURL: infuraUrl)
            
            context("web3 client version") {
                
                waitUntil(timeout: 2.0) { done in
                    web3.clientVersion { response in
                        it("should be status success") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }
                        
                        // Tests done
                        done()
                    }
                }
            }
            
            context("net version") {
                
                waitUntil(timeout: 2.0) { done in
                    web3.net.version { response in
                        it("should be status ok") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }
                        it("should be mainnet chain id") {
                            expect(response.result) == "1"
                        }
                        
                        // Tests done
                        done()
                    }
                }
            }
            
            context("net peer count") {
                
                waitUntil(timeout: 2.0) { done in
                    web3.net.peerCount { response in
                        it("should be status ok") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }
                        it("should be a quantity response") {
                            expect(response.result?.quantity).toNot(beNil())
                        }
                        
                        // Tests done
                        done()
                    }
                }
            }
            
            context("eth protocol version") {
                
                waitUntil(timeout: 2.0) { done in
                    web3.eth.protocolVersion { response in
                        it("should be status ok") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }
                        
                        // Tests done
                        done()
                    }
                }
            }
            
            context("eth syncing") {
                
                waitUntil(timeout: 2.0) { done in
                    web3.eth.syncing { response in
                        it("should be status ok") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }
                        it("should be a valid response") {
                            expect(response.result?.syncing).toNot(beNil())
                            
                            if let b = response.result?.syncing, b {
                                expect(response.result?.startingBlock).toNot(beNil())
                                expect(response.result?.currentBlock).toNot(beNil())
                                expect(response.result?.highestBlock).toNot(beNil())
                            } else {
                                expect(response.result?.startingBlock).to(beNil())
                                expect(response.result?.currentBlock).to(beNil())
                                expect(response.result?.highestBlock).to(beNil())
                            }
                        }
                        
                        // Tests done
                        done()
                    }
                }
            }
            
            context("eth mining") {
                
                waitUntil(timeout: 2.0) { done in
                    web3.eth.mining { response in
                        it("should be status ok") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }
                        it("should be a bool response") {
                            // Infura won't mine at any time or something's gonna be wrong...
                            expect(response.result) == false
                        }
                        
                        // Tests done
                        done()
                    }
                }
            }
            
            context("eth hashrate") {
                
                waitUntil(timeout: 2.0) { done in
                    web3.eth.hashrate { response in
                        it("should be status ok") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }
                        it("should be a quantity response") {
                            // Infura won't mine at any time or something's gonna be wrong...
                            expect(response.result?.quantity) == 0
                        }
                        
                        // Tests done
                        done()
                    }
                }
            }
            
            context("eth gas price") {
                
                waitUntil(timeout: 2.0) { done in
                    web3.eth.gasPrice { response in
                        it("should be status ok") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }
                        it("should be a quantity response") {
                            // Infura won't mine at any time or something's gonna be wrong...
                            expect(response.result?.quantity).toNot(beNil())
                        }
                        
                        // Tests done
                        done()
                    }
                }
            }
            
            context("eth accounts") {
                
                waitUntil(timeout: 2.0) { done in
                    web3.eth.accounts { response in
                        it("should be status ok") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }
                        it("should be an array response") {
                            // Infura should not have any accounts...
                            expect(response.result?.count) == 0
                        }
                        
                        // Tests done
                        done()
                    }
                }
            }
            
            context("eth block number") {
                
                waitUntil(timeout: 2.0) { done in
                    web3.eth.blockNumber { response in
                        it("should be status ok") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }
                        it("should be a quantity response") {
                            expect(response.result?.quantity).toNot(beNil())
                        }
                        
                        // Tests done
                        done()
                    }
                }
            }
            
            context("eth get balance") {
                
                let e = try? EthereumAddress(hex: "0x1d23118D0Dd260547610b5326C2E62bE7F5f6fAa", eip55: false)
                it("should not be nil") {
                    expect(e).toNot(beNil())
                }
                guard let ethereumAddress = e else {
                    return
                }
                
                waitUntil(timeout: 2.0) { done in
                    web3.eth.getBalance(address: ethereumAddress, block: .latest) { response in
                        it("should be status ok") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }
                        // Tests done
                        done()
                    }
                }
            }
            
            context("eth get storage at") {
                
                let e = try? EthereumAddress(hex: "0x06012c8cf97BEaD5deAe237070F9587f8E7A266d", eip55: false)
                it("should not be nil") {
                    expect(e).toNot(beNil())
                }
                guard let ethereumAddress = e else {
                    return
                }
                
                waitUntil(timeout: 2.0) { done in
                    web3.eth.getStorageAt(address: ethereumAddress, position: 0, block: .latest) { response in
                        it("should be status ok") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }
                        it("should be a data response") {
                            expect(response.result?.hex()) == "0x000000000000000000000000af1e54b359b0897133f437fc961dd16f20c045e1"
                        }
                        
                        // Tests done
                        done()
                    }
                }
            }
            
            context("eth get transaction count") {
                
                let e = try? EthereumAddress(hex: "0x1d23118D0Dd260547610b5326C2E62bE7F5f6fAa", eip55: false)
                it("should not be nil") {
                    expect(e).toNot(beNil())
                }
                guard let ethereumAddress = e else {
                    return
                }
                
                waitUntil(timeout: 2.0) { done in
                    web3.eth.getTransactionCount(address: ethereumAddress, block: .latest) { response in
                        it("should be status ok") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }
                        // Tests done
                        done()
                    }
                }
            }
            
            context("eth get transaction count by hash") {
                waitUntil(timeout: 2.0) { done in
                    do {
                        try web3.eth.getBlockTransactionCountByHash(blockHash: .string("0x596f2d863a893392c55b72b5ba29e9ba67bdaa13c31765f9119e850a62565960")) { response in
                            it("should be status ok") {
                                expect(response.status.isSuccess) == true
                            }
                            it("should not be nil") {
                                expect(response.result).toNot(beNil())
                            }
                            it("should be a quantity response") {
                                expect(response.result?.quantity) == 0xaa
                            }
                            
                            // Tests done
                            done()
                        }
                    } catch {
                        it("should not throw an error") {
                            expect(false) == true
                        }
                        done()
                    }
                }
            }
            
            context("eth get transaction count by number") {
                waitUntil(timeout: 2.0) { done in
                    Task {
                        do {
                            let count = try await web3.eth.getBlockTransactionCountByNumber(block: .block(5397389))
                            it("should be count 88") {
                                expect(count) == 88
                            }
                            done()
                        }
                        catch {
                            it("should not fail") {
                                expect(false) == true
                            }
                            done()
                        }
                    }
                }
            }
            
            context("eth get uncle count by block hash") {
                waitUntil(timeout: 2.0) { done in
                    Task {
                        do {
                            let count = try await web3.eth.getUncleCountByBlockHash(blockHash: .string("0xd8cdd624c5b4c5323f0cb8536ca31de046e3e4a798a07337489bab1bb3d822f0"))
                            it("should include one uncle") {
                                expect(count) == 1
                            }
                            done()
                        }
                        catch {
                            it("should not fail") {
                                expect(false) == true
                            }
                            done()
                        }
                    }
                }
            }
            
            context("eth get uncle count by block number") {
                waitUntil(timeout: 2.0) { done in
                    Task {
                        do {
                            let count = try await web3.eth.getUncleCountByBlockNumber(block: .block(5397429))
                            it("should include one uncle") {
                                expect(count) == 1
                            }
                            done()
                        }
                        catch {
                            it("should not fail") {
                                expect(false) == true
                            }
                            done()
                        }
                    }
                }
            }
            
            context("eth get code") {
                waitUntil(timeout: 2.0) { done in
                    Task {
                        do {
                            let code = try await web3.eth.getCode(address: EthereumAddress(hex: "0x2e704bF506b96adaC7aD1df0db461344146a4657", eip55: true), block: .block(5397525))
                            it("should be the expected data") {
                                let data: EthereumData? = try? .string("0x60606040526004361061006c5763ffffffff7c0100000000000000000000000000000000000000000000000000000000600035041663022914a78114610071578063173825d9146100a457806341c0e1b5146100c55780637065cb48146100d8578063aa1e84de146100f7575b600080fd5b341561007c57600080fd5b610090600160a060020a036004351661015a565b604051901515815260200160405180910390f35b34156100af57600080fd5b6100c3600160a060020a036004351661016f565b005b34156100d057600080fd5b6100c36101b7565b34156100e357600080fd5b6100c3600160a060020a03600435166101ea565b341561010257600080fd5b61014860046024813581810190830135806020601f8201819004810201604051908101604052818152929190602084018383808284375094965061023595505050505050565b60405190815260200160405180910390f35b60006020819052908152604090205460ff1681565b600160a060020a03331660009081526020819052604090205460ff16151561019657600080fd5b600160a060020a03166000908152602081905260409020805460ff19169055565b600160a060020a03331660009081526020819052604090205460ff1615156101de57600080fd5b33600160a060020a0316ff5b600160a060020a03331660009081526020819052604090205460ff16151561021157600080fd5b600160a060020a03166000908152602081905260409020805460ff19166001179055565b6000816040518082805190602001908083835b602083106102675780518252601f199092019160209182019101610248565b6001836020036101000a0380198251168184511617909252505050919091019250604091505051809103902090509190505600a165627a7a7230582085affe2ee33a8eb3900e773ef5a0d7f1bc95448e61a845ef36e00e6d6b4872cf0029")
                                expect(code) == data
                            }
                            done()
                        }
                        catch {
                            it("should not fail") {
                                expect(false) == true
                            }
                            done()
                        }
                    }
                }
            }
            
            context("eth call") {
                waitUntil(timeout: 2.0) { done in
                    Task {
                        do {
                            let call = try EthereumCall(
                                from: nil,
                                to: EthereumAddress(hex: "0x2e704bf506b96adac7ad1df0db461344146a4657", eip55: false),
                                gas: nil,
                                gasPrice: nil,
                                value: nil,
                                data: EthereumData(
                                    ethereumValue: "0xaa1e84de000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000046461766500000000000000000000000000000000000000000000000000000000"
                                )
                            )
                            let data = try await web3.eth.call(call: call, block: .latest)
                            let expectedData: EthereumData = try .string("0x5e2393c41c2785095aa424cf3e033319468b6dcebda65e61606ee2ae2a198a87")
                            it("should be the expected data") {
                                expect(data) == expectedData
                            }
                            done()
                        }
                        catch {
                            it("should not fail") {
                                expect(false) == true
                            }
                            done()
                        }
                    }
                }
            }
            
            context("eth estimate gas") {
                waitUntil(timeout: 2.0) { done in
                    Task {
                        do {
                            let call = try EthereumCall(
                                from: nil,
                                to: EthereumAddress(hex: "0x2e704bf506b96adac7ad1df0db461344146a4657", eip55: false),
                                gas: nil,
                                gasPrice: nil,
                                value: nil,
                                data: EthereumData(
                                    ethereumValue: "0xaa1e84de000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000046461766500000000000000000000000000000000000000000000000000000000"
                                )
                            )
                            let quantity = try await web3.eth.estimateGas(call: call, block: .latest)
                            let expectedQuantity: EthereumQuantity = try .string("0x56d4")
                            it("should be the expected quantity") {
                                expect(quantity) == expectedQuantity
                            }
                            done()
                        }
                        catch {
                            it("should not fail") {
                                expect(false) == true
                            }
                            done()
                        }
                    }
                }
            }
        }
    }
}
