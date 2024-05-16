import Foundation

extension String {
    /// Constant values for the Substitution Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(substitution: .foo)
    /// value // "bar"
    /// ```
    internal struct Substitution {
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

    internal init(substitution: Substitution, locale: Locale? = nil) {
        self.init(
            format: NSLocalizedString(
                String(describing: substitution.key),
                tableName: substitution.table,
                bundle: .from(description: substitution.bundle) ?? .main,
                comment: ""
            ),
            locale: locale,
            arguments: substitution.arguments.map(\.value)
        )
    }
}

extension String.Substitution {
    /// A string that uses substitutions as well as arguments
    ///
    /// ### Source Localization
    ///
    /// ```
    /// %@! There are %lld strings and you have %lld remaining
    /// ```
    internal static func substitutions_exampleString(_ arg1: String, totalStrings arg2: Int, remainingStrings arg3: Int) -> Self {
        Self (
            key: "substitutions_example.string",
            arguments: [
                .object(arg1),
                .int(arg2),
                .int(arg3)
            ],
            table: "Substitution",
            locale: .current,
            bundle: .current
        )
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
private extension String.Substitution {
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

private extension String.Substitution.Argument {
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

private extension String.Substitution.BundleDescription {
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

private extension Bundle {
    static func from(description: String.Substitution.BundleDescription) -> Bundle? {
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
    static func from(description: String.Substitution.BundleDescription) -> Self {
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
    /// Constant values for the Substitution Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(localized: .substitution.foo)
    /// value // "bar"
    ///
    /// // Working with SwiftUI
    /// Text(.substitution.foo)
    /// ```
    ///
    /// - Note: Using ``LocalizedStringResource.Substitution`` requires iOS 16/macOS 13 or later. See ``String.Substitution`` for an iOS 15/macOS 12 compatible API.
    internal struct Substitution {
        /// A string that uses substitutions as well as arguments
        ///
        /// ### Source Localization
        ///
        /// ```
        /// %@! There are %lld strings and you have %lld remaining
        /// ```
        internal func substitutions_exampleString(_ arg1: String, totalStrings arg2: Int, remainingStrings arg3: Int) -> LocalizedStringResource {
            LocalizedStringResource(substitution: .substitutions_exampleString(arg1, totalStrings: arg2, remainingStrings: arg3))
        }
    }

    private init(substitution: String.Substitution) {
        self.init(
            substitution.key,
            defaultValue: substitution.defaultValue,
            table: substitution.table,
            locale: substitution.locale,
            bundle: .from(description: substitution.bundle)
        )
    }

    internal static let substitution = Substitution()
}