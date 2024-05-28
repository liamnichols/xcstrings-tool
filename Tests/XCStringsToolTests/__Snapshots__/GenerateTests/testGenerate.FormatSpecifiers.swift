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
    /// - SeeAlso: [XCStrings Tool Documentation - Using the generated source code](https://swiftpackageindex.com/liamnichols/xcstrings-tool/0.4.1/documentation/documentation/using-the-generated-source-code)
    internal struct FormatSpecifiers: Sendable {
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
                table: "FormatSpecifiers",
                bundle: .current
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
                table: "FormatSpecifiers",
                bundle: .current
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
                table: "FormatSpecifiers",
                bundle: .current
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
                table: "FormatSpecifiers",
                bundle: .current
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
                table: "FormatSpecifiers",
                bundle: .current
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
                table: "FormatSpecifiers",
                bundle: .current
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
                table: "FormatSpecifiers",
                bundle: .current
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
                table: "FormatSpecifiers",
                bundle: .current
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
                table: "FormatSpecifiers",
                bundle: .current
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
                table: "FormatSpecifiers",
                bundle: .current
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
                table: "FormatSpecifiers",
                bundle: .current
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
                table: "FormatSpecifiers",
                bundle: .current
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
                table: "FormatSpecifiers",
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

    internal init(formatSpecifiers: FormatSpecifiers, locale: Locale? = nil) {
        let bundle: Bundle = .from(description: formatSpecifiers.bundle) ?? .main
        let key = String(describing: formatSpecifiers.key)
        self.init(
            format: bundle.localizedString(forKey: key, value: nil, table: formatSpecifiers.table),
            locale: locale,
            arguments: formatSpecifiers.arguments.map(\.value)
        )
    }
}

extension Bundle {
    static func from(description: String.FormatSpecifiers.BundleDescription) -> Bundle? {
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
    static func from(description: String.FormatSpecifiers.BundleDescription) -> Self {
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
    /// Constant values for the FormatSpecifiers Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(localized: .formatSpecifiers.percentage)
    /// value // "Test %"
    ///
    /// // Working with SwiftUI
    /// Text(.formatSpecifiers.percentage)
    /// ```
    ///
    /// - Note: Using ``LocalizedStringResource.FormatSpecifiers`` requires iOS 16/macOS 13 or later. See ``String.FormatSpecifiers`` for a backwards compatible API.
    internal struct FormatSpecifiers {
        /// %@ should convert to a String argument
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Test %@
        /// ```
        @available (iOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.at(_:)` instead. This method will be removed in the future.")
        @available (macOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.at(_:)` instead. This method will be removed in the future.")
        @available (tvOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.at(_:)` instead. This method will be removed in the future.")
        @available (watchOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.at(_:)` instead. This method will be removed in the future.")
        @available (visionOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.at(_:)` instead. This method will be removed in the future.")
        internal func at(_ arg1: String) -> LocalizedStringResource {
            LocalizedStringResource(formatSpecifiers: .at(arg1))
        }

        /// %d should convert to an Int argument
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Test %d
        /// ```
        @available (iOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.d(_:)` instead. This method will be removed in the future.")
        @available (macOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.d(_:)` instead. This method will be removed in the future.")
        @available (tvOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.d(_:)` instead. This method will be removed in the future.")
        @available (watchOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.d(_:)` instead. This method will be removed in the future.")
        @available (visionOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.d(_:)` instead. This method will be removed in the future.")
        internal func d(_ arg1: Int) -> LocalizedStringResource {
            LocalizedStringResource(formatSpecifiers: .d(arg1))
        }

        /// %lld should covert to an Int
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Test %lld
        /// ```
        @available (iOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.d_length(_:)` instead. This method will be removed in the future.")
        @available (macOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.d_length(_:)` instead. This method will be removed in the future.")
        @available (tvOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.d_length(_:)` instead. This method will be removed in the future.")
        @available (watchOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.d_length(_:)` instead. This method will be removed in the future.")
        @available (visionOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.d_length(_:)` instead. This method will be removed in the future.")
        internal func d_length(_ arg1: Int) -> LocalizedStringResource {
            LocalizedStringResource(formatSpecifiers: .d_length(arg1))
        }

        /// %f should convert to a Double argument
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Test %f
        /// ```
        @available (iOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.f(_:)` instead. This method will be removed in the future.")
        @available (macOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.f(_:)` instead. This method will be removed in the future.")
        @available (tvOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.f(_:)` instead. This method will be removed in the future.")
        @available (watchOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.f(_:)` instead. This method will be removed in the future.")
        @available (visionOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.f(_:)` instead. This method will be removed in the future.")
        internal func f(_ arg1: Double) -> LocalizedStringResource {
            LocalizedStringResource(formatSpecifiers: .f(arg1))
        }

        /// %.2f should convert to a Double argument
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Test %.2f
        /// ```
        @available (iOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.f_precision(_:)` instead. This method will be removed in the future.")
        @available (macOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.f_precision(_:)` instead. This method will be removed in the future.")
        @available (tvOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.f_precision(_:)` instead. This method will be removed in the future.")
        @available (watchOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.f_precision(_:)` instead. This method will be removed in the future.")
        @available (visionOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.f_precision(_:)` instead. This method will be removed in the future.")
        internal func f_precision(_ arg1: Double) -> LocalizedStringResource {
            LocalizedStringResource(formatSpecifiers: .f_precision(arg1))
        }

        /// %i should convert to an Int argument
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Test %i
        /// ```
        @available (iOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.i(_:)` instead. This method will be removed in the future.")
        @available (macOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.i(_:)` instead. This method will be removed in the future.")
        @available (tvOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.i(_:)` instead. This method will be removed in the future.")
        @available (watchOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.i(_:)` instead. This method will be removed in the future.")
        @available (visionOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.i(_:)` instead. This method will be removed in the future.")
        internal func i(_ arg1: Int) -> LocalizedStringResource {
            LocalizedStringResource(formatSpecifiers: .i(arg1))
        }

        /// %o should convert to a UInt argument
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Test %o
        /// ```
        @available (iOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.o(_:)` instead. This method will be removed in the future.")
        @available (macOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.o(_:)` instead. This method will be removed in the future.")
        @available (tvOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.o(_:)` instead. This method will be removed in the future.")
        @available (watchOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.o(_:)` instead. This method will be removed in the future.")
        @available (visionOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.o(_:)` instead. This method will be removed in the future.")
        internal func o(_ arg1: UInt) -> LocalizedStringResource {
            LocalizedStringResource(formatSpecifiers: .o(arg1))
        }

        /// % should not be converted to an argument
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Test %
        /// ```
        @available (iOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.percentage` instead. This property will be removed in the future.")
        @available (macOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.percentage` instead. This property will be removed in the future.")
        @available (tvOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.percentage` instead. This property will be removed in the future.")
        @available (watchOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.percentage` instead. This property will be removed in the future.")
        @available (visionOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.percentage` instead. This property will be removed in the future.")
        internal var percentage: LocalizedStringResource {
            LocalizedStringResource(formatSpecifiers: .percentage)
        }

        /// %% should not be converted to an argument
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Test %%
        /// ```
        @available (iOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.percentage_escaped` instead. This property will be removed in the future.")
        @available (macOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.percentage_escaped` instead. This property will be removed in the future.")
        @available (tvOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.percentage_escaped` instead. This property will be removed in the future.")
        @available (watchOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.percentage_escaped` instead. This property will be removed in the future.")
        @available (visionOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.percentage_escaped` instead. This property will be removed in the future.")
        internal var percentage_escaped: LocalizedStringResource {
            LocalizedStringResource(formatSpecifiers: .percentage_escaped)
        }

        /// %% should not be converted to an argument
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Test 50%% off
        /// ```
        @available (iOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.percentage_escaped_space_o` instead. This property will be removed in the future.")
        @available (macOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.percentage_escaped_space_o` instead. This property will be removed in the future.")
        @available (tvOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.percentage_escaped_space_o` instead. This property will be removed in the future.")
        @available (watchOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.percentage_escaped_space_o` instead. This property will be removed in the future.")
        @available (visionOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.percentage_escaped_space_o` instead. This property will be removed in the future.")
        internal var percentage_escaped_space_o: LocalizedStringResource {
            LocalizedStringResource(formatSpecifiers: .percentage_escaped_space_o)
        }

        /// '% o' should not be converted to an argument
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Test 50% off
        /// ```
        @available (iOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.percentage_space_o` instead. This property will be removed in the future.")
        @available (macOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.percentage_space_o` instead. This property will be removed in the future.")
        @available (tvOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.percentage_space_o` instead. This property will be removed in the future.")
        @available (watchOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.percentage_space_o` instead. This property will be removed in the future.")
        @available (visionOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.percentage_space_o` instead. This property will be removed in the future.")
        internal var percentage_space_o: LocalizedStringResource {
            LocalizedStringResource(formatSpecifiers: .percentage_space_o)
        }

        /// %u should convert to a UInt argument
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Test %u
        /// ```
        @available (iOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.u(_:)` instead. This method will be removed in the future.")
        @available (macOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.u(_:)` instead. This method will be removed in the future.")
        @available (tvOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.u(_:)` instead. This method will be removed in the future.")
        @available (watchOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.u(_:)` instead. This method will be removed in the future.")
        @available (visionOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.u(_:)` instead. This method will be removed in the future.")
        internal func u(_ arg1: UInt) -> LocalizedStringResource {
            LocalizedStringResource(formatSpecifiers: .u(arg1))
        }

        /// %x should convert to a UInt argument
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Test %x
        /// ```
        @available (iOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.x(_:)` instead. This method will be removed in the future.")
        @available (macOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.x(_:)` instead. This method will be removed in the future.")
        @available (tvOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.x(_:)` instead. This method will be removed in the future.")
        @available (watchOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.x(_:)` instead. This method will be removed in the future.")
        @available (visionOS, deprecated: 100000, message: "Use `String.FormatSpecifiers.x(_:)` instead. This method will be removed in the future.")
        internal func x(_ arg1: UInt) -> LocalizedStringResource {
            LocalizedStringResource(formatSpecifiers: .x(arg1))
        }
    }

    @available (iOS, deprecated: 100000, message: "Use the `formatSpecifiers(_:)` static method instead. This property will be removed in the future.")
    @available (macOS, deprecated: 100000, message: "Use the `formatSpecifiers(_:)` static method instead. This property will be removed in the future.")
    @available (tvOS, deprecated: 100000, message: "Use the `formatSpecifiers(_:)` static method instead. This property will be removed in the future.")
    @available (watchOS, deprecated: 100000, message: "Use the `formatSpecifiers(_:)` static method instead. This property will be removed in the future.")
    @available (visionOS, deprecated: 100000, message: "Use the `formatSpecifiers(_:)` static method instead. This property will be removed in the future.") internal static let formatSpecifiers = FormatSpecifiers()

    internal init(formatSpecifiers: String.FormatSpecifiers) {
        self.init(
            formatSpecifiers.key,
            defaultValue: formatSpecifiers.defaultValue,
            table: formatSpecifiers.table,
            bundle: .from(description: formatSpecifiers.bundle)
        )
    }

    /// Creates a `LocalizedStringResource` that represents a localized value in the ‘FormatSpecifiers‘ strings table.
    internal static func formatSpecifiers(_ formatSpecifiers: String.FormatSpecifiers) -> LocalizedStringResource {
        LocalizedStringResource(formatSpecifiers: formatSpecifiers)
    }
}

#if canImport (SwiftUI)
import SwiftUI

@available(macOS 10.5, iOS 13, tvOS 13, watchOS 6, *)
extension Text {
    /// Creates a text view that displays a localized string defined in the ‘FormatSpecifiers‘ strings table.
    internal init(formatSpecifiers: String.FormatSpecifiers) {
        if #available (macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
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
        key.overrideKeyForLookup(using: formatSpecifiers.key)

        self.init(key, tableName: formatSpecifiers.table, bundle: .from(description: formatSpecifiers.bundle))
    }
}

@available(macOS 10.5, iOS 13, tvOS 13, watchOS 6, *)
extension LocalizedStringKey {
    /// Creates a localized string key that represents a localized value in the ‘FormatSpecifiers‘ strings table.
    @available(macOS 11, iOS 14, tvOS 14, watchOS 7, *)
    internal init(formatSpecifiers: String.FormatSpecifiers) {
        var stringInterpolation = LocalizedStringKey.StringInterpolation(literalCapacity: 0, interpolationCount: 1)

        if #available (macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
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
    fileprivate mutating func overrideKeyForLookup(using key: StaticString) {
        withUnsafeMutablePointer(to: &self) { pointer in
            let raw = UnsafeMutableRawPointer(pointer)
            let bound = raw.assumingMemoryBound(to: String.self)
            bound.pointee = String(describing: key)
        }
    }
}
#endif
