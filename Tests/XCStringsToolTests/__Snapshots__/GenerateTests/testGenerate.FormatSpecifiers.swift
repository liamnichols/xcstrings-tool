import Foundation

extension String {
    /// Constant values for the FormatSpecifiers Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(formatSpecifiers: .percentage)
    /// value // "Test %"
    /// ```
    internal struct FormatSpecifiers {
        enum BundleDescription {
            case main
            case atURL(URL)
            case forClass(AnyClass)
        }

        enum Argument {
            case int(Int)
            case uint(UInt)
            case float(Float)
            case double(Double)
            case object(String)
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

extension String.FormatSpecifiers {
    /// %@ should convert to a String argument
    ///
    /// ### Source Localization
    ///
    /// ```
    /// Test %@
    /// ```
    internal static func at(_ arg1: String) -> Self {
        Self (
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
    internal static func d(_ arg1: Int) -> Self {
        Self (
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
    internal static func d_length(_ arg1: Int) -> Self {
        Self (
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
    internal static func f(_ arg1: Double) -> Self {
        Self (
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
    internal static func f_precision(_ arg1: Double) -> Self {
        Self (
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
    internal static func i(_ arg1: Int) -> Self {
        Self (
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
    internal static func o(_ arg1: UInt) -> Self {
        Self (
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
    internal static var percentage: Self {
        Self (
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
    internal static var percentage_escaped: Self {
        Self (
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
    internal static var percentage_escaped_space_o: Self {
        Self (
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
    internal static var percentage_space_o: Self {
        Self (
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
    internal static func u(_ arg1: UInt) -> Self {
        Self (
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
    internal static func x(_ arg1: UInt) -> Self {
        Self (
            key: "x",
            arguments: [
                .uint(arg1)
            ],
            table: "FormatSpecifiers",
            bundle: .current
        )
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
private extension String.FormatSpecifiers {
    var defaultValue: String.LocalizationValue {
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

extension String.FormatSpecifiers.Argument {
    var value: CVarArg {
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

private extension String.FormatSpecifiers.BundleDescription {
    #if !SWIFT_PACKAGE
    private class BundleLocator {
    }
    #endif

    static var current: Self {
        #if SWIFT_PACKAGE
        .atURL(Bundle.module.bundleURL)
        #else
        .forClass(BundleLocator.self)
        #endif
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
        internal func x(_ arg1: UInt) -> LocalizedStringResource {
            LocalizedStringResource(formatSpecifiers: .x(arg1))
        }
    }

    private init(formatSpecifiers: String.FormatSpecifiers) {
        self.init(
            formatSpecifiers.key,
            defaultValue: formatSpecifiers.defaultValue,
            table: formatSpecifiers.table,
            bundle: .from(description: formatSpecifiers.bundle)
        )
    }

    internal static let formatSpecifiers = FormatSpecifiers()
}