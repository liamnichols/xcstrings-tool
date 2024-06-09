# ``Documentation``

Produce Swift code for your Strings Catalogs and other localized string resources

@Metadata {
    @DisplayName("XCStrings Tool")
}

## Overview

The XCStrings Tool Plugin is designed to support your projects in using Xcode 15's new Strings Catalog format as the ultimate source of truth for your localized strings.

### Before

![A diagram describing .swift files feeding into the .xcstrings file which is then used to produce the legacy .strings and .stringsdict files](Overview-Before)

### After

![An diagram describing the .xcstrings file being used to produce .swift, .strings and .stringsdict files](Overview-After)

Using the XCStrings Tool Plugin for this approach helps you to:

- Keep your views concise and easy to read without localized string definitions
- Avoid having to maintain your own boilerplate constants
- Reuse translator comments for inline code documentation

With a few simple steps, you can turn your strings from this:

```swift
Text(
    "You've seen \(dogs.count) dogs with a combined rating of \(totalRating)/\(dogs.count * 10)",
    bundle: .module,
    comment: "Summary of sightings shown at the bottom of the list"
)
```

To this:

```swift
Text(.localizable.contentSummary(dogs.count, totalRating, dogs.count * 10))
```

In addition to the new Strings Catalog format, XCStrings Tool will also generate the same Swift source code for projects using the legacy .strings and .stringsdict file formats.

## Topics

### Getting Started

## Tutorials

### Getting Started

- <doc:Integrating-XCStrings-Tool-into-an-Xcode-Project-Target>
- <doc:Integrating-XCStrings-Tool-into-a-Swift-Package-Target>
- <doc:Using-the-generated-source-code>

### Advanced

- <doc:Changing-the-Access-Level>
- <doc:Moving-away-from-XCStrings-Tool>
