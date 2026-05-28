import SwiftSyntax
import SwiftSyntaxBuilder

struct StringStringsTableResourceVariableSnippet: Snippet {
    let accessor: SourceFile.StringExtension.StringsTableStruct.ResourceAccessor
    var nameOverride: TokenSyntax? = nil

    var effectiveName: TokenSyntax { nameOverride ?? accessor.variableName }

    var syntax: some DeclSyntaxProtocol {
        VariableDeclSyntax(
            leadingTrivia: leadingTrivia,
            modifiers: modifiers,
            bindingSpecifier: .keyword(.var),
            bindings: [
                PatternBindingSyntax(
                    pattern: IdentifierPatternSyntax(identifier: effectiveName),
                    typeAnnotation: TypeAnnotationSyntax(type: IdentifierTypeSyntax(name: accessor.type)),
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
        DeclModifierSyntax(name: .keyword(.static))
    }

    @CodeBlockItemListBuilder
    var getter: CodeBlockItemListSyntax {
        FunctionCallExprSyntax(
            callee: DeclReferenceExprSyntax(baseName: accessor.type)
        ) {
            LabeledExprSyntax(
                label: "key",
                expression: StringLiteralExprSyntax(content: accessor.resource.key)
            )
            LabeledExprSyntax(
                label: "arguments",
                expression: ArrayExprSyntax(elements: [])
            )
            LabeledExprSyntax(
                label: "table",
                expression: StringLiteralExprSyntax(content: accessor.sourceFile.tableName)
            )
        }
        .multiline()
    }
}
