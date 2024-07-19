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
            modifiers: modifiers,
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
                        calledExpression: MemberAccessExprSyntax(name: "atURL"),
                        leftParen: .leftParenToken(),
                        rightParen: .rightParenToken()
                    ) {
                        LabeledExprSyntax(
                            expression: MemberAccessExprSyntax(variableToken, stringsTable.bundleProperty.name, "bundleURL")
                        )
                    }
                )
            }
            .multiline()
        }
    }

    @DeclModifierListBuilder
    var modifiers: DeclModifierListSyntax {
        DeclModifierSyntax(name: stringsTable.accessLevel.token)
    }
}
