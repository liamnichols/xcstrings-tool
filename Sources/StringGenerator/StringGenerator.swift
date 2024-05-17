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
            generateStringsTableDefaultValueExtension()
            generateStringsTableArgumentValueExtension()
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
                // enum BundleDescription { ... }
                EnumDeclSyntax(name: .type(.BundleDescription)) {
                    // case main
                    EnumCaseDeclSyntax {
                        EnumCaseElementSyntax(name: "main")
                    }
                    // case atURL(URL)
                    EnumCaseDeclSyntax {
                        EnumCaseElementSyntax(
                            name: "atURL",
                            parameters: "URL"
                        )
                    }
                    // case forClass(AnyClass)
                    EnumCaseDeclSyntax {
                        EnumCaseElementSyntax(
                            name: "forClass",
                            parameters: "AnyClass"
                        )
                    }
                }
                .with(\.trailingTrivia, .newlines(2))

                // enum Argument { ... }
                EnumDeclSyntax(name: .type(.Argument)) {
                    // case object(String)
                    EnumCaseDeclSyntax {
                        EnumCaseElementSyntax(
                            name: "object",
                            parameters: "String"
                        )
                    }
                    // case int(Int)
                    EnumCaseDeclSyntax {
                        EnumCaseElementSyntax(
                            name: "int",
                            parameters: "Int"
                        )
                    }
                    // case uint(UInt)
                    EnumCaseDeclSyntax {
                        EnumCaseElementSyntax(
                            name: "uint",
                            parameters: "UInt"
                        )
                    }
                    // case double(Double)
                    EnumCaseDeclSyntax {
                        EnumCaseElementSyntax(
                            name: "double",
                            parameters: "Double"
                        )
                    }
                    // case float(Float)
                    EnumCaseDeclSyntax {
                        EnumCaseElementSyntax(
                            name: "float",
                            parameters: "Float"
                        )
                    }
                }
                .with(\.trailingTrivia, .newlines(2))

                // let key: StaticString
                VariableDeclSyntax(
                    .let,
                    name: PatternSyntax(IdentifierPatternSyntax(identifier: "key")),
                    type: TypeAnnotationSyntax(
                        type: .identifier(.StaticString)
                    )
                )
                // let arguments: [Argument]
                VariableDeclSyntax(
                    .let,
                    name: PatternSyntax(IdentifierPatternSyntax(identifier: "arguments")),
                    type: TypeAnnotationSyntax(
                        type: ArrayTypeSyntax(element: .identifier(.Argument))
                    )
                )
                // let table: String?
                VariableDeclSyntax(
                    .let,
                    name: PatternSyntax(IdentifierPatternSyntax(identifier: "table")),
                    type: TypeAnnotationSyntax(
                        type: OptionalTypeSyntax(wrappedType: .identifier(.String))
                    )
                )
                // let bundle: BundleDescription
                VariableDeclSyntax(
                    .let,
                    name: PatternSyntax(IdentifierPatternSyntax(identifier: "bundle")),
                    type: TypeAnnotationSyntax(type: .identifier(.BundleDescription))
                ).with(\.trailingTrivia, .newlines(2))

                // fileprivate init(key:arguments:table:bundle:)
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
                                firstName: "arguments",
                                type: ArrayTypeSyntax(element: .identifier(.Argument))
                            )
                            FunctionParameterSyntax(
                                firstName: "table",
                                type: OptionalTypeSyntax(wrappedType: .identifier(.String))
                            )
                            FunctionParameterSyntax(
                                firstName: "bundle",
                                type: .identifier(.BundleDescription)
                            )
                        }
                    )
                    .multiline()
                ) {
                    // self.key = key
                    InfixOperatorExprSyntax(
                        leftOperand: MemberAccessExprSyntax(.keyword(.`self`), "key"),
                        operator: AssignmentExprSyntax(),
                        rightOperand: DeclReferenceExprSyntax(baseName: "key")
                    )
                    // self.arguments = arguments
                    InfixOperatorExprSyntax(
                        leftOperand: MemberAccessExprSyntax(.keyword(.`self`), "arguments"),
                        operator: AssignmentExprSyntax(),
                        rightOperand: DeclReferenceExprSyntax(baseName: "arguments")
                    )
                    // self.table = table
                    InfixOperatorExprSyntax(
                        leftOperand: MemberAccessExprSyntax(.keyword(.`self`), "table"),
                        operator: AssignmentExprSyntax(),
                        rightOperand: DeclReferenceExprSyntax(baseName: "table")
                    )
                    // self.bundle = bundle
                    InfixOperatorExprSyntax(
                        leftOperand: MemberAccessExprSyntax(.keyword(.`self`), "bundle"),
                        operator: AssignmentExprSyntax(),
                        rightOperand: DeclReferenceExprSyntax(baseName: "bundle")
                    )
                }
            }

            // String initialiser
            // internal init(localizable: Localizable, locale: Locale? = nil) { ... }
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
        .spacingMembers()
    }

    func generateStringsTableExtension() -> ExtensionDeclSyntax {
        ExtensionDeclSyntax(
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

    func generateStringsTableDefaultValueExtension() -> ExtensionDeclSyntax {
        ExtensionDeclSyntax(
            availability: .wwdc2021,
            accessLevel: .private,
            extendedType: localTableMemberType
        ) {
            // var defaultValue: String.LocalizationValue { ... }
            VariableDeclSyntax(bindingSpecifier: .keyword(.var)) {
                PatternBindingSyntax(
                    pattern: IdentifierPatternSyntax(identifier: .identifier("defaultValue")),
                    typeAnnotation: TypeAnnotationSyntax(
                        type: MemberTypeSyntax(
                            baseType: .identifier(.String),
                            name: .type(.LocalizationValue)
                        )
                    ),
                    accessorBlock: AccessorBlockSyntax(
                        accessors: .getter(CodeBlockItemListSyntax {
                            // var stringInterpolation = String.LocalizationValue.StringInterpolation(literalCapacity: 0, interpolationCount: arguments.count)
                            VariableDeclSyntax(bindingSpecifier: .keyword(.var)) {
                                PatternBindingSyntax(
                                    pattern: IdentifierPatternSyntax(identifier: "stringInterpolation"),
                                    initializer: InitializerClauseSyntax(
                                        value: FunctionCallExprSyntax(
                                            callee: MemberAccessExprSyntax(
                                                .type(.String), .type(.LocalizationValue), .type(.StringInterpolation)
                                            )
                                        ) {
                                            // literalCapacity: 0
                                            LabeledExprSyntax(
                                                label: "literalCapacity",
                                                expression: IntegerLiteralExprSyntax(0)
                                            )
                                            // interpolationCount: arguments.count
                                            LabeledExprSyntax(
                                                label: "interpolationCount",
                                                expression: MemberAccessExprSyntax("arguments", "count")
                                            )
                                        }
                                    )
                                )
                            }

                            // for argument in arguments { ... }
                            ForStmtSyntax(
                                pattern: IdentifierPatternSyntax(identifier: "argument"),
                                sequence: DeclReferenceExprSyntax(baseName: "arguments"),
                                body: CodeBlockSyntax {
                                    // switch argument { ... }
                                    SwitchExprSyntax(subject: DeclReferenceExprSyntax(baseName: "argument")) {
                                        // case object(let object):
                                        //     stringInterpolation.appendInterpolation(string)
                                        for placeholder in String.LocalizationValue.Placeholder.allCases {
                                            // case object(let value):
                                            SwitchCaseSyntax(
                                                singleCasePattern: ExpressionPatternSyntax(
                                                    expression: FunctionCallExprSyntax(
                                                        callee: MemberAccessExprSyntax(name: placeholder.caseName)
                                                    ) {
                                                        LabeledExprSyntax(
                                                            expression: PatternExprSyntax(
                                                                pattern: ValueBindingPatternSyntax(
                                                                    bindingSpecifier: .keyword(.let),
                                                                    pattern: IdentifierPatternSyntax(
                                                                        identifier: "value"
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    }
                                                )
                                            ) {
                                                // stringInterpolation.appendInterpolation(value)
                                                FunctionCallExprSyntax(
                                                    callee: MemberAccessExprSyntax("stringInterpolation", "appendInterpolation")
                                                ) {
                                                    LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: "value"))
                                                }
                                            }
                                        }
                                    }
                                }
                            )

                            // let makeDefaultValue = String.LocalizationValue.init(stringInterpolation:)
                            VariableDeclSyntax(bindingSpecifier: .keyword(.let)) {
                                PatternBindingSyntax(
                                    pattern: IdentifierPatternSyntax(identifier: "makeDefaultValue"),
                                    initializer: InitializerClauseSyntax(
                                        value: MemberAccessExprSyntax(
                                            base: MemberAccessExprSyntax(.type(.String), .type(.LocalizationValue)),
                                            declName: DeclReferenceExprSyntax(
                                                baseName: .keyword(.`init`),
                                                argumentNames: DeclNameArgumentsSyntax(
                                                    arguments: DeclNameArgumentListSyntax {
                                                        DeclNameArgumentSyntax(name: "stringInterpolation")
                                                    }
                                                )
                                            )
                                        )
                                    )
                                )
                            }

                            // return makeDefaultValue(stringInterpolation)
                            ReturnStmtSyntax(
                                expression: FunctionCallExprSyntax(
                                    callee: DeclReferenceExprSyntax(baseName: "makeDefaultValue")
                                ) {
                                    LabeledExprSyntax(
                                        expression: DeclReferenceExprSyntax(baseName: "stringInterpolation")
                                    )
                                }
                            )
                        })
                    )
                )
            }
        }
        .spacingMembers()
    }

    func generateStringsTableArgumentValueExtension() -> ExtensionDeclSyntax {
        ExtensionDeclSyntax(
            extendedType: MemberTypeSyntax(
                baseType: localTableMemberType,
                name: .type(.Argument)
            )
        ) {
            // var value: CVarArg { ... }
            VariableDeclSyntax(bindingSpecifier: .keyword(.var)) {
                PatternBindingSyntax(
                    pattern: IdentifierPatternSyntax(identifier: .identifier("value")),
                    typeAnnotation: TypeAnnotationSyntax(
                        type: .identifier(.CVarArg)
                    ),
                    accessorBlock: AccessorBlockSyntax(
                        accessors: .getter(CodeBlockItemListSyntax {
                            // switch self { ... }
                            SwitchExprSyntax(subject: DeclReferenceExprSyntax(baseName: .keyword(.`self`))) {
                                // case object(let value):
                                //     value
                                for placeholder in String.LocalizationValue.Placeholder.allCases {
                                    // case object(let value):
                                    SwitchCaseSyntax(
                                        singleCasePattern: ExpressionPatternSyntax(
                                            expression: FunctionCallExprSyntax(
                                                callee: MemberAccessExprSyntax(name: placeholder.caseName)
                                            ) {
                                                LabeledExprSyntax(
                                                    expression: PatternExprSyntax(
                                                        pattern: ValueBindingPatternSyntax(
                                                            bindingSpecifier: .keyword(.let),
                                                            pattern: IdentifierPatternSyntax(
                                                                identifier: "value"
                                                            )
                                                        )
                                                    )
                                                )
                                            }
                                        )
                                    ) {
                                        // value
                                        DeclReferenceExprSyntax(baseName: "value")
                                    }
                                }
                            }
                        })
                    )
                )
            }
        }
    }

    func generateBundleDescriptionExtension() -> ExtensionDeclSyntax {
        ExtensionDeclSyntax(
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
                        singleCasePattern: ExpressionPatternSyntax(
                            expression: MemberAccessExprSyntax(name: "main")
                        )
                    ) {
                        // Bundle.main
                        MemberAccessExprSyntax(.type(.Bundle), "main")
                    }

                    // case .atURL(let url):
                    SwitchCaseSyntax(
                        singleCasePattern: ExpressionPatternSyntax(
                            expression: FunctionCallExprSyntax(
                                calledExpression: MemberAccessExprSyntax(name: "atURL"),
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
                    ) {
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

                    // case .forClass(let anyClass):
                    SwitchCaseSyntax(
                        singleCasePattern: ExpressionPatternSyntax(
                            expression: FunctionCallExprSyntax(
                                calledExpression: MemberAccessExprSyntax(name: "forClass"),
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
                    ) {
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
                        singleCasePattern: ExpressionPatternSyntax(
                            expression: MemberAccessExprSyntax(name: "main")
                        )
                    ) {
                        // .main
                        MemberAccessExprSyntax(name: "main")
                    }

                    // case .atURL(let url):
                    SwitchCaseSyntax(
                        singleCasePattern: ExpressionPatternSyntax(
                            expression: FunctionCallExprSyntax(
                                calledExpression: MemberAccessExprSyntax(name: "atURL"),
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
                    ) {
                        // .atURL(url)
                        FunctionCallExprSyntax(
                            calledExpression: MemberAccessExprSyntax(name: "atURL"),
                            leftParen: .leftParenToken(),
                            rightParen: .rightParenToken()
                        ) {
                            LabeledExprSyntax(
                                expression: DeclReferenceExprSyntax(baseName: "url")
                            )
                        }
                    }

                    // case .forClass(let anyClass):
                    SwitchCaseSyntax(
                        singleCasePattern: ExpressionPatternSyntax(
                            expression: FunctionCallExprSyntax(
                                calledExpression: MemberAccessExprSyntax(name: "forClass"),
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
                    ) {
                        // .forClass(anyClass)
                        FunctionCallExprSyntax(
                            calledExpression: MemberAccessExprSyntax(name: "forClass"),
                            leftParen: .leftParenToken(),
                            rightParen: .rightParenToken()
                        ) {
                            LabeledExprSyntax(
                                expression: DeclReferenceExprSyntax(baseName: "anyClass")
                            )
                        }
                    }
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
                    callee: MemberAccessExprSyntax(.keyword(.`self`), .keyword(.`init`))
                ) {
                    // localizable.key,
                    LabeledExprSyntax(
                        expression: MemberAccessExprSyntax(variableToken, "key")
                    )
                    // defaultValue: localizable.defaultValue,
                    LabeledExprSyntax(
                        label: "defaultValue",
                        expression: MemberAccessExprSyntax(variableToken, "defaultValue")
                    )
                    // table: localizable.table,
                    LabeledExprSyntax(
                        label: "table",
                        expression: MemberAccessExprSyntax(variableToken, "table")
                    )
                    // bundle: .from(description: localizable.bundle)
                    LabeledExprSyntax(
                        label: "bundle",
                        expression: FunctionCallExprSyntax(
                            calledExpression: MemberAccessExprSyntax(name: "from"),
                            leftParen: .leftParenToken(),
                            rightParen: .rightParenToken()
                        ) {
                            LabeledExprSyntax(
                                label: "description",
                                expression: MemberAccessExprSyntax(variableToken, "bundle")
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
        let exampleValue = exampleResource?.sourceLocalization ?? "bar"
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

        - Note: Using ``LocalizedStringResource.\(tableName)`` requires iOS 16/macOS 13 or later. See ``String.\(tableName)`` for a backwards compatible API.
        """)
    }

    var customTypeDocumentation: Trivia {
        let exampleResource = resources.first(where: { $0.arguments.isEmpty })
        let exampleId = exampleResource?.identifier ?? "foo"
        let exampleValue = exampleResource?.sourceLocalization ?? "bar"

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
        var docComponents: [String] = []

        if let comment {
            docComponents.append(comment)
        }

        docComponents.append("""
        ### Source Localization

        ```
        \(sourceLocalization)
        ```
        """)

        return Trivia(docComment: docComponents.joined(separator: "\n\n"))
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
                    LabeledExprSyntax(
                        label: "key",
                        expression: keyExpr
                    )
                    LabeledExprSyntax(
                        label: "arguments",
                        expression: argumentsExpr
                    )
                    LabeledExprSyntax(
                        label: "table",
                        expression: StringLiteralExprSyntax(content: table)
                    )
                    LabeledExprSyntax(
                        label: "bundle",
                        expression: MemberAccessExprSyntax(name: "current")
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
                            calledExpression: MemberAccessExprSyntax(name: name),
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

    var argumentsExpr: ArrayExprSyntax {
        ArrayExprSyntax {
            for argument in self.arguments {
                // .object(arg1)
                ArrayElementSyntax(
                    expression: FunctionCallExprSyntax(
                        callee: MemberAccessExprSyntax(name: argument.placeholderType.caseName)
                    ) {
                        LabeledExprSyntax(
                            expression: DeclReferenceExprSyntax(
                                baseName: .identifier(argument.name)
                            )
                        )
                    }
                )
            }
        }
        .multiline()
    }
}

extension Argument {
    var parameter: FunctionParameterSyntax {
        FunctionParameterSyntax(
            firstName: label.flatMap { .identifier($0) } ?? .wildcardToken(),
            secondName: .identifier(name),
            type: IdentifierTypeSyntax(name: .identifier(placeholderType.identifier))
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

private extension String.LocalizationValue.Placeholder {
    var identifier: String {
        switch self {
        case .int: "Int"
        case .uint: "UInt"
        case .float: "Float"
        case .double: "Double"
        case .object: "String"
        @unknown default: "AnyObject"
        }
    }

    var caseName: TokenSyntax {
        switch self {
        case .int: "int"
        case .uint: "uint"
        case .float: "float"
        case .double: "double"
        case .object: "object"
        @unknown default: .identifier(String(describing: self))
        }
    }

    static let allCases: [Self] = [
        .int,
        .uint,
        .float,
        .double,
        .object
    ]
}
