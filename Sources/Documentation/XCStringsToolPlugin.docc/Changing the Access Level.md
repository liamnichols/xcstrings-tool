# Changing the Access Level

Manage the visibility of generated code.

## Overview

By default, XCStrings Tool will generate all source code with the `internal` access level. The result is that your constants are available to source code within your target, but not to other targets.  

If your target exposes localized strings as part of its module interface, you might want to alter this behaviour so that the constants are generated with the `public` access level instead.

### Changing the Access Level for code in a Swift Package target

For Swift Package targets, XCStrings Tool parses flags defined as Swift Active Compilation Conditions. You can define these in your **Package.swift** file using the `swiftSettings` argument on a target definition:

```swift
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
                .define("XCSTRINGS_TOOL_ACCESS_LEVEL_PUBLIC")
            ]
        )
    ]
)
```

> Note: XCStrings Tool does not actually leverage these compile conditions in generated code, instead it uses their presence when running the build tool to alter the behaviour of the generated output.
>
> This is in order to work the current limitations of Swift Package Plugins

You can also change the Access Level to `package` by instead defining the `XCSTRINGS_TOOL_ACCESS_LEVEL_PACKAGE` condition. 

### Changing the Access Level for code in an Xcode Project target 

Unlike Swift Package targets, in an Xcode Project you are able to specify User-Defined Build Settings to customise the behaviour of XCStrings Tool.

Open the **Build Settings** screen for your target, click the **+** and then **Add User-Defined Setting**. Define a setting called `XCSTRINGS_TOOL_ACCESS_LEVEL` and set its value to either `INTERNAL`, `PUBLIC` or `PACKAGE`.

![A screenshot of the XCSTRINGS_TOOL_ACCESS_LEVEL build setting defined in Xcode](Xcode-BuildSetting)
