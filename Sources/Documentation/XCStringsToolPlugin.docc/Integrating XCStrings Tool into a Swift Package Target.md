# Integrating XCStrings Tool into a Swift Package Target

Integrate generated Swift constants for your localized strings in a Swift Package Target.

## Overview

The XCStrings Tool plugin integrates directly into Swift Package Manager providing a seamless integration into any of your Swift Package targets that contain Strings Catalog files.

> Note: Strings Catalogs are only supported on Apple Platforms.

If you haven't already, open up a Swift Package which contains the Strings Catalog files that you wish generate source code constants for.

### Updating Package.swift

To integrate the XCStrings Tool plugin, you need to make two modifications to your **Package.swift** file:

1. Add the xcstrings-tool Package dependency
2. Add the XCStringsToolPlugin product as a dependency on your target

```swift
// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DogKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "DogKit",
            targets: ["DogKit"]
        )
    ],
    dependencies: [
        // 1. Add the xcstrings-tool Package dependency
        .package(url: "https://github.com/liamnichols/xcstrings-tool-plugin.git", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "DogKit",
            dependencies: [
                // 2. Add the XCStringsToolPlugin product as a dependency on your target
                .product(name: "XCStringsToolPlugin", package: "xcstrings-tool")
            ],
            path: "Sources"
        )
    ]
)
```

### Review your Strings Catalog

Before building the product, let's just review our Strings Catalog quickly:

![A screenshot of the Strings Catalog specifically highlighting that the phrases are set to manual](SPM-StringsCatalog)

When working with XCStrings Tool, it's recommended that each string has it's **Key** set to a lowerCamelCase identifier so that it matches the generated Swift code.

Additionally, you need to make sure that your strings have their **Managed** setting set to **Manually**. This will be the case already if you added the string with the **+** button, but if the compiler pre-populated the contents of the catalog, you might need to change this value.

### Build your Project

The first time that you build your project, you'll be presented with the following alert:

![A screenshot of the alert shown that asks you to trust the plugin before using it](Xcode-TrustPlugin)

Review the plugin and once you are ready, press **Trust & Enable All**. Your project should now build.

After building, in the left sidebar, open **Report navigator**, select the last build and review the build log for your target. You should spot a message similar to **Run custom shell script 'XCStringsTool: Generate Swift code for ‘Localizable.xcstrings‘'**:

![A screenshot of the build tool plugin output in the Xcode report navigator](Xcode-BuildLog)

If you wish, you can open the file printed in the log output to review the generated code:

![A screenshot of the generated Localizable.swift file](SPM-Generated)

This code is compiled as part of your target, so is accessible just like code you would write yourself:

![A screenshot of the new constants being used in some Foundation-baed model code](SPM-Usage)

## See Also

- <doc:Changing-the-Access-Level>
