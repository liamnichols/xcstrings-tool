import Foundation

extension String {
    /// A type that represents localized strings from the ‘Substitution‘
    /// strings table.
    ///
    /// Do not initialize instances of this type yourself, instead use one of the static
    /// methods or properties that have been generated automatically.
    ///
    /// ## Usage
    ///
    /// ### Foundation
    ///
    /// In Foundation, you can resolve the localized string using the system language
    /// with the `String`.``Swift/String/init(substitution:locale:)``
    /// intializer:
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(substitution: .foo)
    /// value // "bar"
    /// ```
    ///
    /// Starting in iOS 16/macOS 13/tvOS 16/watchOS 9, `LocalizedStringResource` can also
    /// be used:
    ///
    /// ```swift
    /// var resource = LocalizedStringResource(substitution: .foo)
    /// resource.locale = Locale(identifier: "fr") // customise language
    /// let value = String(localized: resource)    // defer lookup
    /// ```
    ///
    /// ### SwiftUI
    ///
    /// In SwiftUI, it is recommended to use `Text`.``SwiftUI/Text/init(substitution:)``
    /// or `LocalizedStringKey`.``SwiftUI/LocalizedStringKey/substitution(_:)``
    /// in order for localized values to be resolved within the SwiftUI environment:
    ///
    /// ```swift
    /// var body: some View {
    ///     List {
    ///         Text(substitution: .listContent)
    ///     }
    ///     .navigationTitle(.substitution(.navigationTitle))
    ///     .environment(\.locale, Locale(identifier: "fr"))
    /// }
    /// ```
    ///
    /// - SeeAlso: [XCStrings Tool Documentation - Using the generated source code](https://swiftpackageindex.com/liamnichols/xcstrings-tool/0.5.2/documentation/documentation/using-the-generated-source-code)
    internal struct Substitution: Sendable {
        enum BundleDescription: Sendable {
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

        enum Argument: Sendable {
            case int(Int)
            case uint(UInt)
            case float(Float)
            case double(Double)
            case object(String)

            var value: any CVarArg {
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

        /// A string that uses substitutions as well as arguments
        ///
        /// ### Source Localization
        ///
        /// ```
        /// %@! There are %lld strings and you have %lld remaining
        /// ```
        internal static func substitutions_exampleString(_ arg1: String, totalStrings arg2: Int, remainingStrings arg3: Int) -> Substitution {
            Substitution(
                key: "substitutions_example.string",
                arguments: [
                    .object(arg1),
                    .int(arg2),
                    .int(arg3)
                ],
                table: "Substitution",
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

    internal init(substitution: Substitution, locale: Locale? = nil) {
        let bundle: Bundle = .from(description: substitution.bundle) ?? .main
        let key = String(describing: substitution.key)
        self.init(
            format: bundle.localizedString(forKey: key, value: nil, table: substitution.table),
            locale: locale,
            arguments: substitution.arguments.map(\.value)
        )
    }
}

extension Bundle {
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
    /// - Note: Using ``LocalizedStringResource.Substitution`` requires iOS 16/macOS 13 or later. See ``String.Substitution`` for a backwards compatible API.
    internal struct Substitution: Sendable {
        /// A string that uses substitutions as well as arguments
        ///
        /// ### Source Localization
        ///
        /// ```
        /// %@! There are %lld strings and you have %lld remaining
        /// ```
        @available(*, deprecated, message: "Use `String.Substitution.substitutions_exampleString(_:totalStrings:remainingStrings:)` instead. This method will be removed in the future.")
        internal func substitutions_exampleString(_ arg1: String, totalStrings arg2: Int, remainingStrings arg3: Int) -> LocalizedStringResource {
            LocalizedStringResource(substitution: .substitutions_exampleString(arg1, totalStrings: arg2, remainingStrings: arg3))
        }
    }

    @available(*, deprecated, message: "Use the `substitution(_:)` static method instead. This property will be removed in the future.") internal static let substitution = Substitution()

    internal init(substitution: String.Substitution) {
        self.init(
            substitution.key,
            defaultValue: substitution.defaultValue,
            table: substitution.table,
            bundle: .from(description: substitution.bundle)
        )
    }

    /// Creates a `LocalizedStringResource` that represents a localized value in the ‘Substitution‘ strings table.
    internal static func substitution(_ substitution: String.Substitution) -> LocalizedStringResource {
        LocalizedStringResource(substitution: substitution)
    }
}

#if canImport(SwiftUI)
import SwiftUI

@available(macOS 10.5, iOS 13, tvOS 13, watchOS 6, *)
extension Text {
    /// Creates a text view that displays a localized string defined in the ‘Substitution‘ strings table.
    internal init(substitution: String.Substitution) {
        if #available(macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
            self.init(LocalizedStringResource(substitution: substitution))
            return
        }

        var stringInterpolation = LocalizedStringKey.StringInterpolation(literalCapacity: 0, interpolationCount: substitution.arguments.count)
        for argument in substitution.arguments {
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
        key.overrideKeyForLookup(using: substitution.key)

        self.init(key, tableName: substitution.table, bundle: .from(description: substitution.bundle))
    }
}

@available(macOS 10.5, iOS 13, tvOS 13, watchOS 6, *)
extension LocalizedStringKey {
    /// Creates a localized string key that represents a localized value in the ‘Substitution‘ strings table.
    @available(macOS 11, iOS 14, tvOS 14, watchOS 7, *)
    internal init(substitution: String.Substitution) {
        var stringInterpolation = LocalizedStringKey.StringInterpolation(literalCapacity: 0, interpolationCount: 1)

        if #available(macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
            stringInterpolation.appendInterpolation(LocalizedStringResource(substitution: substitution))
        } else {
            stringInterpolation.appendInterpolation(Text(substitution: substitution))
        }

        let makeKey = LocalizedStringKey.init(stringInterpolation:)
        self = makeKey(stringInterpolation)
    }

    /// Creates a `LocalizedStringKey` that represents a localized value in the ‘Substitution‘ strings table.
    @available(macOS 11, iOS 14, tvOS 14, watchOS 7, *)
    internal static func substitution(_ substitution: String.Substitution) -> LocalizedStringKey {
        LocalizedStringKey(substitution: substitution)
    }

    /// Updates the underlying `key` used when performing localization lookups.
    ///
    /// By default, an instance of `LocalizedStringKey` can only be created
    /// using string interpolation, so if arguments are included, the format
    /// specifiers make up part of the key.
    ///
    /// This method allows you to change the key after initialization in order
    /// to match the value that might be defined in the strings table.
    fileprivate mutating func overrideKeyForLookup(using key: StaticString) {
        withUnsafeMutablePointer(to: &self) { pointer in
            let raw = UnsafeMutableRawPointer(pointer)
            let bound = raw.assumingMemoryBound(to: String.self)
            bound.pointee = String(describing: key)
        }
    }
}
#endif
