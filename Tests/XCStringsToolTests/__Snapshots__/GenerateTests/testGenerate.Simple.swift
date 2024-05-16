import Foundation

extension String {
    /// Constant values for the Simple Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(simple: .simpleKey)
    /// value // "My Value"
    /// ```
    internal struct Simple {
        enum BundleDescription {
            case main
            case atURL(URL)
            case forClass(AnyClass)
        }

        enum Argument {
            case object(String)
            case int(Int)
            case uint(UInt)
            case double(Double)
            case float(Float)
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

    internal init(simple: Simple, locale: Locale? = nil) {
        let bundle: Bundle = .from(description: simple.bundle) ?? .main
        let key = String(describing: simple.key)
        self.init(
            format: bundle.localizedString(forKey: key, value: nil, table: simple.table),
            locale: locale,
            arguments: simple.arguments.map(\.value)
        )
    }
}

extension String.Simple {
    /// This is a simple key and value
    ///
    /// ### Source Localization
    ///
    /// ```
    /// My Value
    /// ```
    internal static var simpleKey: Self {
        Self (
            key: "SimpleKey",
            arguments: [],
            table: "Simple",
            bundle: .current
        )
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
private extension String.Simple {
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

extension String.Simple.Argument {
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

private extension String.Simple.BundleDescription {
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
    static func from(description: String.Simple.BundleDescription) -> Bundle? {
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
    static func from(description: String.Simple.BundleDescription) -> Self {
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
    /// Constant values for the Simple Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(localized: .simple.simpleKey)
    /// value // "My Value"
    ///
    /// // Working with SwiftUI
    /// Text(.simple.simpleKey)
    /// ```
    ///
    /// - Note: Using ``LocalizedStringResource.Simple`` requires iOS 16/macOS 13 or later. See ``String.Simple`` for a backwards compatible API.
    internal struct Simple {
        /// This is a simple key and value
        ///
        /// ### Source Localization
        ///
        /// ```
        /// My Value
        /// ```
        internal var simpleKey: LocalizedStringResource {
            LocalizedStringResource(simple: .simpleKey)
        }
    }

    private init(simple: String.Simple) {
        self.init(
            simple.key,
            defaultValue: simple.defaultValue,
            table: simple.table,
            bundle: .from(description: simple.bundle)
        )
    }

    internal static let simple = Simple()
}