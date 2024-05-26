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
        enum BundleDescription {
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

        enum Argument {
            case int(Int)
            case uint(UInt)
            case float(Float)
            case double(Double)
            case object(String)

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

        /// A string that should have a macOS variation to replace 'Tap' with 'Click'
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Tap to open
        /// ```
        internal static var stringDevice: Variations {
            Variations(
                key: "String.Device",
                arguments: [],
                table: "Variations",
                bundle: .current
            )
        }

        /// ### Source Localization
        ///
        /// ```
        /// I have %lld strings
        /// ```
        internal static func stringPlural(_ arg1: Int) -> Variations {
            Variations(
                key: "String.Plural",
                arguments: [
                    .int(arg1)
                ],
                table: "Variations",
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

    internal init(variations: Variations, locale: Locale? = nil) {
        let bundle: Bundle = .from(description: variations.bundle) ?? .main
        let key = String(describing: variations.key)
        self.init(
            format: bundle.localizedString(forKey: key, value: nil, table: variations.table),
            locale: locale,
            arguments: variations.arguments.map(\.value)
        )
    }
}

extension Bundle {
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
    /// - Note: Using ``LocalizedStringResource.Variations`` requires iOS 16/macOS 13 or later. See ``String.Variations`` for a backwards compatible API.
    internal struct Variations {
        /// A string that should have a macOS variation to replace 'Tap' with 'Click'
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Tap to open
        /// ```
        internal var stringDevice: LocalizedStringResource {
            LocalizedStringResource(variations: .stringDevice)
        }

        /// ### Source Localization
        ///
        /// ```
        /// I have %lld strings
        /// ```
        internal func stringPlural(_ arg1: Int) -> LocalizedStringResource {
            LocalizedStringResource(variations: .stringPlural(arg1))
        }
    }

    internal static let variations = Variations()

    internal init(variations: String.Variations) {
        self.init(
            variations.key,
            defaultValue: variations.defaultValue,
            table: variations.table,
            bundle: .from(description: variations.bundle)
        )
    }

    internal static func variations(_ variations: String.Variations) -> LocalizedStringResource {
        LocalizedStringResource(variations: variations)
    }
}

#if canImport (SwiftUI)
import SwiftUI

@available(macOS 10.5, iOS 13, tvOS 13, watchOS 6, *)
extension Text {
    init(variations: String.Variations) {
        if #available (macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
            self.init(LocalizedStringResource(variations: variations))
            return
        }

        var stringInterpolation = LocalizedStringKey.StringInterpolation(literalCapacity: 0, interpolationCount: variations.arguments.count)
        for argument in variations.arguments {
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
        key.overrideKeyForLookup(using: variations.key)

        self.init(key, tableName: variations.table, bundle: .from(description: variations.bundle))
    }
}

@available(macOS 10.5, iOS 13, tvOS 13, watchOS 6, *)
extension LocalizedStringKey {
    internal init(variations: String.Variations) {
        let text = Text(variations: variations)

        var stringInterpolation = LocalizedStringKey.StringInterpolation(literalCapacity: 0, interpolationCount: 1)
        stringInterpolation.appendInterpolation(text)

        let makeKey = LocalizedStringKey.init(stringInterpolation:)
        self = makeKey(stringInterpolation)
    }

    internal static func variations(_ variations: String.Variations) -> LocalizedStringKey {
        LocalizedStringKey(variations: variations)
    }

    fileprivate mutating func overrideKeyForLookup(using key: StaticString) {
        withUnsafeMutablePointer(to: &self) { pointer in
            let raw = UnsafeMutableRawPointer(pointer)
            let bound = raw.assumingMemoryBound(to: String.self)
            bound.pointee = String(describing: key)
        }
    }
}
#endif
