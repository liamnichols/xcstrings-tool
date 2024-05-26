import SwiftSyntax
import SwiftSyntaxBuilder

struct LocalizedStringKeyInitializerSnippet {
    let stringsTable: SourceFile.StringExtension.StringsTableStruct

    var variableToken: TokenSyntax {
        .identifier(stringsTable.sourceFile.tableVariableIdentifier)
    }
}

extension LocalizedStringKeyInitializerSnippet: Snippet {
    var syntax: some DeclSyntaxProtocol {
        InitializerDeclSyntax(modifiers: modifiers, signature: signature) {
            // let text = Text(localizable: localizable)
            VariableDeclSyntax(
                .let,
                name: PatternSyntax(IdentifierPatternSyntax(identifier: "text")),
                initializer: InitializerClauseSyntax(
                    value: FunctionCallExprSyntax(
                        callee: DeclReferenceExprSyntax(baseName: .type(.Text))
                    ) {
                        LabeledExprSyntax(
                            label: variableToken.text,
                            expression: DeclReferenceExprSyntax(baseName: variableToken)
                        )
                    }
                )
            )
            .with(\.trailingTrivia, .newlines(2))

            // var stringInterpolation = LocalizedStringKey.StringInterpolation(literalCapacity: 0, interpolationCount: 1)
            // stringInterpolation.appendInterpolation(text)
            StringInterpolationVariableInitializerSnippet(
                variableName: "stringInterpolation",
                type: MemberAccessExprSyntax(.type(.LocalizedStringKey), .type(.StringInterpolation)),
                literalCapacity: IntegerLiteralExprSyntax(0),
                interpolationCount: IntegerLiteralExprSyntax(1)
            )
            FunctionCallExprSyntax(
                callee: MemberAccessExprSyntax(
                    base: DeclReferenceExprSyntax(baseName: "stringInterpolation"),
                    name: "appendInterpolation"
                )
            ) {
                LabeledExprSyntax(
                    expression: DeclReferenceExprSyntax(baseName: "text")
                )
            }
            .with(\.trailingTrivia, .newlines(2))

            // let makeKey = LocalizedStringKey.init(stringInterpolation:)
            // self = makeKey(stringInterpolation)
            ExpressibleByStringInterplationInitializerClosureSnippet(
                variableName: "makeKey",
                type: DeclReferenceExprSyntax(baseName: .type(.LocalizedStringKey))
            )
            InfixOperatorExprSyntax(
                leftOperand: DeclReferenceExprSyntax(baseName: .keyword(.`self`)),
                operator: AssignmentExprSyntax(),
                rightOperand: FunctionCallExprSyntax(
                    callee: DeclReferenceExprSyntax(baseName: "makeKey")
                ) {
                    LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: "stringInterpolation"))
                }
            )
        }
    }

    @DeclModifierListBuilder
    var modifiers: DeclModifierListSyntax {
        DeclModifierSyntax(name: stringsTable.accessLevel.token)
    }

    var signature: FunctionSignatureSyntax {
        FunctionSignatureSyntax(
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
    }

    var ifAvailableUseLocalizedStringResource: some ExprSyntaxProtocol {
        IfExprSyntax(
            conditions: ConditionElementListSyntax {
                AvailabilityConditionSyntax(
                    availabilityKeyword: .poundAvailableToken(),
                    availabilityArguments: .wwdc2022
                )
            },
            body: CodeBlockSyntax(statements: CodeBlockItemListSyntax {
                // self.init(LocalizedStringResource(localizable: localizable))
                FunctionCallExprSyntax(
                    callee: MemberAccessExprSyntax("self", "init")
                ) {
                    // LocalizedStringResource(localizable: localizable)
                    LabeledExprSyntax(
                        expression: FunctionCallExprSyntax(
                            callee: DeclReferenceExprSyntax(baseName: .type(.LocalizedStringResource))
                        ) {
                            LabeledExprSyntax(
                                label: variableToken.text,
                                expression: DeclReferenceExprSyntax(baseName: variableToken)
                            )
                        }
                    )
                }

                // return
                ReturnStmtSyntax()
            })
        )
    }

    var initWithKeyTableAndBundle: some ExprSyntaxProtocol {
        // self.init(key, table: localizable.table, bundle: .from(description: localizable.bundle)
        FunctionCallExprSyntax(
            callee: MemberAccessExprSyntax("self", "init")
        ) {
            // key,
            LabeledExprSyntax(
                expression: DeclReferenceExprSyntax(baseName: "key")
            )

            // tableName: localizable.table,
            LabeledExprSyntax(
                label: "tableName",
                expression: MemberAccessExprSyntax(variableToken, stringsTable.tableProperty.name)
            )

            // bundle: .from(description: localizable.bundle)
            LabeledExprSyntax(
                label: "bundle",
                expression: FunctionCallExprSyntax(
                    callee: MemberAccessExprSyntax(name: "from")
                ) {
                    // description: localizable.bundle
                    LabeledExprSyntax(
                        label: "description",
                        expression: MemberAccessExprSyntax(variableToken, stringsTable.bundleProperty.name)
                    )
                }
            )
        }
    }
}
