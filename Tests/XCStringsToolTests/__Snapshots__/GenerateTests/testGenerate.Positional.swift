import Foundation

extension String {
    /// Constant values for the Positional Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(positional: .foo)
    /// value // "bar"
    /// ```
    internal struct Positional {
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

        /// A string where the second argument is at the front of the string and the first argument is at the end
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Second: %2$@ - First: %1$lld
        /// ```
        internal static func reorder(_ arg1: Int, _ arg2: String) -> Positional {
            Positional(
                key: "reorder",
                arguments: [
                    .int(arg1),
                    .object(arg2)
                ],
                table: "Positional",
                bundle: .current
            )
        }

        /// A string that uses the same argument twice
        ///
        /// ### Source Localization
        ///
        /// ```
        /// %1$lld, I repeat: %1$lld
        /// ```
        internal static func repeatExplicit(_ arg1: Int) -> Positional {
            Positional(
                key: "repeatExplicit",
                arguments: [
                    .int(arg1)
                ],
                table: "Positional",
                bundle: .current
            )
        }

        /// A string that uses the same argument twice implicitly because a positional specifier wasn't provided in one instance
        ///
        /// ### Source Localization
        ///
        /// ```
        /// %@, are you there? %1$@?
        /// ```
        internal static func repeatImplicit(_ arg1: String) -> Positional {
            Positional(
                key: "repeatImplicit",
                arguments: [
                    .object(arg1)
                ],
                table: "Positional",
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

    internal init(positional: Positional, locale: Locale? = nil) {
        let bundle: Bundle = .from(description: positional.bundle) ?? .main
        let key = String(describing: positional.key)
        self.init(
            format: bundle.localizedString(forKey: key, value: nil, table: positional.table),
            locale: locale,
            arguments: positional.arguments.map(\.value)
        )
    }
}

extension Bundle {
    static func from(description: String.Positional.BundleDescription) -> Bundle? {
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
    static func from(description: String.Positional.BundleDescription) -> Self {
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
    /// Constant values for the Positional Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(localized: .positional.foo)
    /// value // "bar"
    ///
    /// // Working with SwiftUI
    /// Text(.positional.foo)
    /// ```
    ///
    /// - Note: Using ``LocalizedStringResource.Positional`` requires iOS 16/macOS 13 or later. See ``String.Positional`` for a backwards compatible API.
    internal struct Positional {
        /// A string where the second argument is at the front of the string and the first argument is at the end
        ///
        /// ### Source Localization
        ///
        /// ```
        /// Second: %2$@ - First: %1$lld
        /// ```
        internal func reorder(_ arg1: Int, _ arg2: String) -> LocalizedStringResource {
            LocalizedStringResource(positional: .reorder(arg1, arg2))
        }

        /// A string that uses the same argument twice
        ///
        /// ### Source Localization
        ///
        /// ```
        /// %1$lld, I repeat: %1$lld
        /// ```
        internal func repeatExplicit(_ arg1: Int) -> LocalizedStringResource {
            LocalizedStringResource(positional: .repeatExplicit(arg1))
        }

        /// A string that uses the same argument twice implicitly because a positional specifier wasn't provided in one instance
        ///
        /// ### Source Localization
        ///
        /// ```
        /// %@, are you there? %1$@?
        /// ```
        internal func repeatImplicit(_ arg1: String) -> LocalizedStringResource {
            LocalizedStringResource(positional: .repeatImplicit(arg1))
        }
    }

    private init(positional: String.Positional) {
        self.init(
            positional.key,
            defaultValue: positional.defaultValue,
            table: positional.table,
            bundle: .from(description: positional.bundle)
        )
    }

    internal static let positional = Positional()
}
