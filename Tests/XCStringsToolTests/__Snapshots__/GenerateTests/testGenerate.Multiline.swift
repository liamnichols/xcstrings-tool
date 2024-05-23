import Foundation

extension String {
    /// Constant values for the Multiline Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(multiline: .multiline)
    /// value // "Options:\n- One\n- Two\n- Three"
    /// ```
    internal struct Multiline {
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

    internal init(multiline: Multiline, locale: Locale? = nil) {
        let bundle: Bundle = .from(description: multiline.bundle) ?? .main
        let key = String(describing: multiline.key)
        self.init(
            format: bundle.localizedString(forKey: key, value: nil, table: multiline.table),
            locale: locale,
            arguments: multiline.arguments.map(\.value)
        )
    }
}

extension String.Multiline {
    /// This example tests the following:
    /// 1. That line breaks in the defaultValue are supported
    /// 2. That line breaks in the comment are supported
    ///
    /// ### Source Localization
    ///
    /// ```
    /// Options:
    /// - One
    /// - Two
    /// - Three
    /// ```
    internal static var multiline: Self {
        Self (
            key: "multiline",
            arguments: [],
            table: "Multiline",
            bundle: .current
        )
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
private extension String.Multiline {
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

extension String.Multiline.Argument {
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

private extension String.Multiline.BundleDescription {
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
    static func from(description: String.Multiline.BundleDescription) -> Bundle? {
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
    static func from(description: String.Multiline.BundleDescription) -> Self {
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
    /// Constant values for the Multiline Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(localized: .multiline.multiline)
    /// value // "Options:\n- One\n- Two\n- Three"
    ///
    /// // Working with SwiftUI
    /// Text(.multiline.multiline)
    /// ```
    ///
    /// - Note: Using ``LocalizedStringResource.Multiline`` requires iOS 16/macOS 13 or later. See ``String.Multiline`` for a backwards compatible API.
    internal struct Multiline {
        /// This example tests the following:
        /// 1. That line breaks in the defaultValue are supported
        /// 2. That line breaks in the comment are supported
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Options:
        /// - One
        /// - Two
        /// - Three
        /// ```
        internal var multiline: LocalizedStringResource {
            LocalizedStringResource(multiline: .multiline)
        }
    }

    private init(multiline: String.Multiline) {
        self.init(
            multiline.key,
            defaultValue: multiline.defaultValue,
            table: multiline.table,
            bundle: .from(description: multiline.bundle)
        )
    }

    internal static let multiline = Multiline()
}