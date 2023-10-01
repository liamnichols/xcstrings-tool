import Foundation

#if SWIFT_PACKAGE
private let bundleDescription: LocalizedStringResource.BundleDescription = .atURL(Bundle.module.bundleURL)
#else
private class BundleLocator {
}
private let bundleDescription: LocalizedStringResource.BundleDescription = .forClass(BundleLocator.self)
#endif

extension LocalizedStringResource {
    /// Constant values for the FormatSpecifiers Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(localized: .formatSpecifiers.foo)
    /// value // "bar"
    ///
    /// // Working with SwiftUI
    /// Text(.formatSpecifiers.foo)
    /// ```
    internal struct FormatSpecifiers {

        /// %@ should convert to a String argument
        internal func at(_ arg1: String) -> LocalizedStringResource {
            LocalizedStringResource(
                "at",
                defaultValue: ###"Test \###(arg1)"###,
                table: "FormatSpecifiers",
                bundle: bundleDescription
            )
        }

        /// %c should convert to a CChar argument
        internal func c(_ arg1: CChar) -> LocalizedStringResource {
            LocalizedStringResource(
                "c",
                defaultValue: ###"Test \###(arg1)"###,
                table: "FormatSpecifiers",
                bundle: bundleDescription
            )
        }

        /// %d should convert to an Int argument
        internal func d(_ arg1: Int) -> LocalizedStringResource {
            LocalizedStringResource(
                "d",
                defaultValue: ###"Test \###(arg1)"###,
                table: "FormatSpecifiers",
                bundle: bundleDescription
            )
        }

        /// %lld should covert to an Int
        internal func d_length(_ arg1: Int) -> LocalizedStringResource {
            LocalizedStringResource(
                "d_length",
                defaultValue: ###"Test \###(arg1)"###,
                table: "FormatSpecifiers",
                bundle: bundleDescription
            )
        }

        /// %f should convert to a Double argument
        internal func f(_ arg1: Double) -> LocalizedStringResource {
            LocalizedStringResource(
                "f",
                defaultValue: ###"Test \###(arg1)"###,
                table: "FormatSpecifiers",
                bundle: bundleDescription
            )
        }

        /// %.2f should convert to a Double argument
        internal func f_precision(_ arg1: Double) -> LocalizedStringResource {
            LocalizedStringResource(
                "f_precision",
                defaultValue: ###"Test \###(arg1)"###,
                table: "FormatSpecifiers",
                bundle: bundleDescription
            )
        }

        /// %i should convert to an Int argument
        internal func i(_ arg1: Int) -> LocalizedStringResource {
            LocalizedStringResource(
                "i",
                defaultValue: ###"Test \###(arg1)"###,
                table: "FormatSpecifiers",
                bundle: bundleDescription
            )
        }

        /// %p should convert to an UnsafeRawPointer argument
        internal func p(_ arg1: UnsafeRawPointer) -> LocalizedStringResource {
            LocalizedStringResource(
                "p",
                defaultValue: ###"Test \###(arg1)"###,
                table: "FormatSpecifiers",
                bundle: bundleDescription
            )
        }

        /// %s should convert to an UnsafePointer<CChar> argument
        internal func s(_ arg1: UnsafePointer<CChar>) -> LocalizedStringResource {
            LocalizedStringResource(
                "s",
                defaultValue: ###"Test \###(arg1)"###,
                table: "FormatSpecifiers",
                bundle: bundleDescription
            )
        }
    }

    /// Constant values for the FormatSpecifiers Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(localized: .formatSpecifiers.foo)
    /// value // "bar"
    ///
    /// // Working with SwiftUI
    /// Text(.formatSpecifiers.foo)
    /// ```
    internal static let formatSpecifiers = FormatSpecifiers()
}