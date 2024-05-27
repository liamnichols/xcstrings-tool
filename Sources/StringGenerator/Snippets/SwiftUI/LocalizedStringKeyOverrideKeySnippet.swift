import SwiftSyntax
import SwiftSyntaxBuilder

struct LocalizedStringKeyOverrideKeySnippet: Snippet {
    var syntax: some DeclSyntaxProtocol {
        DeclSyntax("""
        /// Updates the underlying `key` used when performing localization lookups.
        ///
        /// By default, an instance of `LocalizedStringKey` can only be created
        /// using string interpolation, so if arguments are included, the format
        /// specifiers make up part of the key.
        ///
        /// This method allows you to change the key after initialization in order
        /// to match the value that might be defined in the strings table.
        fileprivate mutating func overrideKeyForLookup(using key: StaticString) {
            withUnsafeMutablePointer(to: &self) { pointer in
                let raw = UnsafeMutableRawPointer(pointer)
                let bound = raw.assumingMemoryBound(to: String.self)
                bound.pointee = String(describing: key)
            }
        }
        """)
    }
}
