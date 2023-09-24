# XCStrings Tool

[![Test Status](https://github.com/liamnichols/xcstrings-tool/workflows/Tests/badge.svg)](https://github.com/liamnichols/xcstrings-tool/actions/workflows/tests.yml)

A plugin to generate Swift constants for your String Catalogs.

## Motivation

Extracting your Localized Strings directly from your source code works great on smaller projects, but as you scale, we often find ourselves struggling to tidy code

```swift
struct ContentView: View {
    var body: some View {
        Text(
            LocalizedStringResource(
                "ContentViewTitle",
                defaultValue: "Loading Content...",
                table: "AppCore",
                bundle: .forURL(Bundle.module.bundleURL)
            )
        )
    }
}
```

If you modularize your project and need to start referencing a different strings table or bundle, you soon find that your View code becomes verbose and hard to follow and if you try to create your own extensions or helpers, you find that the Swift Compiler might no longer be able to reliably extract your strings keys.

This is where using the Strings Catalog (.xcstrings file) as a source of truth starts to become an appealing option however by doing so, you'll soon find that you have to define any constants in your code yourself. XCStrings Tool is a tool designed to fill this gap in your localization workflows.

```swift
struct ContentView: View {
    var body: some View {
        Text(.appCore.contentViewTitle)
    }
}
```

## Getting Started

It's easy to get started, in the following 5 steps:

1. [🆕 Add a String Catalog to your project](#-add-a-string-catalog-to-your-project)
2. [📝 Populate your String Catalog with localizations](#-populate-your-string-catalog-with-localizations)
3. [🧑‍💻 Integrate the XCStringsToolPlugin](#-integrate-the-xcstringstoolplugin)
4. [⚙️ Build your project](#%EF%B8%8F-build-your-project)
5. [✅ Reference the generated constants](#-reference-the-generated-constants)

### 🆕 Add a String Catalog to your project

A String Catalog can be added to any Xcode or Swift Package Manager targets. In Xcode 15 or later, locate your Target in the Xcode Project Navigator then right click on it's folder and select **New File...**

In the template window, scroll down to the **Resources** section, and select **String Catalog**.

### 📝 Populate your String Catalog with localizations

By default, your String Catalog will likely be empty. In the bottom-left of the window, you can click the **+** button to add your source language. After doing so, you can then click another **+** at the top of the window to start adding strings.

Unlike other documentation might suggest, you manually create your string definitions in the Catalog via the **+** button rather than relying on the compiler to discover them in your app. When you add a new string, be sure to define the key using a format such as `lowerCamelCase` so that it feels natural when you reference it in Swift code.

If you want to namespace your localized strings, consider making multiple String Catalogs.

For more information about working with String Catalogs, check out [**Discover String Catalogs**](https://developer.apple.com/videos/play/wwdc2023/10155/) from WWDC 2023.

### 🧑‍💻 Integrate the XCStringsToolPlugin

Depending on if your target is defined in a Swift Package or your Xcode project, there are different steps involved:

#### Swift Packages

In your **Package.swift** file, define a dependency on this repository and on the definition of the target that contains your String Catalog, add the `plugin` definition. See below for an example adding the plugin to the ProfileFeature target below:

```swift
// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Packages",
    platforms: [.iOS(.v16)],
    products: [
        // ...
    ],
    dependencies: [
        .package(url: "https://github.com/liamnichols/xcstrings-tool.git", from: "0.1.0"),
        // ...
    ],
    targets: [
        .target(
            name: "ProfileFeature",
            dependencies: [
                .product(name: "XCStringsToolPlugin", package: "xcstrings-tool")
            ]
        ),
        // ...
    ]
)
```

#### Xcode projects

In your Xcode project, navigate to the Project Settings and add the remote dependency. Be sure that you choose to add the dependency to your project, and when prompted, also to your target(s) of choice.

After adding the dependency, go to your target settings and click on **Build Phases**. Under the **Run Build Tool Plug-ins** section, click the **+** to add the **XCStringsToolPlugin** if it wasn't already added.


### ⚙️ Build your project

After adding the plugin to your target, build your target like normal! The generated source code will not be visible in your project folder, but you can see what has happened by looking at the build log for your target.

In the log, you should see a message similar to **XCStringsTool: Generate Swift code for ‘Localizable.xcstrings‘**. If you expand the message, you will where the tool has written the source code.

### ✅ Reference the generated constants

XCStrings Tool will generate a single struct for each String Catalog that contains a computed property or function for every manually defined key in your source language. Each of these members will return an instance of [`LocalizedStringResource`](https://developer.apple.com/documentation/foundation/localizedstringresource).

The `LocalizedStringResource` was introduced in iOS 16 and is deeply integrated in Foundation and SwiftUI and to make it really easy to use these new constants, a static property on `LocalizedStringResource` allows you to access your keys.

For example, after integrating the plugin for **Localizable.xcstrings**, you can access your strings using the following syntax:

```swift
let string = String(localized: .localizable.myKey)
```

and in SwiftUI:

```swift
Text(.localizable.myKey)
```

By default, the generated code has the `internal` access level. If you wish to generate `public` constants instead, please refer to [**Changing the Access Level**](#changing-the-access-level)

> [!NOTE]
> While `LocalizedStringResource` is widely supported in SwiftUI, there are still some methods that don't accept it. In those instances, you should use the `LocalizedStringKey` overload of the method by using string interpolation like so:
>
> ```swift
> Button("\(.localizable.myKey)", action: { print("button tapped") })
> ```

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
