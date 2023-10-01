import Foundation

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
    internal struct Localizable {

        /// This is a comment
        internal var key: LocalizedStringResource {
            LocalizedStringResource(
                "Key",
                defaultValue: ###"Default Value"###,
                table: "Localizable",
                bundle: .current
            )
        }

        internal var myDeviceVariant: LocalizedStringResource {
            LocalizedStringResource(
                "myDeviceVariant",
                defaultValue: ###"Multiplatform Original"###,
                table: "Localizable",
                bundle: .current
            )
        }

        internal func myPlural(_ arg1: Int) -> LocalizedStringResource {
            LocalizedStringResource(
                "myPlural",
                defaultValue: ###"I have \###(arg1) plurals"###,
                table: "Localizable",
                bundle: .current
            )
        }

        internal func mySubstitute(_ arg1: Int, count arg2: Int) -> LocalizedStringResource {
            LocalizedStringResource(
                "mySubstitute",
                defaultValue: ###"\###(arg1): People liked \###(arg2) posts"###,
                table: "Localizable",
                bundle: .current
            )
        }
    }

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
    internal static let localizable = Localizable()
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