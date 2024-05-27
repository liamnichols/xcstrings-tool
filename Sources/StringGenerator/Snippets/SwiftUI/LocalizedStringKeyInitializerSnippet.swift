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
        InitializerDeclSyntax(
            leadingTrivia: leadingTrivia,
            modifiers: modifiers,
            signature: signature,
            body: body
        )
    }

    var leadingTrivia: Trivia? {
        Trivia(docComment: """
        Creates a localized string key that represents a localized value in the ‘\(stringsTable.sourceFile.tableName)‘ strings table.
        """)
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

    var body: CodeBlockSyntax {
        CodeBlockSyntax {
            // var stringInterpolation = LocalizedStringKey.StringInterpolation(literalCapacity: 0, interpolationCount: 1)
            StringInterpolationVariableInitializerSnippet(
                variableName: "stringInterpolation",
                type: MemberAccessExprSyntax(.type(.LocalizedStringKey), .type(.StringInterpolation)),
                literalCapacity: IntegerLiteralExprSyntax(0),
                interpolationCount: IntegerLiteralExprSyntax(1)
            )
            .syntax
            .with(\.trailingTrivia, .newlines(2))

            // if #available (macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
            //     stringInterpolation.appendInterpolation(LocalizedStringResource(localizable: localizable))
            // } else {
            //     stringInterpolation.appendInterpolation(Text(localizable: localizable))
            // }
            IfExprSyntax(availability: .wwdc2022) {
                appendInterpolation(ofType: .LocalizedStringResource)
            } elseBodyBuilder: {
                appendInterpolation(ofType: .Text)
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

    func appendInterpolation(ofType type: TokenSyntax.MetaType) -> FunctionCallExprSyntax {
        // stringInterpolation.appendInterpolation({LocalizedStringResource|Text}(localizable: localizable))
        FunctionCallExprSyntax(
            callee: MemberAccessExprSyntax(
                base: DeclReferenceExprSyntax(baseName: "stringInterpolation"),
                name: "appendInterpolation"
            )
        ) {
            LabeledExprSyntax(
                expression: FunctionCallExprSyntax(
                    callee: DeclReferenceExprSyntax(baseName: .type(type))
                ) {
                    LabeledExprSyntax(
                        label: variableToken.text,
                        expression: DeclReferenceExprSyntax(baseName: variableToken)
                    )
                }
            )
        }
    }
}
