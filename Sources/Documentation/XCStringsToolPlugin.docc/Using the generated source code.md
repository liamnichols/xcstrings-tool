# Using the generated source code

How to use the generated source code effectively in your project.

## Overview

For each Strings Catalog in your target, XCStrings Tool will produce a self-contained source file that consists primarily of a struct that is named after the Strings Catalog. The generated code extends two main Foundation APIs

- [Resolving a String](#Resolving-a-String)
- [Using LocalizedStringResource](#Using-LocalizedStringResource)

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

The source code used in this example is compatible across all OS versions as it uses `Bundle.localizedString(forKey:value:table:)` internally.

### Using LocalizedStringResource

Stating in iOS 16/macOS 13/watchOS 9/tvOS 16, a new `LocalizedStringResource` type was introduced to help defer the resolution of localized text in order to support features such as App Intents and the SwiftUI environment. 

For example, if the SwiftUI environment overrides the `locale`, it is expected that Text and other localized resources are resolved using that `locale` rather than the app or device language.

XCStrings Tool will also generate the following:

```swift
let resource = LocalizedStringResource.localizable.headingTitle
```

If your project needs to override the language, you can leverage the `LocalizedStringResource` like in the following examples:

#### SwiftUI

```swift
Text(.localizable.headingTitle)
    .environment(\.locale, Locale(identifier: "fr"))
```

> Not all SwiftUI types have been updated to accept `LocalizedStringResource`. 
>
> In some instances, you might need to wrap the `LocalizedStringResource` in `Text` or `LocalizedStringKey` as per the following examples
>
> ```swift
> // Text
> Button(action: { rows.append("New Row") }, label: {
>     Text(.localizable.addRow)
> })
>
> // LocalizedStringKey
> Button("\(.localizable.addRow)") { rows.append("New Row") }
> ```

#### Foundation

```swift
var resource = LocalizedStringResource.localizable.headingTitle
resource.locale = Locale(identifier: "fr")
let frenchValue = String(localized: resource)
```


