import SwiftSyntax
import SwiftSyntaxBuilder

struct LocalizedStringResourceStringsTableComputedPropertySnippet {
    let sourceFile: SourceFile
}

extension LocalizedStringResourceStringsTableComputedPropertySnippet: Snippet {
    var syntax: some DeclSyntaxProtocol {
        // internal static let localizable = Localizable()
        VariableDeclSyntax(
            attributes: attributes.map({ $0.with(\.trailingTrivia, .newline) }),
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

    var deprecationMessage: String {
        """
        Use the `\(sourceFile.tableVariableIdentifier)(_:)` static method instead. \
        This property will be removed in the future.
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
        DeclModifierSyntax(name: sourceFile.accessLevel.token)
        DeclModifierSyntax(name: .keyword(.static))
    }
}
