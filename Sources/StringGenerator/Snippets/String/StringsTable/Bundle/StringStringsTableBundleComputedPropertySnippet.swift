import SwiftSyntax
import SwiftSyntaxBuilder

struct StringStringsTableBundleComputedPropertySnippet: Snippet {
    let stringsTable: SourceFile.StringExtension.StringsTableStruct

    var syntax: some DeclSyntaxProtocol {
        // var bundle: Bundle { ... }
        VariableDeclSyntax(
            bindingSpecifier: .keyword(.var)
        ) {
            PatternBindingSyntax(
                pattern: IdentifierPatternSyntax(identifier: stringsTable.bundleProperty.name),
                typeAnnotation: typeAnnotation,
                accessorBlock: AccessorBlockSyntax(accessors: .getter(body))
            )
        }
    }

    var typeAnnotation: TypeAnnotationSyntax {
        TypeAnnotationSyntax(
            type: stringsTable.bundleProperty.type
        )
    }

    @CodeBlockItemListBuilder
    var body: CodeBlockItemListSyntax {
        // #if SWIFT_PACKAGE
        // .module
        // #else
        // Bundle(for: BundleLocator.self)
        // #endif
        IfConfigDeclSyntax(
            reference: "SWIFT_PACKAGE",
            elements: .statements([
                CodeBlockItemSyntax(item: .expr(ExprSyntax(stringLiteral: stringsTable.bundleOverride ?? ".module")))
            ]),
            else: .statements([
                CodeBlockItemSyntax(item: .expr(ExprSyntax("Bundle(for: BundleLocator.self)")))
            ])
        )
    }
}
