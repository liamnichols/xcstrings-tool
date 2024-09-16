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
    /// - SeeAlso: [XCStrings Tool Documentation - Using the generated source code](https://swiftpackageindex.com/liamnichols/xcstrings-tool/1.0.0/documentation/documentation/using-the-generated-source-code)
    internal struct Legacy: Hashable, Sendable {
        #if !SWIFT_PACKAGE
        private class BundleLocator {
        }
        #endif

        enum Argument: Hashable, Sendable {
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

        fileprivate init(
            key: StaticString,
            arguments: [Argument],
            table: String?
        ) {
            self.key = key
            self.arguments = arguments
            self.table = table
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
                table: "Legacy"
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
                table: "Legacy"
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
                table: "Legacy"
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
                table: "Legacy"
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
                table: "Legacy"
            )
        }

        var bundle: Bundle {
            #if SWIFT_PACKAGE
            .module
            #else
            Bundle(for: BundleLocator.self)
            #endif
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

        fileprivate var _key: String {
            String(describing: key)
        }

        internal func hash(into hasher: inout Hasher) {
            hasher.combine(_key)
            hasher.combine(arguments)
            hasher.combine(table)
        }

        internal static func ==(lhs: Legacy, rhs: Legacy) -> Bool {
            lhs._key == rhs._key && lhs.arguments == rhs.arguments && lhs.table == rhs.table
        }
    }

    internal init(legacy: Legacy, locale: Locale? = nil) {
        let key = String(describing: legacy.key)
        self.init(
            format: legacy.bundle.localizedString(forKey: key, value: nil, table: legacy.table),
            locale: locale,
            arguments: legacy.arguments.map(\.value)
        )
    }

    /// Creates a `String` that represents a localized value in the ‘Legacy‘ strings table.
    internal static func legacy(_ legacy: String.Legacy) -> String {
        String(legacy: legacy)
    }
}

@available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
extension LocalizedStringResource {
    internal init(legacy: String.Legacy) {
        self.init(
            legacy.key,
            defaultValue: legacy.defaultValue,
            table: legacy.table,
            bundle: .atURL(legacy.bundle.bundleURL)
        )
    }

    /// Creates a `LocalizedStringResource` that represents a localized value in the ‘Legacy‘ strings table.
    internal static func legacy(_ legacy: String.Legacy) -> LocalizedStringResource {
        LocalizedStringResource(legacy: legacy)
    }
}

#if canImport(SwiftUI)
import SwiftUI

@available(macOS 10.5, iOS 13, tvOS 13, watchOS 6, *)
extension Text {
    /// Creates a text view that displays a localized string defined in the ‘Legacy‘ strings table.
    internal init(legacy: String.Legacy) {
        if #available(macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
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
        key.overrideKeyForLookup(using: legacy._key)

        self.init(key, tableName: legacy.table, bundle: legacy.bundle)
    }
}

@available(macOS 10.5, iOS 13, tvOS 13, watchOS 6, *)
extension LocalizedStringKey {
    /// Creates a localized string key that represents a localized value in the ‘Legacy‘ strings table.
    @available(macOS 11, iOS 14, tvOS 14, watchOS 7, *)
    internal init(legacy: String.Legacy) {
        var stringInterpolation = LocalizedStringKey.StringInterpolation(literalCapacity: 0, interpolationCount: 1)

        if #available(macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
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
    fileprivate mutating func overrideKeyForLookup(using key: String) {
        withUnsafeMutablePointer(to: &self) { pointer in
            let raw = UnsafeMutableRawPointer(pointer)
            let bound = raw.assumingMemoryBound(to: String.self)
            bound.pointee = key
        }
    }
}
#endif
