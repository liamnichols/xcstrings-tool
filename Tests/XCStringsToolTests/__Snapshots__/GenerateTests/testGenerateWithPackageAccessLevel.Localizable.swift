import Foundation

extension String {
    /// Constant values for the Localizable Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(localizable: .key)
    /// value // "Default Value"
    /// ```
    package struct Localizable {
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

        /// This is a comment
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Default Value
        /// ```
        package static var key: Localizable {
            Localizable(
                key: "Key",
                arguments: [],
                table: "Localizable",
                bundle: .current
            )
        }

        /// ### Source Localization
        ///
        /// ```
        /// Multiplatform Original
        /// ```
        package static var myDeviceVariant: Localizable {
            Localizable(
                key: "myDeviceVariant",
                arguments: [],
                table: "Localizable",
                bundle: .current
            )
        }

        /// ### Source Localization
        ///
        /// ```
        /// I have %lld plurals
        /// ```
        package static func myPlural(_ arg1: Int) -> Localizable {
            Localizable(
                key: "myPlural",
                arguments: [
                    .int(arg1)
                ],
                table: "Localizable",
                bundle: .current
            )
        }

        /// ### Source Localization
        ///
        /// ```
        /// %lld: People liked %lld posts
        /// ```
        package static func mySubstitute(_ arg1: Int, count arg2: Int) -> Localizable {
            Localizable(
                key: "mySubstitute",
                arguments: [
                    .int(arg1),
                    .int(arg2)
                ],
                table: "Localizable",
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

    package init(localizable: Localizable, locale: Locale? = nil) {
        let bundle: Bundle = .from(description: localizable.bundle) ?? .main
        let key = String(describing: localizable.key)
        self.init(
            format: bundle.localizedString(forKey: key, value: nil, table: localizable.table),
            locale: locale,
            arguments: localizable.arguments.map(\.value)
        )
    }
}

extension Bundle {
    static func from(description: String.Localizable.BundleDescription) -> Bundle? {
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
    static func from(description: String.Localizable.BundleDescription) -> Self {
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
    /// Constant values for the Localizable Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(localized: .localizable.key)
    /// value // "Default Value"
    ///
    /// // Working with SwiftUI
    /// Text(.localizable.key)
    /// ```
    ///
    /// - Note: Using ``LocalizedStringResource.Localizable`` requires iOS 16/macOS 13 or later. See ``String.Localizable`` for a backwards compatible API.
    package struct Localizable {
        /// This is a comment
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Default Value
        /// ```
        package var key: LocalizedStringResource {
            LocalizedStringResource(localizable: .key)
        }

        /// ### Source Localization
        ///
        /// ```
        /// Multiplatform Original
        /// ```
        package var myDeviceVariant: LocalizedStringResource {
            LocalizedStringResource(localizable: .myDeviceVariant)
        }

        /// ### Source Localization
        ///
        /// ```
        /// I have %lld plurals
        /// ```
        package func myPlural(_ arg1: Int) -> LocalizedStringResource {
            LocalizedStringResource(localizable: .myPlural(arg1))
        }

        /// ### Source Localization
        ///
        /// ```
        /// %lld: People liked %lld posts
        /// ```
        package func mySubstitute(_ arg1: Int, count arg2: Int) -> LocalizedStringResource {
            LocalizedStringResource(localizable: .mySubstitute(arg1, count: arg2))
        }
    }

    package static let localizable = Localizable()

    package init(localizable: String.Localizable) {
        self.init(
            localizable.key,
            defaultValue: localizable.defaultValue,
            table: localizable.table,
            bundle: .from(description: localizable.bundle)
        )
    }

    package static func localizable(_ localizable: String.Localizable) -> LocalizedStringResource {
        LocalizedStringResource(localizable: localizable)
    }
}

#if canImport (SwiftUI)
import SwiftUI

@available(macOS 10.5, iOS 13, tvOS 13, watchOS 6, *)
extension Text {
    init(localizable: String.Localizable) {
        if #available (macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
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
        key.overrideKeyForLookup(using: localizable.key)

        self.init(key, tableName: localizable.table, bundle: .from(description: localizable.bundle))
    }
}

@available(macOS 10.5, iOS 13, tvOS 13, watchOS 6, *)
extension LocalizedStringKey {
    package init(localizable: String.Localizable) {
        let text = Text(localizable: localizable)

        var stringInterpolation = LocalizedStringKey.StringInterpolation(literalCapacity: 0, interpolationCount: 1)
        stringInterpolation.appendInterpolation(text)

        let makeKey = LocalizedStringKey.init(stringInterpolation:)
        self = makeKey(stringInterpolation)
    }

    package static func localizable(_ localizable: String.Localizable) -> LocalizedStringKey {
        LocalizedStringKey(localizable: localizable)
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
