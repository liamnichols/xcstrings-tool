import SwiftSyntax
import SwiftSyntaxBuilder

struct LocalizedStringKeyOverrideKeySnippet: Snippet {
    var syntax: some DeclSyntaxProtocol {
        DeclSyntax("""
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
