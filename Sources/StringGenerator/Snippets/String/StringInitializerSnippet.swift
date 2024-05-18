import SwiftSyntax
import SwiftSyntaxBuilder

struct StringInitializerSnippet: Snippet {
    let stringsTable: StringsTable

    var variableToken: TokenSyntax {
        .identifier(stringsTable.name.variableIdentifier)
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
                        type: IdentifierTypeSyntax(name: stringsTable.name.token)
                    )
                    FunctionParameterSyntax(
                        firstName: "locale",
                        type: OptionalTypeSyntax(wrappedType: .identifier(.Locale)),
                        defaultValue: InitializerClauseSyntax(value: NilLiteralExprSyntax())
                    )
                }
            )
        ) {
            // let bundle: Bundle = .from(description: localizable.bundle) ?? .main
            VariableDeclSyntax(bindingSpecifier: .keyword(.let)) {
                PatternBindingSyntax(
                    pattern: IdentifierPatternSyntax(identifier: "bundle"),
                    typeAnnotation: TypeAnnotationSyntax(
                        type: IdentifierTypeSyntax(name: .type(.Bundle))
                    ),
                    initializer: InitializerClauseSyntax(
                        value: InfixOperatorExprSyntax(
                            leftOperand: FunctionCallExprSyntax(
                                callee: MemberAccessExprSyntax(name: "from")
                            ) {
                                LabeledExprSyntax(
                                    label: "description",
                                    expression: MemberAccessExprSyntax(variableToken, "bundle")
                                )
                            },
                            operator: BinaryOperatorExprSyntax(operator: .binaryOperator("??")),
                            rightOperand: MemberAccessExprSyntax(name: "main")
                        )
                    )
                )
            }
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
                                expression: MemberAccessExprSyntax(variableToken, "key")
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
                        callee: MemberAccessExprSyntax("bundle", "localizedString")
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
                            expression: MemberAccessExprSyntax(variableToken, "table")
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
                        callee: MemberAccessExprSyntax(variableToken, "arguments", "map")
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
