import SwiftSyntax
import SwiftSyntaxBuilder

struct LocalizedStringResourceStringsTableComputedPropertySnippet {
    let sourceFile: SourceFile
}

extension LocalizedStringResourceStringsTableComputedPropertySnippet: Snippet {
    var syntax: some DeclSyntaxProtocol {
        // internal static let localizable = Localizable()
        VariableDeclSyntax(
            modifiers: modifiers,
            .let,
            name: PatternSyntax(IdentifierPatternSyntax(
                identifier: .identifier(sourceFile.tableVariableIdentifier))
            ),
            initializer: InitializerClauseSyntax(
                value: FunctionCallExprSyntax(
                    calledExpression: DeclReferenceExprSyntax(
                        baseName: sourceFile.localizedStringResourceExtension.stringsTableStruct.type
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
        DeclModifierSyntax(name: sourceFile.accessLevel.token)
        DeclModifierSyntax(name: .keyword(.static))
    }
}
