import SwiftSyntax
import SwiftSyntaxBuilder

/// Generates a simple import declaration
///
/// ```swift
/// import SomeModule
/// ```
struct ImportSnippet {
    let module: TokenSyntax.Module
}

extension ImportSnippet: Snippet {
    var syntax: some DeclSyntaxProtocol {
        ImportDeclSyntax(
            path: ImportPathComponentListSyntax {
                ImportPathComponentSyntax(name: .module(module))
            }
        )
    }
}
