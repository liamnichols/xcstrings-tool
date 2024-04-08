import Foundation

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension String {
    internal struct Variations {
        internal enum BundleDescription {
            case main
            case atURL(URL)
            case forClass(AnyClass)
        }

        fileprivate let key: StaticString
        fileprivate let defaultValue: LocalizationValue
        fileprivate let table: String?
        fileprivate let locale: Locale
        fileprivate let bundle: BundleDescription

        fileprivate init(
            key: StaticString,
            defaultValue: LocalizationValue,
            table: String?,
            locale: Locale,
            bundle: BundleDescription
        ) {
            self.key = key
            self.defaultValue = defaultValue
            self.table = table
            self.locale = locale
            self.bundle = bundle
        }
    }

    internal init(variations: Variations) {
        self.init(
            localized: variations.key,
            defaultValue: variations.defaultValue,
            table: variations.table,
            bundle: .from(description: variations.bundle),
            locale: variations.locale
        )
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension String.Variations {
    /// A string that should have a macOS variation to replace 'Tap' with 'Click'
    internal static var stringDevice: Self {
        Self (
            key: "String.Device",
            defaultValue: ###"Tap to open"###,
            table: "Variations",
            locale: .current,
            bundle: .current
        )
    }

    internal static func stringPlural(_ arg1: Int) -> Self {
        Self (
            key: "String.Plural",
            defaultValue: ###"I have \###(arg1) strings"###,
            table: "Variations",
            locale: .current,
            bundle: .current
        )
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