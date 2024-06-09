import Foundation

extension String {
    /// A type that represents localized strings from the ‘Legacy‘
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
    /// with the `String`.``Swift/String/init(legacy:locale:)``
    /// intializer:
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(legacy: .key1)
    /// value // "This is a simple string"
    /// ```
    ///
    /// Starting in iOS 16/macOS 13/tvOS 16/watchOS 9, `LocalizedStringResource` can also
    /// be used:
    ///
    /// ```swift
    /// var resource = LocalizedStringResource(legacy: .key1)
    /// resource.locale = Locale(identifier: "fr") // customise language
    /// let value = String(localized: resource)    // defer lookup
    /// ```
    ///
    /// ### SwiftUI
    ///
    /// In SwiftUI, it is recommended to use `Text`.``SwiftUI/Text/init(legacy:)``
    /// or `LocalizedStringKey`.``SwiftUI/LocalizedStringKey/legacy(_:)``
    /// in order for localized values to be resolved within the SwiftUI environment:
    ///
    /// ```swift
    /// var body: some View {
    ///     List {
    ///         Text(legacy: .listContent)
    ///     }
    ///     .navigationTitle(.legacy(.navigationTitle))
    ///     .environment(\.locale, Locale(identifier: "fr"))
    /// }
    /// ```
    ///
    /// - SeeAlso: [XCStrings Tool Documentation - Using the generated source code](https://swiftpackageindex.com/liamnichols/xcstrings-tool/0.5.0/documentation/documentation/using-the-generated-source-code)
    internal struct Legacy: Sendable {
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

        /// ### Source Localization
        ///
        /// ```
        /// This is a simple string
        /// ```
        internal static var key1: Legacy {
            Legacy(
                key: "Key1",
                arguments: [],
                table: "Legacy",
                bundle: .current
            )
        }

        /// ### Source Localization
        ///
        /// ```
        /// This string contains %lld integer
        /// ```
        internal static func key2(_ arg1: Int) -> Legacy {
            Legacy(
                key: "Key2",
                arguments: [
                    .int(arg1)
                ],
                table: "Legacy",
                bundle: .current
            )
        }

        /// ### Source Localization
        ///
        /// ```
        /// Hello %@! This string %lld arguments
        /// ```
        internal static func key3(_ arg1: String, _ arg2: Int) -> Legacy {
            Legacy(
                key: "Key3",
                arguments: [
                    .object(arg1),
                    .int(arg2)
                ],
                table: "Legacy",
                bundle: .current
            )
        }

        /// ### Source Localization
        ///
        /// ```
        /// Second: %2$@, First: %1$@, First: %@
        /// ```
        internal static func key4(_ arg1: String, _ arg2: String) -> Legacy {
            Legacy(
                key: "Key4",
                arguments: [
                    .object(arg1),
                    .object(arg2)
                ],
                table: "Legacy",
                bundle: .current
            )
        }

        /// ### Source Localization
        ///
        /// ```
        /// First: %@, First: %1$@
        /// ```
        internal static func key5(_ arg1: String) -> Legacy {
            Legacy(
                key: "Key5",
                arguments: [
                    .object(arg1)
                ],
                table: "Legacy",
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

    internal init(legacy: Legacy, locale: Locale? = nil) {
        let bundle: Bundle = .from(description: legacy.bundle) ?? .main
        let key = String(describing: legacy.key)
        self.init(
            format: bundle.localizedString(forKey: key, value: nil, table: legacy.table),
            locale: locale,
            arguments: legacy.arguments.map(\.value)
        )
    }
}

extension Bundle {
    static func from(description: String.Legacy.BundleDescription) -> Bundle? {
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
    static func from(description: String.Legacy.BundleDescription) -> Self {
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
    /// Constant values for the Legacy Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(localized: .legacy.key1)
    /// value // "This is a simple string"
    ///
    /// // Working with SwiftUI
    /// Text(.legacy.key1)
    /// ```
    ///
    /// - Note: Using ``LocalizedStringResource.Legacy`` requires iOS 16/macOS 13 or later. See ``String.Legacy`` for a backwards compatible API.
    internal struct Legacy {
        /// ### Source Localization
        ///
        /// ```
        /// This is a simple string
        /// ```
        @available (*, deprecated, message: "Use `String.Legacy.key1` instead. This property will be removed in the future.")
        internal var key1: LocalizedStringResource {
            LocalizedStringResource(legacy: .key1)
        }

        /// ### Source Localization
        ///
        /// ```
        /// This string contains %lld integer
        /// ```
        @available (*, deprecated, message: "Use `String.Legacy.key2(_:)` instead. This method will be removed in the future.")
        internal func key2(_ arg1: Int) -> LocalizedStringResource {
            LocalizedStringResource(legacy: .key2(arg1))
        }

        /// ### Source Localization
        ///
        /// ```
        /// Hello %@! This string %lld arguments
        /// ```
        @available (*, deprecated, message: "Use `String.Legacy.key3(_:_:)` instead. This method will be removed in the future.")
        internal func key3(_ arg1: String, _ arg2: Int) -> LocalizedStringResource {
            LocalizedStringResource(legacy: .key3(arg1, arg2))
        }

        /// ### Source Localization
        ///
        /// ```
        /// Second: %2$@, First: %1$@, First: %@
        /// ```
        @available (*, deprecated, message: "Use `String.Legacy.key4(_:_:)` instead. This method will be removed in the future.")
        internal func key4(_ arg1: String, _ arg2: String) -> LocalizedStringResource {
            LocalizedStringResource(legacy: .key4(arg1, arg2))
        }

        /// ### Source Localization
        ///
        /// ```
        /// First: %@, First: %1$@
        /// ```
        @available (*, deprecated, message: "Use `String.Legacy.key5(_:)` instead. This method will be removed in the future.")
        internal func key5(_ arg1: String) -> LocalizedStringResource {
            LocalizedStringResource(legacy: .key5(arg1))
        }
    }

    @available (*, deprecated, message: "Use the `legacy(_:)` static method instead. This property will be removed in the future.") internal static let legacy = Legacy()

    internal init(legacy: String.Legacy) {
        self.init(
            legacy.key,
            defaultValue: legacy.defaultValue,
            table: legacy.table,
            bundle: .from(description: legacy.bundle)
        )
    }

    /// Creates a `LocalizedStringResource` that represents a localized value in the ‘Legacy‘ strings table.
    internal static func legacy(_ legacy: String.Legacy) -> LocalizedStringResource {
        LocalizedStringResource(legacy: legacy)
    }
}

#if canImport (SwiftUI)
import SwiftUI

@available(macOS 10.5, iOS 13, tvOS 13, watchOS 6, *)
extension Text {
    /// Creates a text view that displays a localized string defined in the ‘Legacy‘ strings table.
    internal init(legacy: String.Legacy) {
        if #available (macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
            self.init(LocalizedStringResource(legacy: legacy))
            return
        }

        var stringInterpolation = LocalizedStringKey.StringInterpolation(literalCapacity: 0, interpolationCount: legacy.arguments.count)
        for argument in legacy.arguments {
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
        key.overrideKeyForLookup(using: legacy.key)

        self.init(key, tableName: legacy.table, bundle: .from(description: legacy.bundle))
    }
}

@available(macOS 10.5, iOS 13, tvOS 13, watchOS 6, *)
extension LocalizedStringKey {
    /// Creates a localized string key that represents a localized value in the ‘Legacy‘ strings table.
    @available(macOS 11, iOS 14, tvOS 14, watchOS 7, *)
    internal init(legacy: String.Legacy) {
        var stringInterpolation = LocalizedStringKey.StringInterpolation(literalCapacity: 0, interpolationCount: 1)

        if #available (macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
            stringInterpolation.appendInterpolation(LocalizedStringResource(legacy: legacy))
        } else {
            stringInterpolation.appendInterpolation(Text(legacy: legacy))
        }

        let makeKey = LocalizedStringKey.init(stringInterpolation:)
        self = makeKey(stringInterpolation)
    }

    /// Creates a `LocalizedStringKey` that represents a localized value in the ‘Legacy‘ strings table.
    @available(macOS 11, iOS 14, tvOS 14, watchOS 7, *)
    internal static func legacy(_ legacy: String.Legacy) -> LocalizedStringKey {
        LocalizedStringKey(legacy: legacy)
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
