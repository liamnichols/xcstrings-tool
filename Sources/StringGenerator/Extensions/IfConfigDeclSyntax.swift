import SwiftSyntax

extension IfConfigDeclSyntax {
    init(
        prefixOperator: String? = nil,
        reference: TokenSyntax,
        elements: IfConfigClauseSyntax.Elements,
        else elseElements: IfConfigClauseSyntax.Elements? = nil
    ) {
        self.init(clauses: IfConfigClauseListSyntax {
            if let prefixOperator {
                IfConfigClauseSyntax(
                    poundKeyword: .poundIfToken(),
                    condition: PrefixOperatorExprSyntax(
                        operator: .prefixOperator(prefixOperator),
                        expression: DeclReferenceExprSyntax(baseName: reference)
                    ),
                    elements: elements
                )
            } else {
                IfConfigClauseSyntax(
                    poundKeyword: .poundIfToken(),
                    condition: DeclReferenceExprSyntax(baseName: reference),
                    elements: elements
                )
            }

            if let elseElements {
                IfConfigClauseSyntax(
                    poundKeyword: .poundElseToken(),
                    elements: elseElements
                )
            }
        })
    }
}
