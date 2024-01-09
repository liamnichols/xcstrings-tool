import Foundation

@available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
extension LocalizedStringResource {
    /// Constant values for the Legacy Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(localized: .legacy.key1)
    /// value // "This is a simple string"
    ///
    /// // Working with SwiftUI
    /// Text(.legacy.key1)
    /// ```
    internal struct Legacy {

        internal var key1: LocalizedStringResource {
            LocalizedStringResource(
                "Key1",
                defaultValue: ###"This is a simple string"###,
                table: "Legacy",
                bundle: .current
            )
        }

        internal func key2(_ arg1: Int) -> LocalizedStringResource {
            LocalizedStringResource(
                "Key2",
                defaultValue: ###"This string contains \###(arg1) integer"###,
                table: "Legacy",
                bundle: .current
            )
        }

        internal func key3(_ arg1: String, _ arg2: Int) -> LocalizedStringResource {
            LocalizedStringResource(
                "Key3",
                defaultValue: ###"Hello \###(arg1)! This string \###(arg2) arguments"###,
                table: "Legacy",
                bundle: .current
            )
        }

        internal func key4(_ arg1: String, _ arg2: String) -> LocalizedStringResource {
            LocalizedStringResource(
                "Key4",
                defaultValue: ###"Second: \###(arg2), First: \###(arg1), First: \###(arg1)"###,
                table: "Legacy",
                bundle: .current
            )
        }

        internal func key5(_ arg1: String) -> LocalizedStringResource {
            LocalizedStringResource(
                "Key5",
                defaultValue: ###"First: \###(arg1), First: \###(arg1)"###,
                table: "Legacy",
                bundle: .current
            )
        }
    }

    /// Constant values for the Legacy Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(localized: .legacy.key1)
    /// value // "This is a simple string"
    ///
    /// // Working with SwiftUI
    /// Text(.legacy.key1)
    /// ```
    internal static let legacy = Legacy()
}

@available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
private extension LocalizedStringResource.BundleDescription {
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