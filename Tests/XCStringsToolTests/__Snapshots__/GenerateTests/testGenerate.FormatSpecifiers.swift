import Foundation

extension String {
    /// A type that represents localized strings from the ‘FormatSpecifiers‘
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
    /// with the `String`.``Swift/String/init(formatSpecifiers:locale:)``
    /// intializer:
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(formatSpecifiers: .percentage)
    /// value // "Test %"
    /// ```
    ///
    /// Starting in iOS 16/macOS 13/tvOS 16/watchOS 9, `LocalizedStringResource` can also
    /// be used:
    ///
    /// ```swift
    /// var resource = LocalizedStringResource(formatSpecifiers: .percentage)
    /// resource.locale = Locale(identifier: "fr") // customise language
    /// let value = String(localized: resource)    // defer lookup
    /// ```
    ///
    /// ### SwiftUI
    ///
    /// In SwiftUI, it is recommended to use `Text`.``SwiftUI/Text/init(formatSpecifiers:)``
    /// or `LocalizedStringKey`.``SwiftUI/LocalizedStringKey/formatSpecifiers(_:)``
    /// in order for localized values to be resolved within the SwiftUI environment:
    ///
    /// ```swift
    /// var body: some View {
    ///     List {
    ///         Text(formatSpecifiers: .listContent)
    ///     }
    ///     .navigationTitle(.formatSpecifiers(.navigationTitle))
    ///     .environment(\.locale, Locale(identifier: "fr"))
    /// }
    /// ```
    ///
    /// - SeeAlso: [XCStrings Tool Documentation - Using the generated source code](https://swiftpackageindex.com/liamnichols/xcstrings-tool/0.5.2/documentation/documentation/using-the-generated-source-code)
    internal struct FormatSpecifiers: Equatable, Hashable, Sendable {
        #if !SWIFT_PACKAGE
        private class BundleLocator {
        }
        #endif

        enum Argument: Equatable, Hashable, Sendable {
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

        /// %@ should convert to a String argument
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Test %@
        /// ```
        internal static func at(_ arg1: String) -> FormatSpecifiers {
            FormatSpecifiers(
                key: "at",
                arguments: [
                    .object(arg1)
                ],
                table: "FormatSpecifiers"
            )
        }

        /// %d should convert to an Int argument
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Test %d
        /// ```
        internal static func d(_ arg1: Int) -> FormatSpecifiers {
            FormatSpecifiers(
                key: "d",
                arguments: [
                    .int(arg1)
                ],
                table: "FormatSpecifiers"
            )
        }

        /// %lld should covert to an Int
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Test %lld
        /// ```
        internal static func d_length(_ arg1: Int) -> FormatSpecifiers {
            FormatSpecifiers(
                key: "d_length",
                arguments: [
                    .int(arg1)
                ],
                table: "FormatSpecifiers"
            )
        }

        /// %f should convert to a Double argument
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Test %f
        /// ```
        internal static func f(_ arg1: Double) -> FormatSpecifiers {
            FormatSpecifiers(
                key: "f",
                arguments: [
                    .double(arg1)
                ],
                table: "FormatSpecifiers"
            )
        }

        /// %.2f should convert to a Double argument
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Test %.2f
        /// ```
        internal static func f_precision(_ arg1: Double) -> FormatSpecifiers {
            FormatSpecifiers(
                key: "f_precision",
                arguments: [
                    .double(arg1)
                ],
                table: "FormatSpecifiers"
            )
        }

        /// %i should convert to an Int argument
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Test %i
        /// ```
        internal static func i(_ arg1: Int) -> FormatSpecifiers {
            FormatSpecifiers(
                key: "i",
                arguments: [
                    .int(arg1)
                ],
                table: "FormatSpecifiers"
            )
        }

        /// %o should convert to a UInt argument
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Test %o
        /// ```
        internal static func o(_ arg1: UInt) -> FormatSpecifiers {
            FormatSpecifiers(
                key: "o",
                arguments: [
                    .uint(arg1)
                ],
                table: "FormatSpecifiers"
            )
        }

        /// % should not be converted to an argument
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Test %
        /// ```
        internal static var percentage: FormatSpecifiers {
            FormatSpecifiers(
                key: "percentage",
                arguments: [],
                table: "FormatSpecifiers"
            )
        }

        /// %% should not be converted to an argument
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Test %%
        /// ```
        internal static var percentage_escaped: FormatSpecifiers {
            FormatSpecifiers(
                key: "percentage_escaped",
                arguments: [],
                table: "FormatSpecifiers"
            )
        }

        /// %% should not be converted to an argument
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Test 50%% off
        /// ```
        internal static var percentage_escaped_space_o: FormatSpecifiers {
            FormatSpecifiers(
                key: "percentage_escaped_space_o",
                arguments: [],
                table: "FormatSpecifiers"
            )
        }

        /// '% o' should not be converted to an argument
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Test 50% off
        /// ```
        internal static var percentage_space_o: FormatSpecifiers {
            FormatSpecifiers(
                key: "percentage_space_o",
                arguments: [],
                table: "FormatSpecifiers"
            )
        }

        /// %u should convert to a UInt argument
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Test %u
        /// ```
        internal static func u(_ arg1: UInt) -> FormatSpecifiers {
            FormatSpecifiers(
                key: "u",
                arguments: [
                    .uint(arg1)
                ],
                table: "FormatSpecifiers"
            )
        }

        /// %x should convert to a UInt argument
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Test %x
        /// ```
        internal static func x(_ arg1: UInt) -> FormatSpecifiers {
            FormatSpecifiers(
                key: "x",
                arguments: [
                    .uint(arg1)
                ],
                table: "FormatSpecifiers"
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

        internal static func ==(lhs: FormatSpecifiers, rhs: FormatSpecifiers) -> Bool {
            lhs._key == rhs._key && lhs.arguments == rhs.arguments && lhs.table == rhs.table
        }
    }

    internal init(formatSpecifiers: FormatSpecifiers, locale: Locale? = nil) {
        let key = String(describing: formatSpecifiers.key)
        self.init(
            format: formatSpecifiers.bundle.localizedString(forKey: key, value: nil, table: formatSpecifiers.table),
            locale: locale,
            arguments: formatSpecifiers.arguments.map(\.value)
        )
    }
}

@available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
extension LocalizedStringResource {
    internal init(formatSpecifiers: String.FormatSpecifiers) {
        self.init(
            formatSpecifiers.key,
            defaultValue: formatSpecifiers.defaultValue,
            table: formatSpecifiers.table,
            bundle: .atURL(formatSpecifiers.bundle.bundleURL)
        )
    }

    /// Creates a `LocalizedStringResource` that represents a localized value in the ‘FormatSpecifiers‘ strings table.
    internal static func formatSpecifiers(_ formatSpecifiers: String.FormatSpecifiers) -> LocalizedStringResource {
        LocalizedStringResource(formatSpecifiers: formatSpecifiers)
    }
}

#if canImport(SwiftUI)
import SwiftUI

@available(macOS 10.5, iOS 13, tvOS 13, watchOS 6, *)
extension Text {
    /// Creates a text view that displays a localized string defined in the ‘FormatSpecifiers‘ strings table.
    internal init(formatSpecifiers: String.FormatSpecifiers) {
        if #available(macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
            self.init(LocalizedStringResource(formatSpecifiers: formatSpecifiers))
            return
        }

        var stringInterpolation = LocalizedStringKey.StringInterpolation(literalCapacity: 0, interpolationCount: formatSpecifiers.arguments.count)
        for argument in formatSpecifiers.arguments {
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
        key.overrideKeyForLookup(using: formatSpecifiers._key)

        self.init(key, tableName: formatSpecifiers.table, bundle: formatSpecifiers.bundle)
    }
}

@available(macOS 10.5, iOS 13, tvOS 13, watchOS 6, *)
extension LocalizedStringKey {
    /// Creates a localized string key that represents a localized value in the ‘FormatSpecifiers‘ strings table.
    @available(macOS 11, iOS 14, tvOS 14, watchOS 7, *)
    internal init(formatSpecifiers: String.FormatSpecifiers) {
        var stringInterpolation = LocalizedStringKey.StringInterpolation(literalCapacity: 0, interpolationCount: 1)

        if #available(macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
            stringInterpolation.appendInterpolation(LocalizedStringResource(formatSpecifiers: formatSpecifiers))
        } else {
            stringInterpolation.appendInterpolation(Text(formatSpecifiers: formatSpecifiers))
        }

        let makeKey = LocalizedStringKey.init(stringInterpolation:)
        self = makeKey(stringInterpolation)
    }

    /// Creates a `LocalizedStringKey` that represents a localized value in the ‘FormatSpecifiers‘ strings table.
    @available(macOS 11, iOS 14, tvOS 14, watchOS 7, *)
    internal static func formatSpecifiers(_ formatSpecifiers: String.FormatSpecifiers) -> LocalizedStringKey {
        LocalizedStringKey(formatSpecifiers: formatSpecifiers)
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
