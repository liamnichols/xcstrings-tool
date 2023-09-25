# XCStrings Tool

[![Test Status](https://github.com/liamnichols/xcstrings-tool/workflows/Tests/badge.svg)](https://github.com/liamnichols/xcstrings-tool/actions/workflows/tests.yml)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fliamnichols%2Fxcstrings-tool%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/liamnichols/xcstrings-tool)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fliamnichols%2Fxcstrings-tool%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/liamnichols/xcstrings-tool)

A plugin to generate Swift constants for your String Catalogs.

## Motivation

Hardcoding localized strings in your code and then having the compiler automatically extract them into the Strings Catalog (or legacy .strings files) works great on smaller projects, but over time you will often find that this approach doesn't scale well.

You usually find yourself compromising on either code quality, translator comments or boilerplate code from having to define your own constants, but it doesn't have to be this way!  

```swift
struct ContentView: View {
    @Query var items: [Item]
    
    var body: some View {
        List {
            Section {
                ForEach(items) { item in
                    ItemView(item) 
                }
            } footer: {
                Text(.localizable.footerText(items.count))
            }
        }
        .navigationTitle(Text(.localizable.contentViewTitle))
    }
}
```

XCStrings Tool aims to extend your localization experience so that you don't have to compromise anything. It does this by using your Strings Catalog as a source for generating elegant Swift code that you can reference directly within the rest of your project.

## Getting Started

XCStrings Tool is a Swift Package Plugin that can integrate directly into Xcode and Swift Package targets that contain Strings Catalog (.xcstrings) files.

- [**Integrating XCStrings Tool into an Xcode Project Target**](https://swiftpackageindex.com/liamnichols/xcstrings-tool/documentation/documentation/integrating-xcstrings-tool-into-an-xcode-project-target)
- [**Integrating XCStrings Tool into a Swift Package Target**](https://swiftpackageindex.com/liamnichols/xcstrings-tool/documentation/documentation/integrating-xcstrings-tool-into-a-swift-package-target)

For more information about the Strings Catalog format, check out the [Discover Strings Catalogs](https://developer.apple.com/videos/play/wwdc2023/10155/) video from WWDC 2023.

## Demo

To see XCStrings Tool in action, check out the [Dog Tracker demo project](https://github.com/liamnichols/xcstrings-tool-demo) for yourself.

## Documentation

[**View the documentation on the Swift Package Index**](https://swiftpackageindex.com/liamnichols/xcstrings-tool/documentation/documentation)

If you have an improvement for the documentation, you can [modify it here](./Sources/Documentation/XCStringsToolPlugin.docc)

## Contributing

Contributions to XCStrings Tool are welcome!

- For ideas and questions: [Visit the Discussions](https://github.com/liamnichols/xcstrings-tool/discussions)
- For bugs: [Open an Issue](https://github.com/liamnichols/xcstrings-tool/issues/choose)
- For contributions: [Open a Pull Request](https://github.com/liamnichols/xcstrings-tool/compare) 

## Advanced

### Changing the Access Level

If you want the generated source code to have a `public` access level, you must set the `XCSTRINGS_ACCESS_LEVEL_PUBLIC` build setting or Swift active compilation condition.

In a Swift Package, this can be achieved like so:

```swift
// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    // ...
    targets: [
        // ...
        .target(
            name: "AppResources",
            dependencies: [
                .target(name: "XCStringsToolPlugin")
            ],
            swiftSettings: [
                .define("XCSTRINGS_ACCESS_LEVEL_PUBLIC")
            ]
        )
    ]
)
```

In an Xcode project, head to the **Build Settings** section for your target, click the **+** and then **Add User-Defined Setting**. Add a new setting with the name `XCSTRINGS_ACCESS_LEVEL_PUBLIC` and value `YES`.

Build your target again and the source code should update to reflect the change.
