import SwiftSyntax
import SwiftSyntaxBuilder

struct LocalizedStringResourceStringsTableResourceVariableSnippet: Snippet {
    let accessor: SourceFile.LocalizedStringResourceExtension.StringsTableStruct.ResourceAccessor

    var syntax: some DeclSyntaxProtocol {
        VariableDeclSyntax(
            leadingTrivia: leadingTrivia,
            attributes: attributes.map({ $0.with(\.trailingTrivia, .newline) }),
            modifiers: modifiers,
            bindingSpecifier: .keyword(.var),
            bindings: [
                PatternBindingSyntax(
                    pattern: IdentifierPatternSyntax(identifier: accessor.variableName),
                    typeAnnotation: TypeAnnotationSyntax(type: accessor.type),
                    accessorBlock: AccessorBlockSyntax(
                        accessors: .getter(getter)
                    )
                )
            ]
        )
    }

    var leadingTrivia: Trivia? {
        Trivia(docComment: accessor.headerDocumentation)
    }

    var deprecationMessage: String {
        """
        Use `\(accessor.alternativeSignature)` instead. \
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
        DeclModifierSyntax(name: accessor.sourceFile.accessLevel.token)
    }

    @CodeBlockItemListBuilder
    var getter: CodeBlockItemListSyntax {
        FunctionCallExprSyntax(
            callee: DeclReferenceExprSyntax(
                baseName: .type(.LocalizedStringResource)
            )
        ) {
            LabeledExprSyntax(
                label: accessor.sourceFile.tableVariableIdentifier,
                expression: MemberAccessExprSyntax(name: accessor.nameForMemberAccess)
            )
        }
    }
}
