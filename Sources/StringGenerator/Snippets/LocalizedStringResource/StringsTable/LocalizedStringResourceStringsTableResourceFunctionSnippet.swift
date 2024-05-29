import SwiftSyntax
import SwiftSyntaxBuilder

struct LocalizedStringResourceStringsTableResourceFunctionSnippet: Snippet {
    let accessor: SourceFile.LocalizedStringResourceExtension.StringsTableStruct.ResourceAccessor

    var syntax: some DeclSyntaxProtocol {
        FunctionDeclSyntax(
            leadingTrivia: leadingTrivia,
            attributes: attributes.map({ $0.with(\.trailingTrivia, .newline) }),
            modifiers: modifiers,
            name: accessor.variableName,
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

    var deprecationMessage: String {
        """
        Use `\(accessor.alternativeSignature)` instead. \
        This method will be removed in the future.
        """
    }

    @AttributeListBuilder
    var attributes: AttributeListSyntax {
        AttributeSyntax(.identifier("iOS"), deprecated: 100000, message: deprecationMessage)
        AttributeSyntax(.identifier("macOS"), deprecated: 100000, message: deprecationMessage)
        AttributeSyntax(.identifier("tvOS"), deprecated: 100000, message: deprecationMessage)
        AttributeSyntax(.identifier("watchOS"), deprecated: 100000, message: deprecationMessage)
        AttributeSyntax(.identifier("visionOS"), deprecated: 100000, message: deprecationMessage)
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
                    callee: MemberAccessExprSyntax(name: accessor.nameForMemberAccess)
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
