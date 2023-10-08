import Foundation

@available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
extension LocalizedStringResource {
    /// Constant values for the Positional Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(localized: .positional.foo)
    /// value // "bar"
    ///
    /// // Working with SwiftUI
    /// Text(.positional.foo)
    /// ```
    internal struct Positional {

        /// A string where the second argument is at the front of the string and the first argument is at the end
        internal func reorder(_ arg1: Int, _ arg2: String) -> LocalizedStringResource {
            LocalizedStringResource(
                "reorder",
                defaultValue: ###"Second: \###(arg2) - First: \###(arg1)"###,
                table: "Positional",
                bundle: .current
            )
        }

        /// A string that uses the same argument twice
        internal func repeatExplicit(_ arg1: Int) -> LocalizedStringResource {
            LocalizedStringResource(
                "repeatExplicit",
                defaultValue: ###"\###(arg1), I repeat: \###(arg1)"###,
                table: "Positional",
                bundle: .current
            )
        }

        /// A string that uses the same argument twice implicitly because a positional specifier wasn't provided in one instance
        internal func repeatImplicit(_ arg1: String) -> LocalizedStringResource {
            LocalizedStringResource(
                "repeatImplicit",
                defaultValue: ###"\###(arg1), are you there? \###(arg1)?"###,
                table: "Positional",
                bundle: .current
            )
        }
    }

    /// Constant values for the Positional Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(localized: .positional.foo)
    /// value // "bar"
    ///
    /// // Working with SwiftUI
    /// Text(.positional.foo)
    /// ```
    internal static let positional = Positional()
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