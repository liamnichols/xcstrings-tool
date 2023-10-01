import Foundation

@available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
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
                bundle: .current
            )
        }

        /// %c should convert to a CChar argument
        internal func c(_ arg1: CChar) -> LocalizedStringResource {
            LocalizedStringResource(
                "c",
                defaultValue: ###"Test \###(arg1)"###,
                table: "FormatSpecifiers",
                bundle: .current
            )
        }

        /// %d should convert to an Int argument
        internal func d(_ arg1: Int) -> LocalizedStringResource {
            LocalizedStringResource(
                "d",
                defaultValue: ###"Test \###(arg1)"###,
                table: "FormatSpecifiers",
                bundle: .current
            )
        }

        /// %lld should covert to an Int
        internal func d_length(_ arg1: Int) -> LocalizedStringResource {
            LocalizedStringResource(
                "d_length",
                defaultValue: ###"Test \###(arg1)"###,
                table: "FormatSpecifiers",
                bundle: .current
            )
        }

        /// %f should convert to a Double argument
        internal func f(_ arg1: Double) -> LocalizedStringResource {
            LocalizedStringResource(
                "f",
                defaultValue: ###"Test \###(arg1)"###,
                table: "FormatSpecifiers",
                bundle: .current
            )
        }

        /// %.2f should convert to a Double argument
        internal func f_precision(_ arg1: Double) -> LocalizedStringResource {
            LocalizedStringResource(
                "f_precision",
                defaultValue: ###"Test \###(arg1)"###,
                table: "FormatSpecifiers",
                bundle: .current
            )
        }

        /// %i should convert to an Int argument
        internal func i(_ arg1: Int) -> LocalizedStringResource {
            LocalizedStringResource(
                "i",
                defaultValue: ###"Test \###(arg1)"###,
                table: "FormatSpecifiers",
                bundle: .current
            )
        }

        /// %p should convert to an UnsafeRawPointer argument
        internal func p(_ arg1: UnsafeRawPointer) -> LocalizedStringResource {
            LocalizedStringResource(
                "p",
                defaultValue: ###"Test \###(arg1)"###,
                table: "FormatSpecifiers",
                bundle: .current
            )
        }

        /// %s should convert to an UnsafePointer<CChar> argument
        internal func s(_ arg1: UnsafePointer<CChar>) -> LocalizedStringResource {
            LocalizedStringResource(
                "s",
                defaultValue: ###"Test \###(arg1)"###,
                table: "FormatSpecifiers",
                bundle: .current
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