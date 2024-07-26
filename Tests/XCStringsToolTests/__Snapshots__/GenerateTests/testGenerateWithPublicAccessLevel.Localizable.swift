import Foundation

extension String {
    /// A type that represents localized strings from the ‘Localizable‘
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
    /// with the `String`.``Swift/String/init(localizable:locale:)``
    /// intializer:
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(localizable: .continue)
    /// value // "Continue"
    /// ```
    ///
    /// Starting in iOS 16/macOS 13/tvOS 16/watchOS 9, `LocalizedStringResource` can also
    /// be used:
    ///
    /// ```swift
    /// var resource = LocalizedStringResource(localizable: .continue)
    /// resource.locale = Locale(identifier: "fr") // customise language
    /// let value = String(localized: resource)    // defer lookup
    /// ```
    ///
    /// ### SwiftUI
    ///
    /// In SwiftUI, it is recommended to use `Text`.``SwiftUI/Text/init(localizable:)``
    /// or `LocalizedStringKey`.``SwiftUI/LocalizedStringKey/localizable(_:)``
    /// in order for localized values to be resolved within the SwiftUI environment:
    ///
    /// ```swift
    /// var body: some View {
    ///     List {
    ///         Text(localizable: .listContent)
    ///     }
    ///     .navigationTitle(.localizable(.navigationTitle))
    ///     .environment(\.locale, Locale(identifier: "fr"))
    /// }
    /// ```
    ///
    /// - SeeAlso: [XCStrings Tool Documentation - Using the generated source code](https://swiftpackageindex.com/liamnichols/xcstrings-tool/0.5.2/documentation/documentation/using-the-generated-source-code)
    public struct Localizable: Sendable {
        #if !SWIFT_PACKAGE
        private class BundleLocator {
        }
        #endif

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

        fileprivate init(
            key: StaticString,
            arguments: [Argument],
            table: String?
        ) {
            self.key = key
            self.arguments = arguments
            self.table = table
        }

        /// A key that conflicts with a keyword in swift that isn't suitable for a variable/method and should be backticked.
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Continue
        /// ```
        public static var `continue`: Localizable {
            Localizable(
                key: "continue",
                arguments: [],
                table: "Localizable"
            )
        }

        /// This is a comment
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Default Value
        /// ```
        public static var key: Localizable {
            Localizable(
                key: "Key",
                arguments: [],
                table: "Localizable"
            )
        }

        /// ### Source Localization
        ///
        /// ```
        /// Multiplatform Original
        /// ```
        public static var myDeviceVariant: Localizable {
            Localizable(
                key: "myDeviceVariant",
                arguments: [],
                table: "Localizable"
            )
        }

        /// ### Source Localization
        ///
        /// ```
        /// I have %lld plurals
        /// ```
        public static func myPlural(_ arg1: Int) -> Localizable {
            Localizable(
                key: "myPlural",
                arguments: [
                    .int(arg1)
                ],
                table: "Localizable"
            )
        }

        /// ### Source Localization
        ///
        /// ```
        /// %lld: People liked %lld posts
        /// ```
        public static func mySubstitute(_ arg1: Int, count arg2: Int) -> Localizable {
            Localizable(
                key: "mySubstitute",
                arguments: [
                    .int(arg1),
                    .int(arg2)
                ],
                table: "Localizable"
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
    }

    public init(localizable: Localizable, locale: Locale? = nil) {
        let key = String(describing: localizable.key)
        self.init(
            format: localizable.bundle.localizedString(forKey: key, value: nil, table: localizable.table),
            locale: locale,
            arguments: localizable.arguments.map(\.value)
        )
    }
}

@available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
extension LocalizedStringResource {
    public init(localizable: String.Localizable) {
        self.init(
            localizable.key,
            defaultValue: localizable.defaultValue,
            table: localizable.table,
            bundle: .atURL(localizable.bundle.bundleURL)
        )
    }

    /// Creates a `LocalizedStringResource` that represents a localized value in the ‘Localizable‘ strings table.
    public static func localizable(_ localizable: String.Localizable) -> LocalizedStringResource {
        LocalizedStringResource(localizable: localizable)
    }
}

#if canImport(SwiftUI)
import SwiftUI

@available(macOS 10.5, iOS 13, tvOS 13, watchOS 6, *)
extension Text {
    /// Creates a text view that displays a localized string defined in the ‘Localizable‘ strings table.
    public init(localizable: String.Localizable) {
        if #available(macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
            self.init(LocalizedStringResource(localizable: localizable))
            return
        }

        var stringInterpolation = LocalizedStringKey.StringInterpolation(literalCapacity: 0, interpolationCount: localizable.arguments.count)
        for argument in localizable.arguments {
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
        key.overrideKeyForLookup(using: localizable._key)

        self.init(key, tableName: localizable.table, bundle: localizable.bundle)
    }
}

@available(macOS 10.5, iOS 13, tvOS 13, watchOS 6, *)
extension LocalizedStringKey {
    /// Creates a localized string key that represents a localized value in the ‘Localizable‘ strings table.
    @available(macOS 11, iOS 14, tvOS 14, watchOS 7, *)
    public init(localizable: String.Localizable) {
        var stringInterpolation = LocalizedStringKey.StringInterpolation(literalCapacity: 0, interpolationCount: 1)

        if #available(macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
            stringInterpolation.appendInterpolation(LocalizedStringResource(localizable: localizable))
        } else {
            stringInterpolation.appendInterpolation(Text(localizable: localizable))
        }

        let makeKey = LocalizedStringKey.init(stringInterpolation:)
        self = makeKey(stringInterpolation)
    }

    /// Creates a `LocalizedStringKey` that represents a localized value in the ‘Localizable‘ strings table.
    @available(macOS 11, iOS 14, tvOS 14, watchOS 7, *)
    public static func localizable(_ localizable: String.Localizable) -> LocalizedStringKey {
        LocalizedStringKey(localizable: localizable)
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
