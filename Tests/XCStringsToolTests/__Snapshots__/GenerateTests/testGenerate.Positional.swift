import Foundation

extension String {
    /// A type that represents localized strings from the ‘Positional‘
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
    /// with the `String`.``Swift/String/init(positional:locale:)``
    /// initializer:
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(positional: .foo)
    /// value // "bar"
    /// ```
    ///
    /// Starting in iOS 16/macOS 13/tvOS 16/watchOS 9, `LocalizedStringResource` can also
    /// be used:
    ///
    /// ```swift
    /// var resource = LocalizedStringResource(positional: .foo)
    /// resource.locale = Locale(identifier: "fr") // customise language
    /// let value = String(localized: resource)    // defer lookup
    /// ```
    ///
    /// ### SwiftUI
    ///
    /// In SwiftUI, it is recommended to use `Text`.``SwiftUI/Text/init(positional:)``
    /// or `LocalizedStringKey`.``SwiftUI/LocalizedStringKey/positional(_:)``
    /// in order for localized values to be resolved within the SwiftUI environment:
    ///
    /// ```swift
    /// var body: some View {
    ///     List {
    ///         Text(positional: .listContent)
    ///     }
    ///     .navigationTitle(.positional(.navigationTitle))
    ///     .environment(\.locale, Locale(identifier: "fr"))
    /// }
    /// ```
    ///
    /// - SeeAlso: [XCStrings Tool Documentation - Using the generated source code](https://swiftpackageindex.com/liamnichols/xcstrings-tool/1.2.0/documentation/documentation/using-the-generated-source-code)
    internal struct Positional: Hashable, Sendable {
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

        /// A string where the second argument is at the front of the string and the first argument is at the end
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Second: %2$@ - First: %1$lld
        /// ```
        internal static func reorder(_ arg1: Int, _ arg2: String) -> Positional {
            Positional(
                key: "reorder",
                arguments: [
                    .int(arg1),
                    .object(arg2)
                ],
                table: "Positional"
            )
        }

        /// A string that uses the same argument twice
        ///
        /// ### Source Localization
        ///
        /// ```
        /// %1$lld, I repeat: %1$lld
        /// ```
        internal static func repeatExplicit(_ arg1: Int) -> Positional {
            Positional(
                key: "repeatExplicit",
                arguments: [
                    .int(arg1)
                ],
                table: "Positional"
            )
        }

        /// A string that uses the same argument twice implicitly because a positional specifier wasn't provided in one instance
        ///
        /// ### Source Localization
        ///
        /// ```
        /// %@, are you there? %1$@?
        /// ```
        internal static func repeatImplicit(_ arg1: String) -> Positional {
            Positional(
                key: "repeatImplicit",
                arguments: [
                    .object(arg1)
                ],
                table: "Positional"
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

        internal static func ==(lhs: Positional, rhs: Positional) -> Bool {
            lhs._key == rhs._key && lhs.arguments == rhs.arguments && lhs.table == rhs.table
        }
    }

    internal init(positional: Positional, locale: Locale? = nil) {
        let key = String(describing: positional.key)
        self.init(
            format: positional.bundle.localizedString(forKey: key, value: nil, table: positional.table),
            locale: locale,
            arguments: positional.arguments.map(\.value)
        )
    }

    /// Creates a `String` that represents a localized value in the ‘Positional‘ strings table.
    internal static func positional(_ positional: String.Positional) -> String {
        String(positional: positional)
    }
}

@available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
extension LocalizedStringResource {
    internal init(positional: String.Positional) {
        self.init(
            positional.key,
            defaultValue: positional.defaultValue,
            table: positional.table,
            bundle: .atURL(positional.bundle.bundleURL)
        )
    }

    /// Creates a `LocalizedStringResource` that represents a localized value in the ‘Positional‘ strings table.
    internal static func positional(_ positional: String.Positional) -> LocalizedStringResource {
        LocalizedStringResource(positional: positional)
    }
}

#if canImport(SwiftUI)
import SwiftUI

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Text {
    /// Creates a text view that displays a localized string defined in the ‘Positional‘ strings table.
    internal init(positional: String.Positional) {
        if #available(macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
            self.init(LocalizedStringResource(positional: positional))
            return
        }

        var stringInterpolation = LocalizedStringKey.StringInterpolation(literalCapacity: 0, interpolationCount: positional.arguments.count)
        for argument in positional.arguments {
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
        key.overrideKeyForLookup(using: positional._key)

        self.init(key, tableName: positional.table, bundle: positional.bundle)
    }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension LocalizedStringKey {
    /// Creates a localized string key that represents a localized value in the ‘Positional‘ strings table.
    @available(macOS 11, iOS 14, tvOS 14, watchOS 7, *)
    internal init(positional: String.Positional) {
        var stringInterpolation = LocalizedStringKey.StringInterpolation(literalCapacity: 0, interpolationCount: 1)

        if #available(macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
            stringInterpolation.appendInterpolation(LocalizedStringResource(positional: positional))
        } else {
            stringInterpolation.appendInterpolation(Text(positional: positional))
        }

        let makeKey = LocalizedStringKey.init(stringInterpolation:)
        self = makeKey(stringInterpolation)
    }

    /// Creates a `LocalizedStringKey` that represents a localized value in the ‘Positional‘ strings table.
    @available(macOS 11, iOS 14, tvOS 14, watchOS 7, *)
    internal static func positional(_ positional: String.Positional) -> LocalizedStringKey {
        LocalizedStringKey(positional: positional)
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
