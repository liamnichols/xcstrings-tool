// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

let package = Package(
    name: "XCStringsTool",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "xcstrings-tool", targets: ["xcstrings-tool"]),
        .plugin(name: "XCStringsToolPlugin", targets: ["XCStringsToolPlugin"]),
        .library(name: "StringCatalog", targets: ["StringCatalog"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.3"),
        .package(url: "https://github.com/apple/swift-syntax.git", "509.0.0" ..< "601.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.13.0"),
        .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Documentation"
        ),

        .executableTarget(
            name: "xcstrings-tool",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .target(name: "StringCatalog"),
                .target(name: "StringExtractor"),
                .target(name: "StringGenerator"),
                .target(name: "StringResource"),
                .target(name: "StringSource"),
                .target(name: "StringValidator"),
                .target(name: "XCStringsToolConstants")
            ]
        ),

        .plugin(
            name: "XCStringsToolPlugin",
            capability: .buildTool(),
            dependencies: [
                .target(name: "xcstrings-tool")
            ]
        ),

        .target(
            name: "StringGenerator",
            dependencies: [
                .target(name: "StringExtractor"),
                .target(name: "SwiftIdentifier"),
                .product(name: "SwiftBasicFormat", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
                .target(name: "XCStringsToolConstants")
            ]
        ),

        .target(
            name: "StringResource"
        ),

        .target(
            name: "StringSource",
            dependencies: [
                .target(name: "StringCatalog"),
            ]
        ),

        .target(
            name: "StringCatalog"
        ),

        .target(
            name: "SwiftIdentifier"
        ),

        .target(
            name: "XCStringsToolConstants"
        ),

        .target(
            name: "StringExtractor",
            dependencies: [
                .target(name: "StringCatalog"),
                .target(name: "StringResource"),
                .target(name: "StringSource"),
                .target(name: "SwiftIdentifier")
            ]
        ),

        .target(
            name: "StringValidator",
            dependencies: [
                .target(name: "StringResource")
            ]
        ),

        .testTarget(
            name: "XCStringsToolTests",
            dependencies: [
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
                .target(name: "xcstrings-tool"),
            ],
            exclude: [
                "__Snapshots__"
            ],
            resources: [
                .copy("__Fixtures__")
            ]
        ),

        .testTarget(
            name: "PluginTests",
            dependencies: [
                .target(name: "XCStringsToolPlugin")
            ],
            resources: [
                .process("Resources")
            ],
            swiftSettings: [
                .define("XCSTRINGS_TOOL_ACCESS_LEVEL_PUBLIC")
            ]
        ),

        .testTarget(
            name: "StringCatalogTests",
            dependencies: [
                .target(name: "StringCatalog")
            ],
            resources: [
                .copy("__Fixtures__")
            ]
        )
    ]
)

// https://swiftpackageindex.com/swiftpackageindex/spimanifest/0.19.0/documentation/spimanifest/validation
// On CI, we want to validate the manifest, but nobody else needs that.
if ProcessInfo.processInfo.environment.keys.contains("VALIDATE_SPI_MANIFEST") {
    package.dependencies.append(
       .package(url: "https://github.com/SwiftPackageIndex/SPIManifest.git", from: "0.12.0")
    )
}

// Support for benchmarking locally or on CI
if ProcessInfo.processInfo.environment.keys.contains("BENCHMARK_PACKAGE") {
    package.dependencies.append(
        .package(url: "https://github.com/ordo-one/package-benchmark", from: "1.0.0")
    )
    package.targets.append(
        .executableTarget(
            name: "XCStringsToolBenchmarks",
            dependencies: [
                .product(name: "Benchmark", package: "package-benchmark"),
                .target(name: "StringGenerator"),
                .target(name: "StringResource")
            ],
            path: "Benchmarks/XCStringsToolBenchmarks",
            plugins: [
                .plugin(name: "BenchmarkPlugin", package: "package-benchmark")
            ]
        )
    )
}

// Support testing different versions of Swift Syntax
if let revision = ProcessInfo.processInfo.environment["SWIFT_SYNTAX_REVISION"] {
    // TODO: The `kind` symbol isn't available in Xcode 15.2? Check newer versions.
    package.dependencies.removeAll(where: { $0.url == "https://github.com/apple/swift-syntax.git" })
    package.dependencies.append(
        .package(url: "https://github.com/apple/swift-syntax.git", revision: revision)
    )
}
