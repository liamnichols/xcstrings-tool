import SwiftSyntax
import SwiftSyntaxBuilder

struct LocalizedStringResourceInitializerSnippet {
    let stringsTable: SourceFile.StringExtension.StringsTableStruct

    var variableToken: TokenSyntax {
        .identifier(stringsTable.sourceFile.tableVariableIdentifier)
    }
}

extension LocalizedStringResourceInitializerSnippet: Snippet {
    var syntax: some DeclSyntaxProtocol {
        InitializerDeclSyntax(
            signature: FunctionSignatureSyntax(
                parameterClause: FunctionParameterClauseSyntax(
                    leftParen: .leftParenToken(),
                    rightParen: .rightParenToken()
                ) {
                    FunctionParameterSyntax(
                        firstName: variableToken,
                        type: typeSyntax(from: stringsTable.fullyQualifiedType)
                    )
                }
            )
        ) {
            FunctionCallExprSyntax(
                callee: MemberAccessExprSyntax(.keyword(.`self`), .keyword(.`init`))
            ) {
                // localizable.key,
                LabeledExprSyntax(
                    expression: MemberAccessExprSyntax(variableToken, stringsTable.keyProperty.name)
                )
                // defaultValue: localizable.defaultValue,
                LabeledExprSyntax(
                    label: "defaultValue",
                    expression: MemberAccessExprSyntax(variableToken, stringsTable.defaultValueProperty.name)
                )
                // table: localizable.table,
                LabeledExprSyntax(
                    label: "table",
                    expression: MemberAccessExprSyntax(variableToken, stringsTable.tableProperty.name)
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
                            expression: MemberAccessExprSyntax(variableToken, stringsTable.bundleProperty.name)
                        )
                    }
                )
            }
            .multiline()
        }
    }
}
