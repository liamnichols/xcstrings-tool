import SwiftSyntax
import SwiftSyntaxBuilder

struct IfCanImportSnippet {
    let module: TokenSyntax.Module
    let items: CodeBlockItemListSyntax
}

extension IfCanImportSnippet {
    init(
        module: TokenSyntax.Module,
        @CodeBlockItemListBuilder itemsBuilder: () -> CodeBlockItemListSyntax
    ) {
        self.init(module: module, items: itemsBuilder())
    }
}

extension IfCanImportSnippet: Snippet {
    var syntax: some DeclSyntaxProtocol {
        IfConfigDeclSyntax(
            clauses: IfConfigClauseListSyntax {
                IfConfigClauseSyntax(
                    poundKeyword: .poundIfToken(),
                    condition: condition,
                    elements: .statements(items)
                )
            }
        )
    }

    var condition: some ExprSyntaxProtocol {
        FunctionCallExprSyntax(callee: DeclReferenceExprSyntax(baseName: "canImport")) {
            LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: .module(.SwiftUI)))
        }
    }
}
