import SwiftSyntax
import SwiftSyntaxBuilder

struct StringStringsTableBundleDescriptionCurrentComputedPropertySnippet: Snippet {
    var syntax: some DeclSyntaxProtocol {
        VariableDeclSyntax(
            modifiers: [
                DeclModifierSyntax(name: .keyword(.static))
            ],
            bindingSpecifier: .keyword(.var),
            bindings: [
                PatternBindingSyntax(
                    pattern: IdentifierPatternSyntax(identifier: "current"),
                    typeAnnotation: TypeAnnotationSyntax(type: IdentifierTypeSyntax(name: "Self")),
                    accessorBlock: AccessorBlockSyntax(
                        accessors: .getter([
                            CodeBlockItemSyntax(
                                item: .decl(
                                    DeclSyntax(
                                        IfConfigDeclSyntax(
                                            reference: "SWIFT_PACKAGE",
                                            elements: .statements([
                                                CodeBlockItemSyntax(item: .expr(ExprSyntax(".atURL(Bundle.module.bundleURL)")))
                                            ]),
                                            else: .statements([
                                                CodeBlockItemSyntax(item: .expr(ExprSyntax(".forClass(BundleLocator.self)")))
                                            ])
                                        )
                                    )
                                )
                            )
                        ])
                    )
                )
            ]
        )
    }
}
