import SwiftSyntax
import SwiftSyntaxBuilder

struct StringStringsTableUnderscoredKeyComputedPropertySnippet: Snippet {
    let stringsTable: SourceFile.StringExtension.StringsTableStruct

    var syntax: some DeclSyntaxProtocol {
        // fileprivate var _key: String { ... }
        VariableDeclSyntax(
            modifiers: modifiers,
            bindingSpecifier: .keyword(.var)
        ) {
            PatternBindingSyntax(
                pattern: IdentifierPatternSyntax(identifier: stringsTable._keyProperty.name),
                typeAnnotation: typeAnnotation,
                accessorBlock: AccessorBlockSyntax(accessors: .getter(body))
            )
        }
    }

    @DeclModifierListBuilder
    var modifiers: DeclModifierListSyntax {
        DeclModifierSyntax(name: .keyword(.fileprivate))
    }

    var typeAnnotation: TypeAnnotationSyntax {
        TypeAnnotationSyntax(
            type: stringsTable._keyProperty.type
        )
    }

    @CodeBlockItemListBuilder
    var body: CodeBlockItemListSyntax {
        // String(describing: key)
        FunctionCallExprSyntax(
            callee: DeclReferenceExprSyntax(baseName: .type(.String))
        ) {
            LabeledExprSyntax(
                label: "describing",
                expression: DeclReferenceExprSyntax(baseName: stringsTable.keyProperty.name)
            )
        }
    }
}
