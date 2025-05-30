import SwiftSyntax
import SwiftSyntaxBuilder

struct IfSupportsSE0409Snippet {
    let items: CodeBlockItemListSyntax
    let elseItems: CodeBlockItemListSyntax
}

extension IfSupportsSE0409Snippet {
    init(
        @CodeBlockItemListBuilder items: () -> CodeBlockItemListSyntax,
        @CodeBlockItemListBuilder elseItems: () -> CodeBlockItemListSyntax
    ) {
        self.init(items: items(), elseItems: elseItems())
    }
}

extension IfSupportsSE0409Snippet: Snippet {
    var syntax: some DeclSyntaxProtocol {
        IfConfigDeclSyntax(
            clauses: IfConfigClauseListSyntax {
                IfConfigClauseSyntax(
                    poundKeyword: .poundIfToken(),
                    condition: condition,
                    elements: .statements(items)
                )
                IfConfigClauseSyntax(
                    poundKeyword: .poundElseToken(),
                    elements: .statements(elseItems)
                )
            }
        )
    }

    var condition: some ExprSyntaxProtocol {
        InfixOperatorExprSyntax(
            leftOperand: FunctionCallExprSyntax(callee: DeclReferenceExprSyntax(baseName: "hasFeature")) {
                LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: "AccessLevelOnImport"))
            },
            operator: BinaryOperatorExprSyntax(text: "||"),
            rightOperand: FunctionCallExprSyntax(callee: DeclReferenceExprSyntax(baseName: "compiler")) {
                LabeledExprSyntax(
                    // FIXME: Bug in SwiftSyntax formatting will put a space between operator and expression
//                    expression: PrefixOperatorExprSyntax(
//                        operator: ">=",
//                        expression: FloatLiteralExprSyntax(6)
//                    )
                    expression: PrefixOperatorExprSyntax(operator: ">=6.0", expression: "" as ExprSyntax)
                )
            }
        )
    }
}
