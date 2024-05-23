import Foundation

extension String {
    /// Constant values for the Localizable Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(localizable: .key)
    /// value // "Default Value"
    /// ```
    internal struct Localizable {
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
        internal static var key: Localizable {
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
        internal static var myDeviceVariant: Localizable {
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
        internal static func myPlural(_ arg1: Int) -> Localizable {
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
        internal static func mySubstitute(_ arg1: Int, count arg2: Int) -> Localizable {
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

    internal init(localizable: Localizable, locale: Locale? = nil) {
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
    internal struct Localizable {
        /// This is a comment
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Default Value
        /// ```
        internal var key: LocalizedStringResource {
            LocalizedStringResource(localizable: .key)
        }

        /// ### Source Localization
        ///
        /// ```
        /// Multiplatform Original
        /// ```
        internal var myDeviceVariant: LocalizedStringResource {
            LocalizedStringResource(localizable: .myDeviceVariant)
        }

        /// ### Source Localization
        ///
        /// ```
        /// I have %lld plurals
        /// ```
        internal func myPlural(_ arg1: Int) -> LocalizedStringResource {
            LocalizedStringResource(localizable: .myPlural(arg1))
        }

        /// ### Source Localization
        ///
        /// ```
        /// %lld: People liked %lld posts
        /// ```
        internal func mySubstitute(_ arg1: Int, count arg2: Int) -> LocalizedStringResource {
            LocalizedStringResource(localizable: .mySubstitute(arg1, count: arg2))
        }
    }

    private init(localizable: String.Localizable) {
        self.init(
            localizable.key,
            defaultValue: localizable.defaultValue,
            table: localizable.table,
            bundle: .from(description: localizable.bundle)
        )
    }

    internal static let localizable = Localizable()
}