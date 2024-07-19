import SwiftSyntax
import SwiftSyntaxBuilder

struct StringStringsTableResourceFunctionSnippet: Snippet {
    let accessor: SourceFile.StringExtension.StringsTableStruct.ResourceAccessor

    var syntax: some DeclSyntaxProtocol {
        FunctionDeclSyntax(
            leadingTrivia: leadingTrivia,
            modifiers: modifiers,
            name: accessor.variableName,
            signature: FunctionSignatureSyntax(
                parameterClause: FunctionParameterClauseSyntax {
                    for argument in accessor.resource.arguments {
                        FunctionParameterSyntax(argument: argument)
                    }
                }.commaSeparated(),
                returnClause: ReturnClauseSyntax(type: IdentifierTypeSyntax(name: accessor.type))
            ),
            body: CodeBlockSyntax(statements: body)
        )
    }

    var leadingTrivia: Trivia? {
        Trivia(docComment: accessor.headerDocumentation)
    }

    @DeclModifierListBuilder
    var modifiers: DeclModifierListSyntax {
        DeclModifierSyntax(name: accessor.sourceFile.accessLevel.token)
        DeclModifierSyntax(name: .keyword(.static))
    }

    @CodeBlockItemListBuilder
    var body: CodeBlockItemListSyntax {
        FunctionCallExprSyntax(
            callee: DeclReferenceExprSyntax(baseName: accessor.type)
        ) {
            LabeledExprSyntax(
                label: "key",
                expression: StringLiteralExprSyntax(content: accessor.resource.key)
            )
            LabeledExprSyntax(
                label: "arguments",
                expression: ArrayExprSyntax {
                    for argument in accessor.resource.arguments {
                        // .object(arg1)
                        ArrayElementSyntax(
                            expression: FunctionCallExprSyntax(
                                callee: MemberAccessExprSyntax(name: argument.placeholderType.caseName)
                            ) {
                                LabeledExprSyntax(
                                    expression: DeclReferenceExprSyntax(
                                        baseName: .identifier(argument.name)
                                    )
                                )
                            }
                        )
                    }
                }
                    .multiline()
            )
            LabeledExprSyntax(
                label: "table",
                expression: StringLiteralExprSyntax(content: accessor.sourceFile.tableName)
            )
        }
        .multiline()
    }
}
