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
    package init(localizable: Localizable, locale: Locale? = nil) {
        self.init(
            localized: localizable.key,
            defaultValue: localizable.defaultValue,
            table: localizable.table,
            bundle: .from(description: localizable.bundle),
            locale: locale ?? localizable.locale
        )
    }
}

extension String.Localizable {
    /// This is a comment
    package static var key: Self {
        Self (
            key: "Key",
            arguments: [],
            table: "Localizable",
            locale: .current,
            bundle: .current
        )
    }

    package static var myDeviceVariant: Self {
        Self (
            key: "myDeviceVariant",
            arguments: [],
            table: "Localizable",
            locale: .current,
            bundle: .current
        )
    }

    package static func myPlural(_ arg1: Int) -> Self {
        Self (
            key: "myPlural",
            arguments: [
                .int(arg1)
            ],
            table: "Localizable",
            locale: .current,
            bundle: .current
        )
    }

    package static func mySubstitute(_ arg1: Int, count arg2: Int) -> Self {
        Self (
            key: "mySubstitute",
            arguments: [
                .int(arg1),
                .int(arg2)
            ],
            table: "Localizable",
            locale: .current,
            bundle: .current
        )
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension String.Localizable {
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

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
private extension String.Localizable.BundleDescription {
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
    /// - Note: Using ``LocalizedStringResource.Localizable`` requires iOS 16/macOS 13 or later. See ``String.Localizable`` for an iOS 15/macOS 12 compatible API.
    package struct Localizable {
        /// This is a comment
        package var key: LocalizedStringResource {
            LocalizedStringResource(localizable: .key)
        }

        package var myDeviceVariant: LocalizedStringResource {
            LocalizedStringResource(localizable: .myDeviceVariant)
        }

        package func myPlural(_ arg1: Int) -> LocalizedStringResource {
            LocalizedStringResource(localizable: .myPlural(arg1))
        }

        package func mySubstitute(_ arg1: Int, count arg2: Int) -> LocalizedStringResource {
            LocalizedStringResource(localizable: .mySubstitute(arg1, count: arg2))
        }
    }

    private init(localizable: String.Localizable) {
        self.init(
            localizable.key,
            defaultValue: localizable.defaultValue,
            table: localizable.table,
            locale: localizable.locale,
            bundle: .from(description: localizable.bundle)
        )
    }

    package static let localizable = Localizable()
}