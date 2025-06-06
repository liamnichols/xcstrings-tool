import SwiftSyntax
import SwiftSyntaxBuilder

/// Generates a complex import declaration that supports explicit access levels (SE0409) if opted-in
struct ComplexImportSnippet {
    let module: TokenSyntax.Module
    let sourceFile: SourceFile
}

extension ComplexImportSnippet: Snippet {
    var syntax: some DeclSyntaxProtocol {
        DeclSyntax(_syntax)
    }

    var _syntax: DeclSyntaxProtocol {
        if sourceFile.importsUseExplicitAccessLevel {
            IfSupportsSE0409Snippet {
                ImportSnippet(module: module, accessLevel: sourceFile.accessLevel)
            } elseItems: {
                ImportSnippet(module: module)
            }.syntax
        } else {
            ImportSnippet(module: module).syntax
        }
    }
}
