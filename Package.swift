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
        .plugin(name: "XCStringsToolPlugin", targets: ["XCStringsToolPlugin"]),
        .library(name: "StringCatalog", targets: ["StringCatalog"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.3"),
        .package(url: "https://github.com/apple/swift-syntax.git", "509.0.0" ..< "511.0.0"),
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
                .process("FeatureOne.xcstrings"),
                .process("Localizable.xcstrings")
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

// Use https://www.swift.org/swift-evolution/ to see details of the upcoming/experimental features
let upcomingFeatureSwiftSettings: [SwiftSetting] = [
    "ConciseMagicFile", // SE-0274
    "ForwardTrailingClosures", // SE-0286
    "ExistentialAny", // SE-0335
    "BareSlashRegexLiterals", // SE-0354
    "ImportObjcForwardDeclarations", // SE-0384
    "DeprecateApplicationMain", // SE-0383
    "DisableOutwardActorInference", // SE-0401
    "IsolatedDefaultValues", // SE-0411
    "GlobalConcurrency" // SE-0412
].map {
    .enableUpcomingFeature($0)
}

let experimentalFeatureSwiftSettings: [SwiftSetting] = [
    "AccessLevelOnImport",  // SE-0409
    "StrictConcurrency" // SE-0412
].map {
    .enableExperimentalFeature($0)
}

package.targets.forEach { target in
    guard target.name != "XCStringsToolPlugin" else {
        return /// Plugins don't support setting `swiftSettings`
    }

    let swiftSettings = target.swiftSettings ?? []
    target.swiftSettings = swiftSettings + upcomingFeatureSwiftSettings + experimentalFeatureSwiftSettings
}

// https://swiftpackageindex.com/swiftpackageindex/spimanifest/0.19.0/documentation/spimanifest/validation
// On CI, we want to validate the manifest, but nobody else needs that.
if ProcessInfo.processInfo.environment.keys.contains("VALIDATE_SPI_MANIFEST") {
    package.dependencies.append(
       .package(url: "https://github.com/SwiftPackageIndex/SPIManifest.git", from: "0.12.0")
    )
}
