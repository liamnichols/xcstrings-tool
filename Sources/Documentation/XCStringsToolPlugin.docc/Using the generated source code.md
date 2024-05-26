# Using the generated source code

How to use the generated source code effectively in your project.

## Overview

For each Strings Catalog in your target, XCStrings Tool will produce a self-contained source file named after the Strings Catalog. Within the source file contains a struct with a static method or property for each localization and a series of extensions that allow you to create instances of `String`, `LocalizedStringResource`, `LocalizedStringKey` or `Text`.

### Resolving a String

If you have a Strings Catalog called **Localizable.xcstrings** with a key named `HeadingTitle`, you can resolve a localized string using the following generated code:

```swift
let localizedValue = String(localizable: .headingTitle)
```

From the above example, the contents of `localizedValue` will be the localized string that is defined in your Strings Catalog in the language that your application is currently set to.

Lets break down the generated code that makes this example possible:

1. `String.Localizable` - A struct that describes each localized phrase in the **Localizable.xcstrings** Strings Catalog. This is done using the `key`, `arguments`, `bundle` and `table` properties.
2. `String.Localizable.headingTitle` - A static variable that describes the `HeadingTitle` key from the strings catalog. 
3. `String.init(localizable:locale:)` - An initializer that can be used to resolve the localized value of the phrase.

The source code used in this example is compatible across all OS versions as it uses [`Bundle.localizedString(forKey:value:table:)`](https://developer.apple.com/documentation/foundation/bundle/1417694-localizedstring) internally.

### Converting to LocalizedStringResource

Stating in iOS 16/macOS 13/watchOS 9/tvOS 16, a new `LocalizedStringResource` type was introduced to help defer the resolution of localized text in order to support features such as App Intents and the SwiftUI environment. 

For example, if the SwiftUI environment overrides the `locale`, it is expected that `Text` and other localized resources are resolved using that `locale` rather than the app or device language.

You can create a `LocalizedStringResource` like so:

```swift
var resource = LocalizedStringResource(localizable: .headingTitle)
resource.locale = Locale(identifier: "fr")
let frenchValue = String(localized: resource)
```

### Working with SwiftUI

While `LocalizedStringResource` is supported on some SwiftUI types, it is not available everywhere and it cannot work on older operating system versions. As a result, your generated code will contain additionl methods to improve usage.

This consists of `Text.init(localizable:)`, `LocalizedStringKey.init(localizable:)` as well as the `LocalizedStringKey.localizable(_:)` and `LocalizedStringResource.localizable(_:)` convenience methods.

```swift
var body: some View {
    List {
        Text(localizable: .listContent)
    }
    .navigationTitle(.localizable(.headingTitle))
    .environment(\.locale, Locale(identifier: "fr"))
}
```
