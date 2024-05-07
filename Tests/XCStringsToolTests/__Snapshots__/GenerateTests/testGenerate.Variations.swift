import Foundation

extension String {
    /// Constant values for the Variations Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(variations: .stringDevice)
    /// value // "Tap to open"
    /// ```
    internal struct Variations {
        fileprivate enum BundleDescription {
            case main
            case atURL(URL)
            case forClass(AnyClass)
        }

        fileprivate enum Argument {
            case object(String)
            case int(Int)
            case uint(UInt)
            case double(Double)
            case float(Float)
        }

        fileprivate let key: StaticString
        fileprivate let arguments: [Argument]
        fileprivate let table: String?
        fileprivate let locale: Locale
        fileprivate let bundle: BundleDescription

        fileprivate init(
            key: StaticString,
            arguments: [Argument],
            table: String?,
            locale: Locale,
            bundle: BundleDescription
        ) {
            self.key = key
            self.arguments = arguments
            self.table = table
            self.locale = locale
            self.bundle = bundle
        }
    }

    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    internal init(variations: Variations, locale: Locale? = nil) {
        self.init(
            localized: variations.key,
            defaultValue: variations.defaultValue,
            table: variations.table,
            bundle: .from(description: variations.bundle),
            locale: locale ?? variations.locale
        )
    }
}

extension String.Variations {
    /// A string that should have a macOS variation to replace 'Tap' with 'Click'
    internal static var stringDevice: Self {
        Self (
            key: "String.Device",
            arguments: [],
            table: "Variations",
            locale: .current,
            bundle: .current
        )
    }

    internal static func stringPlural(_ arg1: Int) -> Self {
        Self (
            key: "String.Plural",
            arguments: [
                .int(arg1)
            ],
            table: "Variations",
            locale: .current,
            bundle: .current
        )
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension String.Variations {
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
        return String.LocalizationValue(stringInterpolation: stringInterpolation)
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
private extension String.Variations.BundleDescription {
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

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
private extension Bundle {
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
    /// - Note: Using ``LocalizedStringResource.Variations`` requires iOS 16/macOS 13 or later. See ``String.Variations`` for an iOS 15/macOS 12 compatible API.
    internal struct Variations {
        /// A string that should have a macOS variation to replace 'Tap' with 'Click'
        internal var stringDevice: LocalizedStringResource {
            LocalizedStringResource(variations: .stringDevice)
        }

        internal func stringPlural(_ arg1: Int) -> LocalizedStringResource {
            LocalizedStringResource(variations: .stringPlural(arg1))
        }
    }

    private init(variations: String.Variations) {
        self.init(
            variations.key,
            defaultValue: variations.defaultValue,
            table: variations.table,
            locale: variations.locale,
            bundle: .from(description: variations.bundle)
        )
    }

    internal static let variations = Variations()
}