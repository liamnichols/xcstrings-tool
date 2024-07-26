import SwiftSyntax
import SwiftSyntaxBuilder

struct StringStringsTableHashIntoFunctionSnippet: Snippet {
    let stringsTable: SourceFile.StringExtension.StringsTableStruct
    let hasherToken: TokenSyntax = "hasher"

    var syntax: some DeclSyntaxProtocol {
        FunctionDeclSyntax(
            modifiers: modifiers,
            name: "hash",
            signature: FunctionSignatureSyntax(
                parameterClause: FunctionParameterClauseSyntax {
                    FunctionParameterSyntax(
                        firstName: "into",
                        secondName: hasherToken,
                        type: AttributedTypeSyntax(
                            specifiers: TypeSpecifierListSyntax {
                                SimpleTypeSpecifierSyntax(specifier: .keyword(.inout))
                            },
                            baseType: IdentifierTypeSyntax(name: .type(.Hasher))
                        )
                    )
                }
            ),
            body: CodeBlockSyntax(statements: body)
        )
    }

    @DeclModifierListBuilder
    var modifiers: DeclModifierListSyntax {
        DeclModifierSyntax(name: stringsTable.accessLevel.token)
    }

    @CodeBlockItemListBuilder
    var body: CodeBlockItemListSyntax {
        for property in stringsTable.comparableProperties {
            FunctionCallExprSyntax(callee: MemberAccessExprSyntax(hasherToken, "combine")) {
                LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: property.name))
            }
        }
    }
}
