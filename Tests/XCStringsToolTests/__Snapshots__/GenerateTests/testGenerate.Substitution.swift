import Foundation

#if SWIFT_PACKAGE
private let bundleDescription: LocalizedStringResource.BundleDescription = .atURL(Bundle.module.bundleURL)
#else
private class BundleLocator {
}
private let bundleDescription: LocalizedStringResource.BundleDescription = .forClass(BundleLocator.self)
#endif

extension LocalizedStringResource {
    /// Constant values for the Substitution Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(localized: .substitution.foo)
    /// value // "bar"
    ///
    /// // Working with SwiftUI
    /// Text(.substitution.foo)
    /// ```
    internal struct Substitution {

        /// A string that uses substitutions as well as arguments
        internal func substitutions_exampleString(_ arg1: String, totalStrings arg2: Int, remainingStrings arg3: Int) -> LocalizedStringResource {
            LocalizedStringResource(
                "substitutions_example.string",
                defaultValue: ###"\###(arg1)! There are \###(arg2) strings and you have \###(arg3) remaining"###,
                table: "Substitution",
                bundle: bundleDescription
            )
        }
    }

    /// Constant values for the Substitution Strings Catalog
    ///
    /// ```swift
    /// // Accessing the localized value directly
    /// let value = String(localized: .substitution.foo)
    /// value // "bar"
    ///
    /// // Working with SwiftUI
    /// Text(.substitution.foo)
    /// ```
    internal static let substitution = Substitution()
}