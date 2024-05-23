import SwiftSyntax
import SwiftSyntaxBuilder

struct LocalizedStringResourceStringsTableResourceFunctionSnippet: Snippet {
    let accessor: SourceFile.LocalizedStringResourceExtension.StringsTableStruct.ResourceAccessor

    var syntax: some DeclSyntaxProtocol {
        FunctionDeclSyntax(
            leadingTrivia: leadingTrivia,
            modifiers: modifiers,
            name: accessor.name,
            signature: FunctionSignatureSyntax(
                parameterClause: FunctionParameterClauseSyntax {
                    for argument in accessor.resource.arguments {
                        FunctionParameterSyntax(argument: argument)
                    }
                }.commaSeparated(),
                returnClause: ReturnClauseSyntax(type: accessor.type)
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
    }

    @CodeBlockItemListBuilder
    var body: CodeBlockItemListSyntax {
        FunctionCallExprSyntax(
            callee: DeclReferenceExprSyntax(
                baseName: .type(.LocalizedStringResource)
            )
        ) {
            LabeledExprSyntax(
                label: accessor.sourceFile.tableVariableIdentifier,
                expression: FunctionCallExprSyntax(
                    callee: MemberAccessExprSyntax(name: accessor.name)
                ) {
                    for argument in accessor.resource.arguments {
                        LabeledExprSyntax(
                            label: argument.label,
                            expression: DeclReferenceExprSyntax(
                                baseName: .identifier(argument.name)
                            )
                        )
                    }
                }
            )
        }
    }
}
