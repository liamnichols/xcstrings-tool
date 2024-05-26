import SwiftSyntax
import SwiftSyntaxBuilder

struct StringsTableConversionStaticMethodSnippet {
    let stringsTable: SourceFile.StringExtension.StringsTableStruct
    let returnType: TokenSyntax
}

extension StringsTableConversionStaticMethodSnippet: Snippet {
    var syntax: some DeclSyntaxProtocol {
        FunctionDeclSyntax(
            leadingTrivia: leadingTrivia,
            modifiers: modifiers,
            name: name,
            signature: signature,
            body: body
        )
    }

    var leadingTrivia: Trivia? {
        Trivia(docComment: """
        Creates a `\(returnType.text)` that represents a localized value in the ‘\(stringsTable.sourceFile.tableName)‘ strings table.
        """)
    }

    @DeclModifierListBuilder
    var modifiers: DeclModifierListSyntax {
        DeclModifierSyntax(name: stringsTable.accessLevel.token)
        DeclModifierSyntax(name: .keyword(.static))
    }

    var name: TokenSyntax {
        .identifier(stringsTable.sourceFile.tableVariableIdentifier)
    }

    var signature: FunctionSignatureSyntax {
        FunctionSignatureSyntax(
            parameterClause: FunctionParameterClauseSyntax {
                FunctionParameterSyntax(
                    firstName: .wildcardToken(),
                    secondName: name,
                    type: MemberTypeSyntax(tokens: stringsTable.fullyQualifiedType)
                )
            },
            returnClause: ReturnClauseSyntax(
                type: IdentifierTypeSyntax(name: returnType)
            )
        )
    }

    var body: CodeBlockSyntax {
        CodeBlockSyntax {
            FunctionCallExprSyntax(callee: DeclReferenceExprSyntax(baseName: returnType)) {
                LabeledExprSyntax(
                    label: name.text,
                    expression: DeclReferenceExprSyntax(baseName: name)
                )
            }
        }
    }
}
