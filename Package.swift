// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Web3",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(name: "Web3", targets: ["Web3"]),
        .library(name: "Web3PromiseKit", targets: ["Web3PromiseKit"]),
        .library(name: "Web3ContractABI", targets: ["Web3ContractABI"]),
    ],
    dependencies: [
        // Core dependencies
        .package(url: "https://github.com/attaswift/BigInt.git", from: "5.3.0"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.4.1"),
        .package(name: "secp256k1", url: "https://github.com/1inch/secp256k1.swift", from: "0.2.2"),

        // PromiseKit dependency
        .package(url: "https://github.com/mxcl/PromiseKit.git", from: "6.15.3"),

        // Test dependencies
        .package(url: "https://github.com/Quick/Quick.git", from: "3.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "8.1.2"),
    ],
    targets: [
        .target(
            name: "Web3",
            dependencies: [
                .product(name: "BigInt", package: "BigInt"),
                .product(name: "CryptoSwift", package: "CryptoSwift"),
                .product(name: "secp256k1", package: "secp256k1"),
            ],
            path: "Sources/Core"
        ),
        .target(
            name: "Web3PromiseKit",
            dependencies: [
                .target(name: "Web3"),
                .product(name: "PromiseKit", package: "PromiseKit"),
            ],
            path: "Sources/PromiseKit"
        ),
        .target(
            name: "Web3ContractABI",
            dependencies: [
                .target(name: "Web3"),
                .product(name: "BigInt", package: "BigInt"),
                .product(name: "CryptoSwift", package: "CryptoSwift"),
            ],
            path: "Sources/ContractABI"
        ),
        .testTarget(
            name: "Web3Tests",
            dependencies: [
                .target(name: "Web3"),
                .target(name: "Web3PromiseKit"),
                .target(name: "Web3ContractABI"),
                .product(name: "Quick", package: "Quick"),
                .product(name: "Nimble", package: "Nimble"),
            ]
        ),
    ]
)
