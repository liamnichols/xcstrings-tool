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
                        type: hasherType
                    )
                }
            ),
            body: CodeBlockSyntax(statements: body)
        )
    }

    var hasherType: AttributedTypeSyntax {
        #if canImport(SwiftSyntax600)
        AttributedTypeSyntax(
            specifiers: TypeSpecifierListSyntax {
                SimpleTypeSpecifierSyntax(specifier: .keyword(.inout))
            },
            baseType: IdentifierTypeSyntax(name: .type(.Hasher))
        )
        #else
        AttributedTypeSyntax(
            specifier: .keyword(.inout),
            baseType: IdentifierTypeSyntax(name: .type(.Hasher))
        )
        #endif
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
