import Foundation

extension String {
    /// A type that represents localized strings from the ‘Variations‘
    /// strings table.
    ///
    /// Do not initialize instances of this type yourself, instead use one of the static
    /// methods or properties that have been generated automatically.
    ///
    /// ## Usage
    ///
    /// ### Foundation
    ///
    /// In Foundation, you can resolve the localized string using the system language
    /// with the `String`.``Swift/String/init(variations:locale:)``
    /// intializer:
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(variations: .stringDevice)
    /// value // "Tap to open"
    /// ```
    ///
    /// Starting in iOS 16/macOS 13/tvOS 16/watchOS 9, `LocalizedStringResource` can also
    /// be used:
    ///
    /// ```swift
    /// var resource = LocalizedStringResource(variations: .stringDevice)
    /// resource.locale = Locale(identifier: "fr") // customise language
    /// let value = String(localized: resource)    // defer lookup
    /// ```
    ///
    /// ### SwiftUI
    ///
    /// In SwiftUI, it is recommended to use `Text`.``SwiftUI/Text/init(variations:)``
    /// or `LocalizedStringKey`.``SwiftUI/LocalizedStringKey/variations(_:)``
    /// in order for localized values to be resolved within the SwiftUI environment:
    ///
    /// ```swift
    /// var body: some View {
    ///     List {
    ///         Text(variations: .listContent)
    ///     }
    ///     .navigationTitle(.variations(.navigationTitle))
    ///     .environment(\.locale, Locale(identifier: "fr"))
    /// }
    /// ```
    ///
    /// - SeeAlso: [XCStrings Tool Documentation - Using the generated source code](https://swiftpackageindex.com/liamnichols/xcstrings-tool/0.4.0/documentation/documentation/using-the-generated-source-code)
    internal struct Variations: Sendable {
        enum BundleDescription: Sendable {
            case main
            case atURL(URL)
            case forClass(AnyClass)

            #if !SWIFT_PACKAGE
            private class BundleLocator {
            }
            #endif

            static var current: BundleDescription {
                #if SWIFT_PACKAGE
                .atURL(Bundle.module.bundleURL)
                #else
                .forClass(BundleLocator.self)
                #endif
            }
        }

        enum Argument: Sendable {
            case int(Int)
            case uint(UInt)
            case float(Float)
            case double(Double)
            case object(String)

            var value: any CVarArg {
                switch self {
                case .int(let value):
                    value
                case .uint(let value):
                    value
                case .float(let value):
                    value
                case .double(let value):
                    value
                case .object(let value):
                    value
                }
            }
        }

        let key: StaticString
        let arguments: [Argument]
        let table: String?
        let bundle: BundleDescription

        fileprivate init(
            key: StaticString,
            arguments: [Argument],
            table: String?,
            bundle: BundleDescription
        ) {
            self.key = key
            self.arguments = arguments
            self.table = table
            self.bundle = bundle
        }

        /// A string that should have a macOS variation to replace 'Tap' with 'Click'
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Tap to open
        /// ```
        internal static var stringDevice: Variations {
            Variations(
                key: "String.Device",
                arguments: [],
                table: "Variations",
                bundle: .current
            )
        }

        /// ### Source Localization
        ///
        /// ```
        /// I have %lld strings
        /// ```
        internal static func stringPlural(_ arg1: Int) -> Variations {
            Variations(
                key: "String.Plural",
                arguments: [
                    .int(arg1)
                ],
                table: "Variations",
                bundle: .current
            )
        }

        @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
        fileprivate var defaultValue: String.LocalizationValue {
            var stringInterpolation = String.LocalizationValue.StringInterpolation(literalCapacity: 0, interpolationCount: arguments.count)
            for argument in arguments {
                switch argument {
                case .int(let value):
                    stringInterpolation.appendInterpolation(value)
                case .uint(let value):
                    stringInterpolation.appendInterpolation(value)
                case .float(let value):
                    stringInterpolation.appendInterpolation(value)
                case .double(let value):
                    stringInterpolation.appendInterpolation(value)
                case .object(let value):
                    stringInterpolation.appendInterpolation(value)
                }
            }
            let makeDefaultValue = String.LocalizationValue.init(stringInterpolation:)
            return makeDefaultValue(stringInterpolation)
        }
    }

    internal init(variations: Variations, locale: Locale? = nil) {
        let bundle: Bundle = .from(description: variations.bundle) ?? .main
        let key = String(describing: variations.key)
        self.init(
            format: bundle.localizedString(forKey: key, value: nil, table: variations.table),
            locale: locale,
            arguments: variations.arguments.map(\.value)
        )
    }
}

extension Bundle {
    static func from(description: String.Variations.BundleDescription) -> Bundle? {
        switch description {
        case .main:
            Bundle.main
        case .atURL(let url):
            Bundle(url: url)
        case .forClass(let anyClass):
            Bundle(for: anyClass)
        }
    }
}

@available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
private extension LocalizedStringResource.BundleDescription {
    static func from(description: String.Variations.BundleDescription) -> Self {
        switch description {
        case .main:
            .main
        case .atURL(let url):
            .atURL(url)
        case .forClass(let anyClass):
            .forClass(anyClass)
        }
    }
}

@available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
extension LocalizedStringResource {
    /// Constant values for the Variations Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(localized: .variations.stringDevice)
    /// value // "Tap to open"
    ///
    /// // Working with SwiftUI
    /// Text(.variations.stringDevice)
    /// ```
    ///
    /// - Note: Using ``LocalizedStringResource.Variations`` requires iOS 16/macOS 13 or later. See ``String.Variations`` for a backwards compatible API.
    internal struct Variations {
        /// A string that should have a macOS variation to replace 'Tap' with 'Click'
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Tap to open
        /// ```
        @available (iOS, deprecated: 100000, message: "Use `String.Variations.stringDevice` instead. This property will be removed in the future.")
        @available (macOS, deprecated: 100000, message: "Use `String.Variations.stringDevice` instead. This property will be removed in the future.")
        @available (tvOS, deprecated: 100000, message: "Use `String.Variations.stringDevice` instead. This property will be removed in the future.")
        @available (watchOS, deprecated: 100000, message: "Use `String.Variations.stringDevice` instead. This property will be removed in the future.")
        @available (visionOS, deprecated: 100000, message: "Use `String.Variations.stringDevice` instead. This property will be removed in the future.")
        internal var stringDevice: LocalizedStringResource {
            LocalizedStringResource(variations: .stringDevice)
        }

        /// ### Source Localization
        ///
        /// ```
        /// I have %lld strings
        /// ```
        @available (iOS, deprecated: 100000, message: "Use `String.Variations.stringPlural(_:)` instead. This method will be removed in the future.")
        @available (macOS, deprecated: 100000, message: "Use `String.Variations.stringPlural(_:)` instead. This method will be removed in the future.")
        @available (tvOS, deprecated: 100000, message: "Use `String.Variations.stringPlural(_:)` instead. This method will be removed in the future.")
        @available (watchOS, deprecated: 100000, message: "Use `String.Variations.stringPlural(_:)` instead. This method will be removed in the future.")
        @available (visionOS, deprecated: 100000, message: "Use `String.Variations.stringPlural(_:)` instead. This method will be removed in the future.")
        internal func stringPlural(_ arg1: Int) -> LocalizedStringResource {
            LocalizedStringResource(variations: .stringPlural(arg1))
        }
    }

    @available (iOS, deprecated: 100000, message: "Use the `variations(_:)` static method instead. This property will be removed in the future.")
    @available (macOS, deprecated: 100000, message: "Use the `variations(_:)` static method instead. This property will be removed in the future.")
    @available (tvOS, deprecated: 100000, message: "Use the `variations(_:)` static method instead. This property will be removed in the future.")
    @available (watchOS, deprecated: 100000, message: "Use the `variations(_:)` static method instead. This property will be removed in the future.")
    @available (visionOS, deprecated: 100000, message: "Use the `variations(_:)` static method instead. This property will be removed in the future.") internal static let variations = Variations()

    internal init(variations: String.Variations) {
        self.init(
            variations.key,
            defaultValue: variations.defaultValue,
            table: variations.table,
            bundle: .from(description: variations.bundle)
        )
    }

    /// Creates a `LocalizedStringResource` that represents a localized value in the ‘Variations‘ strings table.
    internal static func variations(_ variations: String.Variations) -> LocalizedStringResource {
        LocalizedStringResource(variations: variations)
    }
}

#if canImport (SwiftUI)
import SwiftUI

@available(macOS 10.5, iOS 13, tvOS 13, watchOS 6, *)
extension Text {
    /// Creates a text view that displays a localized string defined in the ‘Variations‘ strings table.
    internal init(variations: String.Variations) {
        if #available (macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
            self.init(LocalizedStringResource(variations: variations))
            return
        }

        var stringInterpolation = LocalizedStringKey.StringInterpolation(literalCapacity: 0, interpolationCount: variations.arguments.count)
        for argument in variations.arguments {
            switch argument {
            case .int(let value):
                stringInterpolation.appendInterpolation(value)
            case .uint(let value):
                stringInterpolation.appendInterpolation(value)
            case .float(let value):
                stringInterpolation.appendInterpolation(value)
            case .double(let value):
                stringInterpolation.appendInterpolation(value)
            case .object(let value):
                stringInterpolation.appendInterpolation(value)
            }
        }
        let makeKey = LocalizedStringKey.init(stringInterpolation:)

        var key = makeKey(stringInterpolation)
        key.overrideKeyForLookup(using: variations.key)

        self.init(key, tableName: variations.table, bundle: .from(description: variations.bundle))
    }
}

@available(macOS 10.5, iOS 13, tvOS 13, watchOS 6, *)
extension LocalizedStringKey {
    /// Creates a localized string key that represents a localized value in the ‘Variations‘ strings table.
    @available(macOS 11, iOS 14, tvOS 14, watchOS 7, *)
    internal init(variations: String.Variations) {
        var stringInterpolation = LocalizedStringKey.StringInterpolation(literalCapacity: 0, interpolationCount: 1)

        if #available (macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
            stringInterpolation.appendInterpolation(LocalizedStringResource(variations: variations))
        } else {
            stringInterpolation.appendInterpolation(Text(variations: variations))
        }

        let makeKey = LocalizedStringKey.init(stringInterpolation:)
        self = makeKey(stringInterpolation)
    }

    /// Creates a `LocalizedStringKey` that represents a localized value in the ‘Variations‘ strings table.
    @available(macOS 11, iOS 14, tvOS 14, watchOS 7, *)
    internal static func variations(_ variations: String.Variations) -> LocalizedStringKey {
        LocalizedStringKey(variations: variations)
    }

    /// Updates the underlying `key` used when performing localization lookups.
    ///
    /// By default, an instance of `LocalizedStringKey` can only be created
    /// using string interpolation, so if arguments are included, the format
    /// specifiers make up part of the key.
    ///
    /// This method allows you to change the key after initialization in order
    /// to match the value that might be defined in the strings table.
    fileprivate mutating func overrideKeyForLookup(using key: StaticString) {
        withUnsafeMutablePointer(to: &self) { pointer in
            let raw = UnsafeMutableRawPointer(pointer)
            let bound = raw.assumingMemoryBound(to: String.self)
            bound.pointee = String(describing: key)
        }
    }
}
#endif
