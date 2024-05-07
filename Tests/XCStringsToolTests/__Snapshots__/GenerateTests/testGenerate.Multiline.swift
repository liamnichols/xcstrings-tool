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
    internal init(multiline: Multiline, locale: Locale? = nil) {
        self.init(
            localized: multiline.key,
            defaultValue: multiline.defaultValue,
            table: multiline.table,
            bundle: .from(description: multiline.bundle),
            locale: locale ?? multiline.locale
        )
    }
}

extension String.Multiline {
    /// This example tests the following:
    /// 1. That line breaks in the defaultValue are supported
    /// 2. That line breaks in the comment are supported
    internal static var multiline: Self {
        Self (
            key: "multiline",
            arguments: [],
            table: "Multiline",
            locale: .current,
            bundle: .current
        )
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension String.Multiline {
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

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
private extension Bundle {
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
    /// - Note: Using ``LocalizedStringResource.Multiline`` requires iOS 16/macOS 13 or later. See ``String.Multiline`` for an iOS 15/macOS 12 compatible API.
    internal struct Multiline {
        /// This example tests the following:
        /// 1. That line breaks in the defaultValue are supported
        /// 2. That line breaks in the comment are supported
        internal var multiline: LocalizedStringResource {
            LocalizedStringResource(multiline: .multiline)
        }
    }

    private init(multiline: String.Multiline) {
        self.init(
            multiline.key,
            defaultValue: multiline.defaultValue,
            table: multiline.table,
            locale: multiline.locale,
            bundle: .from(description: multiline.bundle)
        )
    }

    internal static let multiline = Multiline()
}