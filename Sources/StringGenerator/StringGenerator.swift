import Foundation
import StringResource
import SwiftBasicFormat
import SwiftIdentifier
import SwiftSyntax
import SwiftSyntaxBuilder

public struct StringGenerator {
    public enum AccessLevel: String, CaseIterable {
        case `internal`, `public`, `package`
    }

    let tableName: String
    let accessLevel: AccessLevel
    let resources: [Resource]

    init(tableName: String, accessLevel: AccessLevel, resources: [Resource]) {
        self.tableName = tableName
        self.accessLevel = accessLevel
        self.resources = resources
    }

    public static func generateSource(
        for resources: [Resource],
        tableName: String,
        accessLevel: AccessLevel
    ) -> String {
        StringGenerator(tableName: tableName, accessLevel: accessLevel, resources: resources)
            .generate()
            .formatted()
            .description
    }

    func generate() -> SourceFileSyntax {
        SourceFileSyntax {
            generateImports()
                .with(\.trailingTrivia, .newlines(2))

            generateStringExtension()
                .with(\.trailingTrivia, .newlines(2))

            generateStringsTableExtension()
                .with(\.trailingTrivia, .newlines(2))

            generateBundleDescriptionExtension()
                .with(\.trailingTrivia, .newlines(2))

            generateBundleExtension()
                .with(\.trailingTrivia, .newlines(2))

            // iOS 16+ LocalisedStringResource

            generateFoundationBundleDescriptionExtension()
                .with(\.trailingTrivia, .newlines(2))

            generateLocalizedStringResourceExtension()
        }
    }

    // MARK: - Source File Contents

    func generateImports() -> ImportDeclSyntax {
        ImportDeclSyntax(
            path: [
                ImportPathComponentSyntax(name: .identifier("Foundation"))
            ]
        )
    }

    func generateStringExtension() -> ExtensionDeclSyntax {
        ExtensionDeclSyntax(
            attributes: [
                .attribute(.init(availability: .wwdc2021))
                    .with(\.trailingTrivia, .newline)
            ],
            extendedType: IdentifierTypeSyntax(name: "String"),
            memberBlock: MemberBlockSyntax {
                // Table struct
                StructDeclSyntax(
//                    leadingTrivia: typeDocumentation,
                    modifiers: [
                        DeclModifierSyntax(name: accessLevel.token)
                    ],
                    name: structToken,
                    memberBlockBuilder: {
                        // BundleDescription
                        EnumDeclSyntax(
                            modifiers: [
                                DeclModifierSyntax(name: accessLevel.token)
                            ],
                            name: bundleDescriptionNameToken,
                            memberBlockBuilder: {
                                EnumCaseDeclSyntax {
                                    EnumCaseElementSyntax(name: .identifier("main"))
                                }
                                EnumCaseDeclSyntax {
                                    EnumCaseElementSyntax(
                                        name: .identifier("atURL"),
                                        parameterClause: EnumCaseParameterClauseSyntax(
                                            parameters: [
                                                "URL"
                                            ]
                                        )
                                    )
                                }
                                EnumCaseDeclSyntax {
                                    EnumCaseElementSyntax(
                                        name: .identifier("forClass"),
                                        parameterClause: EnumCaseParameterClauseSyntax(
                                            parameters: [
                                                "AnyClass"
                                            ]
                                        )
                                    )
                                }
                            },
                            trailingTrivia: .newlines(2)
                        )

                        // Properties
                        VariableDeclSyntax(
                            modifiers: [
                                DeclModifierSyntax(name: accessLevel.token),
                            ],
                            .let,
                            name: PatternSyntax(IdentifierPatternSyntax(identifier: "key")),
                            type: TypeAnnotationSyntax(
                                type: IdentifierTypeSyntax(name: "StaticString")
                            )
                        )
                        VariableDeclSyntax(
                            modifiers: [
                                DeclModifierSyntax(name: accessLevel.token),
                            ],
                            .let,
                            name: PatternSyntax(IdentifierPatternSyntax(identifier: "defaultValue")),
                            type: TypeAnnotationSyntax(
                                type: IdentifierTypeSyntax(name: "LocalizationValue")
                            )
                        )
                        VariableDeclSyntax(
                            modifiers: [
                                DeclModifierSyntax(name: accessLevel.token),
                            ],
                            .let,
                            name: PatternSyntax(IdentifierPatternSyntax(identifier: "table")),
                            type: TypeAnnotationSyntax(
                                type: OptionalTypeSyntax(
                                    wrappedType: IdentifierTypeSyntax(name: "String")
                                )
                            )
                        )
                        VariableDeclSyntax(
                            modifiers: [
                                DeclModifierSyntax(name: accessLevel.token),
                            ],
                            .var,
                            name: PatternSyntax(IdentifierPatternSyntax(identifier: "locale")),
                            type: TypeAnnotationSyntax(
                                type: IdentifierTypeSyntax(name: "Locale")
                            )
                        )
                        VariableDeclSyntax(
                            modifiers: [
                                DeclModifierSyntax(name: accessLevel.token),
                            ],
                            .let,
                            name: PatternSyntax(IdentifierPatternSyntax(identifier: "bundle")),
                            type: TypeAnnotationSyntax(
                                type: IdentifierTypeSyntax(name: "BundleDescription")
                            )
                        ).with(\.trailingTrivia, .newlines(2))

                        // Init
                        InitializerDeclSyntax(
                            modifiers: [
                                DeclModifierSyntax(name: .keyword(.fileprivate)),
                            ],
                            signature: FunctionSignatureSyntax(
                                parameterClause: FunctionParameterClauseSyntax {
                                    FunctionParameterSyntax(
                                        firstName: "key",
                                        type: IdentifierTypeSyntax(name: "StaticString")
                                    )
                                    .with(\.trailingComma, .commaToken())
                                    .with(\.leadingTrivia, .newline)

                                    FunctionParameterSyntax(
                                        firstName: "defaultValue",
                                        type: IdentifierTypeSyntax(name: "LocalizationValue")
                                    )
                                    .with(\.trailingComma, .commaToken())
                                    .with(\.leadingTrivia, .newline)

                                    FunctionParameterSyntax(
                                        firstName: "table",
                                        type: OptionalTypeSyntax(
                                            wrappedType: IdentifierTypeSyntax(name: "String")
                                        )
                                    )
                                    .with(\.trailingComma, .commaToken())
                                    .with(\.leadingTrivia, .newline)

                                    FunctionParameterSyntax(
                                        firstName: "locale",
                                        type: IdentifierTypeSyntax(name: "Locale")
                                    )
                                    .with(\.trailingComma, .commaToken())
                                    .with(\.leadingTrivia, .newline)

                                    FunctionParameterSyntax(
                                        firstName: "bundle",
                                        type: IdentifierTypeSyntax(name: "BundleDescription")
                                    )
                                    .with(\.leadingTrivia, .newline)
                                }
                            )
                        ) {
                            InfixOperatorExprSyntax(
                                leftOperand: MemberAccessExprSyntax(
                                    base: DeclReferenceExprSyntax(baseName: .keyword(.`self`)),
                                    name: "key"
                                ),
                                operator: AssignmentExprSyntax(),
                                rightOperand: DeclReferenceExprSyntax(baseName: "key")
                            )
                            InfixOperatorExprSyntax(
                                leftOperand: MemberAccessExprSyntax(
                                    base: DeclReferenceExprSyntax(baseName: .keyword(.`self`)),
                                    name: "defaultValue"
                                ),
                                operator: AssignmentExprSyntax(),
                                rightOperand: DeclReferenceExprSyntax(baseName: "defaultValue")
                            )
                            InfixOperatorExprSyntax(
                                leftOperand: MemberAccessExprSyntax(
                                    base: DeclReferenceExprSyntax(baseName: .keyword(.`self`)),
                                    name: "table"
                                ),
                                operator: AssignmentExprSyntax(),
                                rightOperand: DeclReferenceExprSyntax(baseName: "table")
                            )
                            InfixOperatorExprSyntax(
                                leftOperand: MemberAccessExprSyntax(
                                    base: DeclReferenceExprSyntax(baseName: .keyword(.`self`)),
                                    name: "locale"
                                ),
                                operator: AssignmentExprSyntax(),
                                rightOperand: DeclReferenceExprSyntax(baseName: "locale")
                            )
                            InfixOperatorExprSyntax(
                                leftOperand: MemberAccessExprSyntax(
                                    base: DeclReferenceExprSyntax(baseName: .keyword(.`self`)),
                                    name: "bundle"
                                ),
                                operator: AssignmentExprSyntax(),
                                rightOperand: DeclReferenceExprSyntax(baseName: "bundle")
                            )
                        }
                    },
                    trailingTrivia: .newlines(2)
                )

                // String initialiser
                InitializerDeclSyntax(
                    modifiers: [
                        DeclModifierSyntax(name: accessLevel.token),
                    ],
                    signature: FunctionSignatureSyntax(
                        parameterClause: FunctionParameterClauseSyntax {
                            FunctionParameterSyntax(
                                firstName: variableToken,
                                type: IdentifierTypeSyntax(name: structToken)
                            )
                        }
                    )
                ) {
                    FunctionCallExprSyntax(
                        calledExpression: MemberAccessExprSyntax(
                            base: DeclReferenceExprSyntax(baseName: .keyword(.`self`)),
                            name: .keyword(.`init`)
                        ),
                        leftParen: .leftParenToken(),
                        rightParen: .rightParenToken()
                    ) {
                        LabeledExprSyntax(
                            label: "localized",
                            expression: MemberAccessExprSyntax(
                                base: DeclReferenceExprSyntax(baseName: variableToken),
                                name: "key"
                            )
                        )
                        LabeledExprSyntax(
                            label: "defaultValue",
                            expression: MemberAccessExprSyntax(
                                base: DeclReferenceExprSyntax(baseName: variableToken),
                                name: "defaultValue"
                            )
                        )
                        LabeledExprSyntax(
                            label: "table",
                            expression: MemberAccessExprSyntax(
                                base: DeclReferenceExprSyntax(baseName: variableToken),
                                name: "table"
                            )
                        )
                        LabeledExprSyntax(
                            label: "bundle",
                            expression: FunctionCallExprSyntax(
                                calledExpression: MemberAccessExprSyntax(
                                    name: "from"
                                ),
                                leftParen: .leftParenToken(),
                                rightParen: .rightParenToken()
                            ) {
                                LabeledExprSyntax(
                                    label: "description",
                                    expression: MemberAccessExprSyntax(
                                        base: DeclReferenceExprSyntax(baseName: variableToken),
                                        name: "bundle"
                                    )
                                )
                            }
                        )
                        LabeledExprSyntax(
                            label: "locale",
                            expression: MemberAccessExprSyntax(
                                base: DeclReferenceExprSyntax(baseName: variableToken),
                                name: "locale"
                            )
                        )
                    }
                }
            }
        )
    }

    func generateStringsTableExtension() -> ExtensionDeclSyntax {
        ExtensionDeclSyntax(
            attributes: [
                .attribute(.init(availability: .wwdc2021))
                    .with(\.trailingTrivia, .newline)
            ],
            extendedType: localTableMemberType
        ) {
            for resource in resources {
                resource.declaration(
                    tableName: tableName,
                    variableToken: variableToken,
                    accessLevel: accessLevel.token,
                    isLocalizedStringResource: false
                )
            }
        }
    }

    func generateBundleDescriptionExtension() -> ExtensionDeclSyntax {
        ExtensionDeclSyntax(
            attributes: [
                .attribute(.init(availability: .wwdc2021))
                    .with(\.trailingTrivia, .newline)
            ],
            modifiers: [
                DeclModifierSyntax(name: .keyword(.private))
            ],
            extendedType: localBundleDescriptionMemberType,
            memberBlock: MemberBlockSyntax {
                IfConfigDeclSyntax(
                    prefixOperator: "!",
                    reference: "SWIFT_PACKAGE",
                    elements: .decls([
                        .init(decl: DeclSyntax("private class BundleLocator {}"))
                    ])
                )
                .with(\.trailingTrivia, .newlines(2))

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
        )
    }

    func generateBundleExtension() -> ExtensionDeclSyntax {
        ExtensionDeclSyntax(
            attributes: [
                .attribute(.init(availability: .wwdc2021))
                .with(\.trailingTrivia, .newline)
            ],
            modifiers: [
                DeclModifierSyntax(name: .keyword(.private))
            ],
            extendedType: IdentifierTypeSyntax(name: "Bundle")
        ) {
            FunctionDeclSyntax(
                modifiers: [
                    DeclModifierSyntax(name: .keyword(.static))
                ],
                name: "from",
                signature: FunctionSignatureSyntax(
                    parameterClause: FunctionParameterClauseSyntax {
                        FunctionParameterSyntax(
                            firstName: "description",
                            type: localBundleDescriptionMemberType
                        )
                    },
                    returnClause: ReturnClauseSyntax(
                        type: OptionalTypeSyntax(
                            wrappedType: IdentifierTypeSyntax(name: "Bundle")
                        )
                    )
                )
            ) {
                SwitchExprSyntax(
                    subject: DeclReferenceExprSyntax(baseName: "description")
                ) {
                    // case .main:
                    SwitchCaseSyntax(
                        label: .case(
                            SwitchCaseLabelSyntax(
                                caseItems: SwitchCaseItemListSyntax {
                                    SwitchCaseItemSyntax(
                                        pattern: ExpressionPatternSyntax(
                                            expression: MemberAccessExprSyntax(
                                                declName: DeclReferenceExprSyntax(baseName: "main")
                                            )
                                        )
                                    )
                                }
                            )
                        ),
                        statements: CodeBlockItemListSyntax {
                            // Bundle.main
                            MemberAccessExprSyntax(
                                base: DeclReferenceExprSyntax(baseName: "Bundle"),
                                name: "main"
                            )
                        }
                    )

                    // case .atURL(let url):
                    SwitchCaseSyntax(
                        label: .case(
                            SwitchCaseLabelSyntax(
                                caseItems: SwitchCaseItemListSyntax {
                                    SwitchCaseItemSyntax(
                                        pattern: ExpressionPatternSyntax(
                                            expression: FunctionCallExprSyntax(
                                                calledExpression: MemberAccessExprSyntax(
                                                    declName: DeclReferenceExprSyntax(baseName: "atURL")
                                                ),
                                                leftParen: .leftParenToken(),
                                                rightParen: .rightParenToken()
                                            ) {
                                                LabeledExprSyntax(
                                                    expression: PatternExprSyntax(
                                                        pattern: ValueBindingPatternSyntax(
                                                            bindingSpecifier: .keyword(.let),
                                                            pattern: IdentifierPatternSyntax(
                                                                identifier: "url"
                                                            )
                                                        )
                                                    )
                                                )
                                            }
                                        )
                                    )
                                }
                            )
                        ),
                        statements: CodeBlockItemListSyntax {
                            // Bundle(url: url)
                            FunctionCallExprSyntax(
                                calledExpression: DeclReferenceExprSyntax(
                                    baseName: "Bundle"
                                ),
                                leftParen: .leftParenToken(),
                                rightParen: .rightParenToken()
                            ) {
                                LabeledExprSyntax(
                                    label: "url",
                                    expression: DeclReferenceExprSyntax(
                                        baseName: "url"
                                    )
                                )
                            }
                        }
                    )

                    // case .forClass(let anyClass):
                    SwitchCaseSyntax(
                        label: .case(
                            SwitchCaseLabelSyntax(
                                caseItems: SwitchCaseItemListSyntax {
                                    SwitchCaseItemSyntax(
                                        pattern: ExpressionPatternSyntax(
                                            expression: FunctionCallExprSyntax(
                                                calledExpression: MemberAccessExprSyntax(
                                                    declName: DeclReferenceExprSyntax(baseName: "forClass")
                                                ),
                                                leftParen: .leftParenToken(),
                                                rightParen: .rightParenToken()
                                            ) {
                                                LabeledExprSyntax(
                                                    expression: PatternExprSyntax(
                                                        pattern: ValueBindingPatternSyntax(
                                                            bindingSpecifier: .keyword(.let),
                                                            pattern: IdentifierPatternSyntax(
                                                                identifier: "anyClass"
                                                            )
                                                        )
                                                    )
                                                )
                                            }
                                        )
                                    )
                                }
                            )
                        ),
                        statements: CodeBlockItemListSyntax {
                            // Bundle(for: anyClass)
                            FunctionCallExprSyntax(
                                calledExpression: DeclReferenceExprSyntax(
                                    baseName: "Bundle"
                                ),
                                leftParen: .leftParenToken(),
                                rightParen: .rightParenToken()
                            ) {
                                LabeledExprSyntax(
                                    label: "for",
                                    expression: DeclReferenceExprSyntax(
                                        baseName: "anyClass"
                                    )
                                )
                            }
                        }
                    )
                }
            }
        }
    }

    func generateFoundationBundleDescriptionExtension() -> ExtensionDeclSyntax {
        ExtensionDeclSyntax(
            attributes: [
                .attribute(.init(availability: .wwdc2022))
                .with(\.trailingTrivia, .newline)
            ],
            modifiers: [
                DeclModifierSyntax(name: .keyword(.private))
            ],
            extendedType: localizedStringResourceBundleDescriptionMemberType
        ) {
            FunctionDeclSyntax(
                modifiers: [
                    DeclModifierSyntax(name: .keyword(.static))
                ],
                name: "from",
                signature: FunctionSignatureSyntax(
                    parameterClause: FunctionParameterClauseSyntax {
                        FunctionParameterSyntax(
                            firstName: "description",
                            type: localBundleDescriptionMemberType
                        )
                    },
                    returnClause: ReturnClauseSyntax(
                        type: IdentifierTypeSyntax(name: .keyword(.Self))
                    )
                )
            ) {
                SwitchExprSyntax(
                    subject: DeclReferenceExprSyntax(baseName: "description")
                ) {
                    // case .main:
                    SwitchCaseSyntax(
                        label: .case(
                            SwitchCaseLabelSyntax(
                                caseItems: SwitchCaseItemListSyntax {
                                    SwitchCaseItemSyntax(
                                        pattern: ExpressionPatternSyntax(
                                            expression: MemberAccessExprSyntax(
                                                declName: DeclReferenceExprSyntax(baseName: "main")
                                            )
                                        )
                                    )
                                }
                            )
                        ),
                        statements: CodeBlockItemListSyntax {
                            // .main
                            MemberAccessExprSyntax(
                                name: "main"
                            )
                        }
                    )

                    // case .atURL(let url):
                    SwitchCaseSyntax(
                        label: .case(
                            SwitchCaseLabelSyntax(
                                caseItems: SwitchCaseItemListSyntax {
                                    SwitchCaseItemSyntax(
                                        pattern: ExpressionPatternSyntax(
                                            expression: FunctionCallExprSyntax(
                                                calledExpression: MemberAccessExprSyntax(
                                                    declName: DeclReferenceExprSyntax(baseName: "atURL")
                                                ),
                                                leftParen: .leftParenToken(),
                                                rightParen: .rightParenToken()
                                            ) {
                                                LabeledExprSyntax(
                                                    expression: PatternExprSyntax(
                                                        pattern: ValueBindingPatternSyntax(
                                                            bindingSpecifier: .keyword(.let),
                                                            pattern: IdentifierPatternSyntax(
                                                                identifier: "url"
                                                            )
                                                        )
                                                    )
                                                )
                                            }
                                        )
                                    )
                                }
                            )
                        ),
                        statements: CodeBlockItemListSyntax {
                            // .atURL(url)
                            FunctionCallExprSyntax(
                                calledExpression: MemberAccessExprSyntax(
                                    declName: DeclReferenceExprSyntax(
                                        baseName: "atURL"
                                    )
                                ),
                                leftParen: .leftParenToken(),
                                rightParen: .rightParenToken()
                            ) {
                                LabeledExprSyntax(
                                    expression: DeclReferenceExprSyntax(
                                        baseName: "url"
                                    )
                                )
                            }
                        }
                    )

                    // case .forClass(let anyClass):
                    SwitchCaseSyntax(
                        label: .case(
                            SwitchCaseLabelSyntax(
                                caseItems: SwitchCaseItemListSyntax {
                                    SwitchCaseItemSyntax(
                                        pattern: ExpressionPatternSyntax(
                                            expression: FunctionCallExprSyntax(
                                                calledExpression: MemberAccessExprSyntax(
                                                    declName: DeclReferenceExprSyntax(baseName: "forClass")
                                                ),
                                                leftParen: .leftParenToken(),
                                                rightParen: .rightParenToken()
                                            ) {
                                                LabeledExprSyntax(
                                                    expression: PatternExprSyntax(
                                                        pattern: ValueBindingPatternSyntax(
                                                            bindingSpecifier: .keyword(.let),
                                                            pattern: IdentifierPatternSyntax(
                                                                identifier: "anyClass"
                                                            )
                                                        )
                                                    )
                                                )
                                            }
                                        )
                                    )
                                }
                            )
                        ),
                        statements: CodeBlockItemListSyntax {
                            // .forClass(anyClass)
                            FunctionCallExprSyntax(
                                calledExpression: MemberAccessExprSyntax(
                                    declName: DeclReferenceExprSyntax(
                                        baseName: "forClass"
                                    )
                                ),
                                leftParen: .leftParenToken(),
                                rightParen: .rightParenToken()
                            ) {
                                LabeledExprSyntax(
                                    expression: DeclReferenceExprSyntax(
                                        baseName: "anyClass"
                                    )
                                )
                            }
                        }
                    )
                }
            }
        }
    }

    func generateLocalizedStringResourceExtension() -> ExtensionDeclSyntax {
        ExtensionDeclSyntax(
            attributes: [
                .attribute(.init(availability: .wwdc2022))
                .with(\.trailingTrivia, .newline)
            ],
            extendedType: IdentifierTypeSyntax(name: "LocalizedStringResource")
        ) {
            // Table struct
            StructDeclSyntax(
//                leadingTrivia: typeDocumentation,
                modifiers: [
                    DeclModifierSyntax(name: accessLevel.token)
                ],
                name: structToken
            ) {
                for resource in resources {
                    resource.declaration(
                        tableName: tableName,
                        variableToken: variableToken,
                        accessLevel: accessLevel.token,
                        isLocalizedStringResource: true
                    )
                }
            }
            .with(\.trailingTrivia, .newlines(2))

            // Init
            InitializerDeclSyntax(
                modifiers: [
                    DeclModifierSyntax(name: .keyword(.private))
                ],
                signature: FunctionSignatureSyntax(
                    parameterClause: FunctionParameterClauseSyntax(
                        leftParen: .leftParenToken(),
                        rightParen: .rightParenToken()
                    ) {
                        FunctionParameterSyntax(
                            firstName: variableToken,
                            type: localTableMemberType
                        )
                    }
                )
            ) {
                FunctionCallExprSyntax(
                    calledExpression: MemberAccessExprSyntax(
                        base: DeclReferenceExprSyntax(baseName: .keyword(.`self`)),
                        name: .keyword(.`init`)
                    ),
                    leftParen: .leftParenToken(),
                    rightParen: .rightParenToken()
                ) {
                    LabeledExprSyntax(
                        label: nil,
                        expression: MemberAccessExprSyntax(
                            base: DeclReferenceExprSyntax(baseName: variableToken),
                            declName: DeclReferenceExprSyntax(baseName: "key")
                        )
                    )
                    .with(\.trailingComma, .commaToken())

                    LabeledExprSyntax(
                        label: "defaultValue",
                        expression: MemberAccessExprSyntax(
                            base: DeclReferenceExprSyntax(baseName: variableToken),
                            declName: DeclReferenceExprSyntax(baseName: "defaultValue")
                        )
                    )
                    .with(\.trailingComma, .commaToken())

                    LabeledExprSyntax(
                        label: "table",
                        expression: MemberAccessExprSyntax(
                            base: DeclReferenceExprSyntax(baseName: variableToken),
                            declName: DeclReferenceExprSyntax(baseName: "table")
                        )
                    )
                    .with(\.trailingComma, .commaToken())

                    LabeledExprSyntax(
                        label: "locale",
                        expression: MemberAccessExprSyntax(
                            base: DeclReferenceExprSyntax(baseName: variableToken),
                            declName: DeclReferenceExprSyntax(baseName: "locale")
                        )
                    )
                    .with(\.trailingComma, .commaToken())

                    LabeledExprSyntax(
                        label: "bundle",
                        colon: .colonToken(),
                        expression: FunctionCallExprSyntax(
                            calledExpression: MemberAccessExprSyntax(
                                declName: DeclReferenceExprSyntax(baseName: "from")
                            ),
                            leftParen: .leftParenToken(),
                            rightParen: .rightParenToken()
                        ) {
                            LabeledExprSyntax(
                                label: "description",
                                expression: MemberAccessExprSyntax(
                                    base: DeclReferenceExprSyntax(baseName: variableToken),
                                    declName: DeclReferenceExprSyntax(baseName: "bundle")
                                )
                            )
                        }
                    )
                }
            }
            .with(\.trailingTrivia, .newlines(2))

            // Accessor
            // internal static let localizable = Localizable()
            VariableDeclSyntax(
                modifiers: [
                    DeclModifierSyntax(name: accessLevel.token),
                    DeclModifierSyntax(name: .keyword(.static))
                ],
                .let,
                name: PatternSyntax(IdentifierPatternSyntax(identifier: variableToken)),
                initializer: InitializerClauseSyntax(
                    value: FunctionCallExprSyntax(
                        calledExpression: DeclReferenceExprSyntax(baseName: structToken),
                        leftParen: .leftParenToken(),
                        arguments: [],
                        rightParen: .rightParenToken()
                    )
                )
            )
        }
    }

    // MARK: - Helpers

    var typeDocumentation: Trivia {
        let exampleResource = resources.first(where: { $0.arguments.isEmpty })
        let exampleId = exampleResource?.identifier ?? "foo"
        let exampleValue = exampleResource?.defaultValue.first?.content ?? "bar"
        let exampleAccessor = ".\(variableToken.text).\(exampleId)"

        return [
            .docLineComment("/// Constant values for the \(tableName) Strings Catalog"),
            .newlines(1),
            .docLineComment("///"),
            .newlines(1),
            .docLineComment("/// ```swift"),
            .newlines(1),
            .docLineComment("/// // Accessing the localized value directly"),
            .newlines(1),
            .docLineComment("/// let value = String(localized: \(exampleAccessor))"),
            .newlines(1),
            .docLineComment("/// value // \"\(exampleValue.replacingOccurrences(of: "\n", with: "\\n"))\""),
            .newlines(1),
            .docLineComment("///"),
            .newlines(1),
            .docLineComment("/// // Working with SwiftUI"),
            .newlines(1),
            .docLineComment("/// Text(\(exampleAccessor))"),
            .newlines(1),
            .docLineComment("/// ```"),
            .newlines(1),
        ]
    }

    // Localizable
    var structToken: TokenSyntax {
        .identifier(SwiftIdentifier.identifier(from: tableName))
    }

    // bundleDescription
    var bundleDescriptionNameToken: TokenSyntax {
        .identifier(SwiftIdentifier.identifier(from: "BundleDescription"))
    }

    // String.Localizable
    var localTableMemberType: MemberTypeSyntax {
        MemberTypeSyntax(
            baseType: IdentifierTypeSyntax(name: "String"),
            name: structToken
        )
    }

    // String.Localizable.BundleDescription
    var localBundleDescriptionMemberType: MemberTypeSyntax {
        MemberTypeSyntax(
            baseType: localTableMemberType,
            name: bundleDescriptionNameToken
        )
    }

    // LocalizedStringResource.BundleDescription
    var localizedStringResourceBundleDescriptionMemberType: MemberTypeSyntax {
        MemberTypeSyntax(
            baseType: IdentifierTypeSyntax(name: "LocalizedStringResource"),
            name: bundleDescriptionNameToken
        )
    }

    // localizable
    var variableToken: TokenSyntax {
        .identifier(SwiftIdentifier.variableIdentifier(for: tableName))
    }

    // bundleDescription
    var bundleToken: TokenSyntax {
        .identifier("bundleDescription")
    }
}

extension StringGenerator.AccessLevel {
    var token: TokenSyntax {
        switch self {
        case .internal: .keyword(.internal)
        case .public: .keyword(.public)
        case .package: .keyword(.package)
        }
    }
}

extension Resource {
    func declaration(
        tableName: String,
        variableToken: TokenSyntax,
        accessLevel: TokenSyntax,
        isLocalizedStringResource: Bool
    ) -> DeclSyntaxProtocol {
        var modifiers = [DeclModifierSyntax(name: accessLevel)]
        if !isLocalizedStringResource {
            modifiers.append(DeclModifierSyntax(name: .keyword(.static)))
        }

        let type = if isLocalizedStringResource {
            IdentifierTypeSyntax(name: "LocalizedStringResource")
        } else {
            IdentifierTypeSyntax(name: .keyword(.Self))
        }

        return if arguments.isEmpty {
            VariableDeclSyntax(
                leadingTrivia: leadingTrivia,
                modifiers: .init(modifiers),
                bindingSpecifier: .keyword(.var),
                bindings: [
                    PatternBindingSyntax(
                        pattern: IdentifierPatternSyntax(identifier: name),
                        typeAnnotation: TypeAnnotationSyntax(type: type),
                        accessorBlock: AccessorBlockSyntax(
                            accessors: .getter(statements(
                                table: tableName,
                                variableToken: variableToken,
                                isLocalizedStringResource: isLocalizedStringResource
                            ))
                        )
                    )
                ]
            )
        } else {
            FunctionDeclSyntax(
                leadingTrivia: leadingTrivia,
                modifiers: .init(modifiers),
                name: name,
                signature: FunctionSignatureSyntax(
                    parameterClause: FunctionParameterClauseSyntax(
                        parameters: FunctionParameterListSyntax {
                            for (idx, argument) in zip(1..., arguments) {
                                if idx == arguments.count {
                                    argument.parameter
                                } else {
                                    argument.parameter.with(\.trailingComma, .commaToken())
                                }
                            }
                        }
                    ),
                    returnClause: ReturnClauseSyntax(type: type)
                ),
                body: CodeBlockSyntax(statements: statements(
                    table: tableName,
                    variableToken: variableToken,
                    isLocalizedStringResource: isLocalizedStringResource
                ))
            )
        }
    }

    var name: TokenSyntax {
        .identifier(identifier)
    }

    var leadingTrivia: Trivia {
        var trivia: Trivia = .newlines(2)

        if let commentLines = comment?.components(separatedBy: .newlines), !commentLines.isEmpty {
            for line in commentLines {
                trivia = trivia.appending(Trivia.docLineComment("/// \(line)"))
                trivia = trivia.appending(.newline)
            }
        }

        return trivia
    }

    func statements(
        table: String,
        variableToken: TokenSyntax,
        isLocalizedStringResource: Bool
    ) -> CodeBlockItemListSyntax {
        CodeBlockItemListSyntax {
            if !isLocalizedStringResource {
                FunctionCallExprSyntax(
                    calledExpression: DeclReferenceExprSyntax(
                        baseName: .keyword(.Self)
                    ),
                    leftParen: .leftParenToken(),
                    rightParen: .rightParenToken(leadingTrivia: .newline)
                ) {
                    LabeledExprSyntax(label: "key", expression: keyExpr)
                        .with(\.trailingComma, .commaToken())
                        .with(\.leadingTrivia, .newline)

                    LabeledExprSyntax(label: "defaultValue", expression: defaultValueExpr)
                        .with(\.trailingComma, .commaToken())
                        .with(\.leadingTrivia, .newline)

                    LabeledExprSyntax(
                        label: "table",
                        expression: StringLiteralExprSyntax(content: table)
                    )
                    .with(\.trailingComma, .commaToken())
                    .with(\.leadingTrivia, .newline)

                    LabeledExprSyntax(
                        label: "locale",
                        expression: MemberAccessExprSyntax(
                            period: .periodToken(),
                            name: .identifier("current")
                        )
                    )
                    .with(\.trailingComma, .commaToken())
                    .with(\.leadingTrivia, .newline)

                    LabeledExprSyntax(
                        label: "bundle",
                        expression: MemberAccessExprSyntax(
                            period: .periodToken(),
                            name: .identifier("current")
                        )
                    )
                    .with(\.leadingTrivia, .newline)
                }
            } else {
                FunctionCallExprSyntax(
                    calledExpression: DeclReferenceExprSyntax(baseName: "LocalizedStringResource"),
                    leftParen: .leftParenToken(),
                    rightParen: .rightParenToken()
                ) {
                    LabeledExprSyntax(
                        label: variableToken.text,
                        expression: FunctionCallExprSyntax(
                            calledExpression: MemberAccessExprSyntax(
                                declName: DeclReferenceExprSyntax(baseName: name)
                            ),
                            leftParen: arguments.isEmpty ? nil : .leftParenToken(),
                            rightParen: arguments.isEmpty ? nil : .rightParenToken()
                        ) {
                            for argument in arguments {
                                LabeledExprSyntax(
                                    label: argument.label,
                                    expression: DeclReferenceExprSyntax(
                                        baseName: .identifier(argument.name)
                                    )
                                )
                            }
                        }
                    )
                }
            }
        }
    }

    var keyExpr: StringLiteralExprSyntax {
        StringLiteralExprSyntax(content: key)
    }

    // TODO: Improve this
    // 1. Maybe use multiline string literals?
    // 2. Calculate the correct number of pounds to be used.
    var defaultValueExpr: StringLiteralExprSyntax {
        StringLiteralExprSyntax(
            openingPounds: .rawStringPoundDelimiter("###"),
            openingQuote: .stringQuoteToken(),
            segments: StringLiteralSegmentListSyntax(defaultValue.map(\.element)),
            closingQuote: .stringQuoteToken(),
            closingPounds: .rawStringPoundDelimiter("###")
        )
    }
}

extension Argument {
    var parameter: FunctionParameterSyntax {
        FunctionParameterSyntax(
            firstName: label.flatMap { .identifier($0) } ?? .wildcardToken(),
            secondName: .identifier(name),
            type: IdentifierTypeSyntax(name: .identifier(type))
        )
    }
}

extension StringSegment {
    var element: StringLiteralSegmentListSyntax.Element {
        switch self {
        case .string(let content):
            return .stringSegment(
                StringSegmentSyntax(
                    content: .stringSegment(
                        content.escapingForStringLiteral(usingDelimiter: "###", isMultiline: false)
                    )
                )
            )
        case .interpolation(let identifier):
            return .expressionSegment(
                ExpressionSegmentSyntax(
                    pounds: .rawStringPoundDelimiter("###"),
                    expressions: [
                        LabeledExprSyntax(
                            expression: DeclReferenceExprSyntax(
                                baseName: .identifier(identifier)
                            )
                        )
                    ]
                )
            )
        }
    }
}

// Taken from inside SwiftSyntax
private extension String {
    /// Replace literal newlines with "\r", "\n", "\u{2028}", and ASCII control characters with "\0", "\u{7}"
    func escapingForStringLiteral(usingDelimiter delimiter: String, isMultiline: Bool) -> String {
        // String literals cannot contain "unprintable" ASCII characters (control
        // characters, etc.) besides tab. As a matter of style, we also choose to
        // escape Unicode newlines like "\u{2028}" even though swiftc will allow
        // them in string literals.
        func needsEscaping(_ scalar: UnicodeScalar) -> Bool {
            if Character(scalar).isNewline {
                return true
            }

            if !scalar.isASCII || scalar.isPrintableASCII {
                return false
            }

            if scalar == "\t" {
                // Tabs need to be escaped in single-line string literals but not
                // multi-line string literals.
                return !isMultiline
            }
            return true
        }

        // Work at the Unicode scalar level so that "\r\n" isn't combined.
        var result = String.UnicodeScalarView()
        var input = self.unicodeScalars[...]
        while let firstNewline = input.firstIndex(where: needsEscaping(_:)) {
            result += input[..<firstNewline]

            result += "\\\(delimiter)".unicodeScalars
            switch input[firstNewline] {
            case "\r":
                result += "r".unicodeScalars
            case "\n":
                result += "n".unicodeScalars
            case "\t":
                result += "t".unicodeScalars
            case "\0":
                result += "0".unicodeScalars
            case let other:
                result += "u{\(String(other.value, radix: 16))}".unicodeScalars
            }
            input = input[input.index(after: firstNewline)...]
        }
        result += input

        return String(result)
    }
}

private extension Unicode.Scalar {
    /// Whether this character represents a printable ASCII character,
    /// for the purposes of pattern parsing.
    var isPrintableASCII: Bool {
        // Exclude non-printables before the space character U+20, and anything
        // including and above the DEL character U+7F.
        return self.value >= 0x20 && self.value < 0x7F
    }
}
