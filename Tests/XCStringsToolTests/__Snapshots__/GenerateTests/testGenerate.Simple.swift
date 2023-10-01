import Foundation

#if SWIFT_PACKAGE
private let bundleDescription: LocalizedStringResource.BundleDescription = .atURL(Bundle.module.bundleURL)
#else
private class BundleLocator {
}
private let bundleDescription: LocalizedStringResource.BundleDescription = .forClass(BundleLocator.self)
#endif

extension LocalizedStringResource {
    /// Constant values for the Simple Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(localized: .simple.simpleKey)
    /// value // "My Value"
    ///
    /// // Working with SwiftUI
    /// Text(.simple.simpleKey)
    /// ```
    internal struct Simple {

        /// This is a simple key and value
        internal var simpleKey: LocalizedStringResource {
            LocalizedStringResource(
                "SimpleKey",
                defaultValue: ###"My Value"###,
                table: "Simple",
                bundle: bundleDescription
            )
        }
    }

    /// Constant values for the Simple Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(localized: .simple.simpleKey)
    /// value // "My Value"
    ///
    /// // Working with SwiftUI
    /// Text(.simple.simpleKey)
    /// ```
    internal static let simple = Simple()
}