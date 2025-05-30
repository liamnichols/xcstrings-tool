import SwiftSyntax
import SwiftSyntaxBuilder

/// Generates a simple import declaration
///
/// ```swift
/// import SomeModule
/// ```
struct ImportSnippet {
    var module: TokenSyntax.Module
    var accessLevel: AccessLevel?
}

extension ImportSnippet: Snippet {
    var syntax: some DeclSyntaxProtocol {
        ImportDeclSyntax(
            modifiers: modifiers,
            path: ImportPathComponentListSyntax {
                ImportPathComponentSyntax(name: .module(module))
            }
        )
    }

    @DeclModifierListBuilder
    private var modifiers: DeclModifierListSyntax {
        if let accessLevel {
            DeclModifierSyntax(name: accessLevel.token)
        }
    }
}
