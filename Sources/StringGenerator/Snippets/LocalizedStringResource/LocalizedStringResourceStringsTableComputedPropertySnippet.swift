import SwiftSyntax
import SwiftSyntaxBuilder

struct LocalizedStringResourceStringsTableComputedPropertySnippet {
    let stringsTable: LocalizedStringResourceTable
}

extension LocalizedStringResourceStringsTableComputedPropertySnippet: Snippet {
    var syntax: some DeclSyntaxProtocol {
        // internal static let localizable = Localizable()
        VariableDeclSyntax(
            modifiers: modifiers,
            .let,
            name: PatternSyntax(IdentifierPatternSyntax(
                identifier: .identifier(stringsTable.stringsTable.name.variableIdentifier))
            ),
            initializer: InitializerClauseSyntax(
                value: FunctionCallExprSyntax(
                    calledExpression: DeclReferenceExprSyntax(
                        baseName: stringsTable.stringsTable.name.token
                    ),
                    leftParen: .leftParenToken(),
                    arguments: [],
                    rightParen: .rightParenToken()
                )
            )
        )
    }

    @DeclModifierListBuilder
    var modifiers: DeclModifierListSyntax {
        DeclModifierSyntax(name: stringsTable.stringsTable.accessLevel.token)
        DeclModifierSyntax(name: .keyword(.static))
    }
}
