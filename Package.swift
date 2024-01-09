// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

let package = Package(
    name: "XCStringsTool",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .macCatalyst(.v16),
        .visionOS(.v1)
    ],
    products: [
        .executable(name: "xcstrings-tool", targets: ["xcstrings-tool"]),
        .plugin(name: "XCStringsToolPlugin", targets: ["XCStringsToolPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.3"),
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
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
                .target(name: "StringValidator")
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
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax")
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
            swiftSettings: [
                .define("XCSTRINGS_TOOL_ACCESS_LEVEL_PUBLIC")
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
