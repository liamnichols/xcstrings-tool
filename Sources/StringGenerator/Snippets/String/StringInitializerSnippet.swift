import SwiftSyntax
import SwiftSyntaxBuilder

struct StringInitializerSnippet: Snippet {
    let stringsTable: SourceFile.StringExtension.StringsTableStruct

    var variableToken: TokenSyntax {
        .identifier(stringsTable.sourceFile.tableVariableIdentifier)
    }

    var syntax: some DeclSyntaxProtocol {
        // internal init(localizable: Localizable, locale: Locale? = nil) { ... }
        InitializerDeclSyntax(
            modifiers: [
                DeclModifierSyntax(name: stringsTable.accessLevel.token),
            ],
            signature: FunctionSignatureSyntax(
                parameterClause: FunctionParameterClauseSyntax {
                    FunctionParameterSyntax(
                        firstName: variableToken,
                        type: IdentifierTypeSyntax(name: stringsTable.type)
                    )
                    FunctionParameterSyntax(
                        firstName: "locale",
                        type: OptionalTypeSyntax(wrappedType: .identifier(.Locale)),
                        defaultValue: InitializerClauseSyntax(value: NilLiteralExprSyntax())
                    )
                }
            )
        ) {
            // let key = String(describing: localizable.key)
            VariableDeclSyntax(bindingSpecifier: .keyword(.let)) {
                PatternBindingSyntax(
                    pattern: IdentifierPatternSyntax(identifier: "key"),
                    initializer: InitializerClauseSyntax(
                        value: FunctionCallExprSyntax(
                            callee: DeclReferenceExprSyntax(baseName: .type(.String))
                        ) {
                            LabeledExprSyntax(
                                label: "describing",
                                expression: MemberAccessExprSyntax(variableToken, stringsTable.keyProperty.name)
                            )
                        }
                    )
                )
            }
            // self.init(format:locale:arguments:)
            FunctionCallExprSyntax(
                callee: MemberAccessExprSyntax(
                    base: DeclReferenceExprSyntax(baseName: .keyword(.`self`)),
                    name: .keyword(.`init`)
                )
            ) {
                // format: bundle.localizedString(forKey: key, value: nil, table: localizable.table),
                LabeledExprSyntax(
                    label: "format",
                    expression: FunctionCallExprSyntax(
                        callee: MemberAccessExprSyntax(variableToken, stringsTable.bundleProperty.name, "localizedString")
                    ) {
                        // forKey: key,
                        LabeledExprSyntax(
                            label: "forKey",
                            expression: DeclReferenceExprSyntax(baseName: "key")
                        )
                        // value: nil,
                        LabeledExprSyntax(
                            label: "value",
                            expression: NilLiteralExprSyntax()
                        )
                        // table: localizable.table
                        LabeledExprSyntax(
                            label: "table",
                            expression: MemberAccessExprSyntax(variableToken, stringsTable.tableProperty.name)
                        )
                    }
                )
                // locale: locale,
                LabeledExprSyntax(
                    label: "locale",
                    expression: DeclReferenceExprSyntax(baseName: "locale")
                )
                // arguments: substitution.arguments.map(\.value)
                LabeledExprSyntax(
                    label: "arguments",
                    expression: FunctionCallExprSyntax(
                        callee: MemberAccessExprSyntax(variableToken, stringsTable.argumentsProperty.name, "map")
                    ) {
                        LabeledExprSyntax(
                            expression: KeyPathExprSyntax(
                                components: KeyPathComponentListSyntax {
                                    KeyPathComponentSyntax(
                                        period: .periodToken(),
                                        component: .property(KeyPathPropertyComponentSyntax(
                                            declName: DeclReferenceExprSyntax(baseName: "value")
                                        ))
                                    )
                                }
                            )
                        )
                    }
                )
            }
            .multiline()
        }
    }
}
