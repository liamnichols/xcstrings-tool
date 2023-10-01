import Foundation

#if SWIFT_PACKAGE
private let bundleDescription: LocalizedStringResource.BundleDescription = .atURL(Bundle.module.bundleURL)
#else
private class BundleLocator {
}
private let bundleDescription: LocalizedStringResource.BundleDescription = .forClass(BundleLocator.self)
#endif

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
    public struct Localizable {

        /// This is a comment
        public var key: LocalizedStringResource {
            LocalizedStringResource(
                "Key",
                defaultValue: ###"Default Value"###,
                table: "Localizable",
                bundle: bundleDescription
            )
        }

        public var myDeviceVariant: LocalizedStringResource {
            LocalizedStringResource(
                "myDeviceVariant",
                defaultValue: ###"Multiplatform Original"###,
                table: "Localizable",
                bundle: bundleDescription
            )
        }

        public func myPlural(_ arg1: Int) -> LocalizedStringResource {
            LocalizedStringResource(
                "myPlural",
                defaultValue: ###"I have \###(arg1) plurals"###,
                table: "Localizable",
                bundle: bundleDescription
            )
        }

        public func mySubstitute(_ arg1: Int, count arg2: Int) -> LocalizedStringResource {
            LocalizedStringResource(
                "mySubstitute",
                defaultValue: ###"\###(arg1): People liked \###(arg2) posts"###,
                table: "Localizable",
                bundle: bundleDescription
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
    public static let localizable = Localizable()
}