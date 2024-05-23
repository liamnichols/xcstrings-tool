import SwiftSyntax
import SwiftSyntaxBuilder

struct LocalizedStringResourceStringsTableResourceVariableSnippet: Snippet {
    let accessor: SourceFile.LocalizedStringResourceExtension.StringsTableStruct.ResourceAccessor

    var syntax: some DeclSyntaxProtocol {
        VariableDeclSyntax(
            leadingTrivia: leadingTrivia,
            modifiers: modifiers,
            bindingSpecifier: .keyword(.var),
            bindings: [
                PatternBindingSyntax(
                    pattern: IdentifierPatternSyntax(identifier: accessor.name),
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
                expression: MemberAccessExprSyntax(name: accessor.name)
            )
        }
    }
}
