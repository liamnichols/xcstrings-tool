import Foundation

#if SWIFT_PACKAGE
private let bundleDescription: LocalizedStringResource.BundleDescription = .atURL(Bundle.module.bundleURL)
#else
private class BundleLocator {
}
private let bundleDescription: LocalizedStringResource.BundleDescription = .forClass(BundleLocator.self)
#endif

extension LocalizedStringResource {
    /// Constant values for the Multiline Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(localized: .multiline.multiline)
    /// value // "Options:\n- One\n- Two\n- Three"
    ///
    /// // Working with SwiftUI
    /// Text(.multiline.multiline)
    /// ```
    internal struct Multiline {

        /// This example tests the following:
        /// 1. That line breaks in the defaultValue are supported
        /// 2. That line breaks in the comment are supported
        internal var multiline: LocalizedStringResource {
            LocalizedStringResource(
                "multiline",
                defaultValue: ###"Options:\###n- One\###n- Two\###n- Three"###,
                table: "Multiline",
                bundle: bundleDescription
            )
        }
    }

    /// Constant values for the Multiline Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(localized: .multiline.multiline)
    /// value // "Options:\n- One\n- Two\n- Three"
    ///
    /// // Working with SwiftUI
    /// Text(.multiline.multiline)
    /// ```
    internal static let multiline = Multiline()
}