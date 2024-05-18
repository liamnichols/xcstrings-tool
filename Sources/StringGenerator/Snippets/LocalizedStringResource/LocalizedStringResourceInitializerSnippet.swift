import SwiftSyntax
import SwiftSyntaxBuilder

struct LocalizedStringResourceInitializerSnippet {
    let stringsTable: LocalizedStringResourceTable

    var variableToken: TokenSyntax {
        .identifier(stringsTable.stringsTable.name.variableIdentifier)
    }
}

extension LocalizedStringResourceInitializerSnippet: Snippet {
    var syntax: some DeclSyntaxProtocol {
        InitializerDeclSyntax(
            modifiers: modifiers,
            signature: FunctionSignatureSyntax(
                parameterClause: FunctionParameterClauseSyntax(
                    leftParen: .leftParenToken(),
                    rightParen: .rightParenToken()
                ) {
                    FunctionParameterSyntax(
                        firstName: variableToken,
                        type: typeSyntax(from: stringsTable.stringsTable.fullyQualifiedName)
                    )
                }
            )
        ) {
            FunctionCallExprSyntax(
                callee: MemberAccessExprSyntax(.keyword(.`self`), .keyword(.`init`))
            ) {
                // localizable.key,
                LabeledExprSyntax(
                    expression: MemberAccessExprSyntax(variableToken, "key")
                )
                // defaultValue: localizable.defaultValue,
                LabeledExprSyntax(
                    label: "defaultValue",
                    expression: MemberAccessExprSyntax(variableToken, "defaultValue")
                )
                // table: localizable.table,
                LabeledExprSyntax(
                    label: "table",
                    expression: MemberAccessExprSyntax(variableToken, "table")
                )
                // bundle: .from(description: localizable.bundle)
                LabeledExprSyntax(
                    label: "bundle",
                    expression: FunctionCallExprSyntax(
                        calledExpression: MemberAccessExprSyntax(name: "from"),
                        leftParen: .leftParenToken(),
                        rightParen: .rightParenToken()
                    ) {
                        LabeledExprSyntax(
                            label: "description",
                            expression: MemberAccessExprSyntax(variableToken, "bundle")
                        )
                    }
                )
            }
            .multiline()
        }
    }
    
    @DeclModifierListBuilder
    var modifiers: DeclModifierListSyntax {
        DeclModifierSyntax(name: .keyword(.private))
    }
}
