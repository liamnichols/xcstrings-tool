import Foundation

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension String {
    internal struct Positional {
        fileprivate enum BundleDescription {
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

    internal init(positional: Positional) {
        self.init(
            localized: positional.key,
            defaultValue: positional.defaultValue,
            table: positional.table,
            bundle: .from(description: positional.bundle),
            locale: positional.locale
        )
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension String.Positional {
    /// A string where the second argument is at the front of the string and the first argument is at the end
    internal static func reorder(_ arg1: Int, _ arg2: String) -> Self {
        Self (
            key: "reorder",
            defaultValue: ###"Second: \###(arg2) - First: \###(arg1)"###,
            table: "Positional",
            locale: .current,
            bundle: .current
        )
    }

    /// A string that uses the same argument twice
    internal static func repeatExplicit(_ arg1: Int) -> Self {
        Self (
            key: "repeatExplicit",
            defaultValue: ###"\###(arg1), I repeat: \###(arg1)"###,
            table: "Positional",
            locale: .current,
            bundle: .current
        )
    }

    /// A string that uses the same argument twice implicitly because a positional specifier wasn't provided in one instance
    internal static func repeatImplicit(_ arg1: String) -> Self {
        Self (
            key: "repeatImplicit",
            defaultValue: ###"\###(arg1), are you there? \###(arg1)?"###,
            table: "Positional",
            locale: .current,
            bundle: .current
        )
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
private extension String.Positional.BundleDescription {
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
    internal struct Positional {
        /// A string where the second argument is at the front of the string and the first argument is at the end
        internal func reorder(_ arg1: Int, _ arg2: String) -> LocalizedStringResource {
            LocalizedStringResource(positional: .reorder(arg1, arg2))
        }

        /// A string that uses the same argument twice
        internal func repeatExplicit(_ arg1: Int) -> LocalizedStringResource {
            LocalizedStringResource(positional: .repeatExplicit(arg1))
        }

        /// A string that uses the same argument twice implicitly because a positional specifier wasn't provided in one instance
        internal func repeatImplicit(_ arg1: String) -> LocalizedStringResource {
            LocalizedStringResource(positional: .repeatImplicit(arg1))
        }
    }

    private init(positional: String.Positional) {
        self.init(
            positional.key,
            defaultValue: positional.defaultValue,
            table: positional.table,
            locale: positional.locale,
            bundle: .from(description: positional.bundle)
        )
    }

    internal static let positional = Positional()
}