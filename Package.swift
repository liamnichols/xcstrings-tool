// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "xcstrings-tool",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .macCatalyst(.v16),
        .visionOS(.v1)
    ],
    products: [
        .plugin(name: "XCStringsToolPlugin", targets: ["XCStringsToolPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.3"),
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-custom-dump.git", from: "1.1.0")
    ],
    targets: [
        .executableTarget(
            name: "XCStringsTool",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .target(name: "StringCatalog"),
                .target(name: "StringExtractor"),
                .target(name: "StringGenerator"),
                .target(name: "StringResource")
            ]
        ),

        .plugin(
            name: "XCStringsToolPlugin",
            capability: .buildTool(),
            dependencies: [
                .target(name: "XCStringsTool")
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
                .target(name: "SwiftIdentifier")
            ]
        ),
        
        .testTarget(
            name: "LocalizationTests",
            dependencies: [
                .target(name: "StringCatalog"),
                .target(name: "StringExtractor"),
                .target(name: "StringGenerator"),
                .product(name: "CustomDump", package: "swift-custom-dump")
            ],
            resources: [
                .copy("Fixtures")
            ]
        ),

        .testTarget(
            name: "PluginTests",
            dependencies: [
                .target(name: "XCStringsToolPlugin")
            ],
            swiftSettings: [
                .define("XCSTRINGS_ACCESS_LEVEL_PUBLIC")
            ]
        )
    ]
)
