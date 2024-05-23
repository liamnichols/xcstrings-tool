import SwiftSyntax
import SwiftSyntaxBuilder

struct StringStringsTableResourceVariableSnippet: Snippet {
    let accessor: SourceFile.StringExtension.StringsTableStruct.ResourceAccessor

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
        DeclModifierSyntax(name: .keyword(.static))
    }

    @CodeBlockItemListBuilder
    var getter: CodeBlockItemListSyntax {
        FunctionCallExprSyntax(
            callee: DeclReferenceExprSyntax(
                baseName: .keyword(.Self)
            )
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
            LabeledExprSyntax(
                label: "bundle",
                expression: MemberAccessExprSyntax(name: "current")
            )
        }
        .multiline()
    }
}
