import Foundation

@available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
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
                bundle: .current
            )
        }

        internal func stringPlural(_ arg1: Int) -> LocalizedStringResource {
            LocalizedStringResource(
                "String.Plural",
                defaultValue: ###"I have \###(arg1) strings"###,
                table: "Variations",
                bundle: .current
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