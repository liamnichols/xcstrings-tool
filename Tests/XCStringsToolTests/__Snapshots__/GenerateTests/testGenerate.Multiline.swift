import Foundation

@available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
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
                bundle: .current
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