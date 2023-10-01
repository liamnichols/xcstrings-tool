import Foundation

#if SWIFT_PACKAGE
private let bundleDescription: LocalizedStringResource.BundleDescription = .atURL(Bundle.module.bundleURL)
#else
private class BundleLocator {
}
private let bundleDescription: LocalizedStringResource.BundleDescription = .forClass(BundleLocator.self)
#endif

extension LocalizedStringResource {
    /// Constant values for the Variations Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(localized: .variations.stringDevice)
    /// value // "Tap to open"
    ///
    /// // Working with SwiftUI
    /// Text(.variations.stringDevice)
    /// ```
    internal struct Variations {

        /// A string that should have a macOS variation to replace 'Tap' with 'Click'
        internal var stringDevice: LocalizedStringResource {
            LocalizedStringResource(
                "String.Device",
                defaultValue: ###"Tap to open"###,
                table: "Variations",
                bundle: bundleDescription
            )
        }

        internal func stringPlural(_ arg1: Int) -> LocalizedStringResource {
            LocalizedStringResource(
                "String.Plural",
                defaultValue: ###"I have \###(arg1) strings"###,
                table: "Variations",
                bundle: bundleDescription
            )
        }
    }

    /// Constant values for the Variations Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(localized: .variations.stringDevice)
    /// value // "Tap to open"
    ///
    /// // Working with SwiftUI
    /// Text(.variations.stringDevice)
    /// ```
    internal static let variations = Variations()
}