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
            generateStringExtension()
            generateStringsTableExtension()
            generateBundleDescriptionExtension()
            generateBundleExtension()
            generateFoundationBundleDescriptionExtension()
            generateLocalizedStringResourceExtension()
        }
        .spacingStatements()
    }

    // MARK: - Source File Contents

    func generateImports() -> ImportDeclSyntax {
        ImportDeclSyntax(
            path: [
                ImportPathComponentSyntax(name: .import(.Foundation))
            ]
        )
    }

    func generateStringExtension() -> ExtensionDeclSyntax {
        ExtensionDeclSyntax(
            availability: .wwdc2021,
            extendedType: .identifier(.String)
        ) {
            // Table struct
            StructDeclSyntax(
                leadingTrivia: customTypeDocumentation,
                modifiers: [
                    DeclModifierSyntax(name: accessLevel.token)
                ],
                name: structToken
            ) {
                // BundleDescription
                EnumDeclSyntax(
                    modifiers: [
                        DeclModifierSyntax(name: .keyword(.fileprivate))
                    ],
                    name: .type(.BundleDescription),
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
                        DeclModifierSyntax(name: .keyword(.fileprivate)),
                    ],
                    .let,
                    name: PatternSyntax(IdentifierPatternSyntax(identifier: "key")),
                    type: TypeAnnotationSyntax(
                        type: .identifier(.StaticString)
                    )
                )
                VariableDeclSyntax(
                    modifiers: [
                        DeclModifierSyntax(name: .keyword(.fileprivate)),
                    ],
                    .let,
                    name: PatternSyntax(IdentifierPatternSyntax(identifier: "defaultValue")),
                    type: TypeAnnotationSyntax(type: .identifier(.LocalizationValue))
                )
                VariableDeclSyntax(
                    modifiers: [
                        DeclModifierSyntax(name: .keyword(.fileprivate)),
                    ],
                    .let,
                    name: PatternSyntax(IdentifierPatternSyntax(identifier: "table")),
                    type: TypeAnnotationSyntax(
                        type: OptionalTypeSyntax(wrappedType: .identifier(.String))
                    )
                )
                VariableDeclSyntax(
                    modifiers: [
                        DeclModifierSyntax(name: .keyword(.fileprivate)),
                    ],
                    .let,
                    name: PatternSyntax(IdentifierPatternSyntax(identifier: "locale")),
                    type: TypeAnnotationSyntax(type: .identifier(.Locale))
                )
                VariableDeclSyntax(
                    modifiers: [
                        DeclModifierSyntax(name: .keyword(.fileprivate)),
                    ],
                    .let,
                    name: PatternSyntax(IdentifierPatternSyntax(identifier: "bundle")),
                    type: TypeAnnotationSyntax(type: .identifier(.BundleDescription))
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
                                type: .identifier(.StaticString)
                            )
                            FunctionParameterSyntax(
                                firstName: "defaultValue",
                                type: .identifier(.LocalizationValue)
                            )
                            FunctionParameterSyntax(
                                firstName: "table",
                                type: OptionalTypeSyntax(wrappedType: .identifier(.String))
                            )
                            FunctionParameterSyntax(
                                firstName: "locale",
                                type: .identifier(.Locale)
                            )
                            FunctionParameterSyntax(
                                firstName: "bundle",
                                type: .identifier(.BundleDescription)
                            )
                        }
                    )
                    .multiline()
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
            }

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
                    callee: MemberAccessExprSyntax(
                        base: DeclReferenceExprSyntax(baseName: .keyword(.`self`)),
                        name: .keyword(.`init`)
                    )
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
                .multiline()
            }
        }
        .spacingMembers()
    }

    func generateStringsTableExtension() -> ExtensionDeclSyntax {
        ExtensionDeclSyntax(
            availability: .wwdc2021,
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
        .spacingMembers()
    }

    func generateBundleDescriptionExtension() -> ExtensionDeclSyntax {
        ExtensionDeclSyntax(
            availability: .wwdc2021,
            accessLevel: .private,
            extendedType: localBundleDescriptionMemberType
        ) {
            IfConfigDeclSyntax(
                prefixOperator: "!",
                reference: "SWIFT_PACKAGE",
                elements: .decls([
                    .init(decl: DeclSyntax("private class BundleLocator {}"))
                ])
            )

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
        .spacingMembers()
    }

    func generateBundleExtension() -> ExtensionDeclSyntax {
        ExtensionDeclSyntax(
            availability: .wwdc2021,
            accessLevel: .private,
            extendedType: .identifier(.Bundle)
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
                            wrappedType: .identifier(.Bundle)
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
                                base: DeclReferenceExprSyntax(baseName: .type(.Bundle)),
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
                                    baseName: .type(.Bundle)
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
                                    baseName: .type(.Bundle)
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
        .spacingMembers()
    }

    func generateFoundationBundleDescriptionExtension() -> ExtensionDeclSyntax {
        ExtensionDeclSyntax(
            availability: .wwdc2022,
            accessLevel: .private,
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
        .spacingMembers()
    }

    func generateLocalizedStringResourceExtension() -> ExtensionDeclSyntax {
        ExtensionDeclSyntax(
            availability: .wwdc2022,
            extendedType: .identifier(.LocalizedStringResource)
        ) {
            // Table struct
            StructDeclSyntax(
                leadingTrivia: typeDocumentation,
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
            .spacingMembers()

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
                    callee: MemberAccessExprSyntax(
                        base: DeclReferenceExprSyntax(baseName: .keyword(.`self`)),
                        name: .keyword(.`init`)
                    )
                ) {
                    LabeledExprSyntax(
                        label: nil,
                        expression: MemberAccessExprSyntax(
                            base: DeclReferenceExprSyntax(baseName: variableToken),
                            declName: DeclReferenceExprSyntax(baseName: "key")
                        )
                    )

                    LabeledExprSyntax(
                        label: "defaultValue",
                        expression: MemberAccessExprSyntax(
                            base: DeclReferenceExprSyntax(baseName: variableToken),
                            declName: DeclReferenceExprSyntax(baseName: "defaultValue")
                        )
                    )

                    LabeledExprSyntax(
                        label: "table",
                        expression: MemberAccessExprSyntax(
                            base: DeclReferenceExprSyntax(baseName: variableToken),
                            declName: DeclReferenceExprSyntax(baseName: "table")
                        )
                    )

                    LabeledExprSyntax(
                        label: "locale",
                        expression: MemberAccessExprSyntax(
                            base: DeclReferenceExprSyntax(baseName: variableToken),
                            declName: DeclReferenceExprSyntax(baseName: "locale")
                        )
                    )

                    LabeledExprSyntax(
                        label: "bundle",
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
                .multiline()
            }

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
        .spacingMembers()
    }

    // MARK: - Helpers

    var typeDocumentation: Trivia {
        let exampleResource = resources.first(where: { $0.arguments.isEmpty })
        let exampleId = exampleResource?.identifier ?? "foo"
        let exampleValue = exampleResource?.defaultValue.first?.content ?? "bar"
        let exampleAccessor = ".\(variableToken.text).\(exampleId)"

        return Trivia(docComment: """
        Constant values for the \(tableName) Strings Catalog

        ```swift
        // Accessing the localized value directly
        let value = String(localized: \(exampleAccessor))
        value // \"\(exampleValue.replacingOccurrences(of: "\n", with: "\\n"))\"

        // Working with SwiftUI
        Text(\(exampleAccessor))
        ```

        - Note: Using ``LocalizedStringResource.\(tableName)`` requires iOS 16/macOS 13 or later. See ``String.\(tableName)`` for an iOS 15/macOS 12 compatible API.
        """)
    }

    var customTypeDocumentation: Trivia {
        let exampleResource = resources.first(where: { $0.arguments.isEmpty })
        let exampleId = exampleResource?.identifier ?? "foo"
        let exampleValue = exampleResource?.defaultValue.first?.content ?? "bar"

        return Trivia(docComment: """
        Constant values for the \(tableName) Strings Catalog

        ```swift
        // Accessing the localized value directly
        let value = String(\(variableToken.text): .\(exampleId))
        value // \"\(exampleValue.replacingOccurrences(of: "\n", with: "\\n"))\"
        ```
        """)
    }

    // Localizable
    var structToken: TokenSyntax {
        .identifier(SwiftIdentifier.identifier(from: tableName))
    }

    // String.Localizable
    var localTableMemberType: MemberTypeSyntax {
        MemberTypeSyntax(
            baseType: .identifier(.String),
            name: structToken
        )
    }

    // String.Localizable.BundleDescription
    var localBundleDescriptionMemberType: MemberTypeSyntax {
        MemberTypeSyntax(
            baseType: localTableMemberType,
            name: .type(.BundleDescription)
        )
    }

    // LocalizedStringResource.BundleDescription
    var localizedStringResourceBundleDescriptionMemberType: MemberTypeSyntax {
        MemberTypeSyntax(
            baseType: .identifier(.LocalizedStringResource),
            name: .type(.BundleDescription)
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

        let type: IdentifierTypeSyntax = if isLocalizedStringResource {
            .identifier(.LocalizedStringResource)
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
                    parameterClause: FunctionParameterClauseSyntax {
                        for argument in arguments {
                            argument.parameter
                        }
                    }.commaSeparated(),
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
        var trivia: Trivia = .init(pieces: [])

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
                    callee: DeclReferenceExprSyntax(
                        baseName: .keyword(.Self)
                    )
                ) {
                    LabeledExprSyntax(label: "key", expression: keyExpr)

                    LabeledExprSyntax(label: "defaultValue", expression: defaultValueExpr)

                    LabeledExprSyntax(
                        label: "table",
                        expression: StringLiteralExprSyntax(content: table)
                    )

                    LabeledExprSyntax(
                        label: "locale",
                        expression: MemberAccessExprSyntax(
                            name: .identifier("current")
                        )
                    )

                    LabeledExprSyntax(
                        label: "bundle",
                        expression: MemberAccessExprSyntax(
                            name: .identifier("current")
                        )
                    )
                }
                .multiline()
            } else {
                FunctionCallExprSyntax(
                    callee: DeclReferenceExprSyntax(
                        baseName: .type(.LocalizedStringResource)
                    )
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

extension Trivia {
    init(docComment: String) {
        self = docComment
            .components(separatedBy: .newlines)
            .map { "/// \($0)" }
            .map { [.docLineComment($0.trimmingCharacters(in: .whitespaces)), .newlines(1)] }
            .reduce([], +)
    }
}
