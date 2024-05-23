import SwiftSyntax
import SwiftSyntaxBuilder

struct ConvertBundleDescriptionMethodSnippet {
    let bundleDescriptionEnum: SourceFile.StringExtension.StringsTableStruct.BundleDescriptionEnum
    let returnClause: ReturnClauseSyntax
    let statements: (SourceFile.StringExtension.StringsTableStruct.BundleDescriptionEnum.Case) -> CodeBlockItemListSyntax
}

extension ConvertBundleDescriptionMethodSnippet {
    init(
        bundleDescriptionEnum: SourceFile.StringExtension.StringsTableStruct.BundleDescriptionEnum,
        returnType: some TypeSyntaxProtocol,
        @CodeBlockItemListBuilder statementBuilder: @escaping (SourceFile.StringExtension.StringsTableStruct.BundleDescriptionEnum.Case) -> CodeBlockItemListSyntax
    ) {
        self.init(
            bundleDescriptionEnum: bundleDescriptionEnum,
            returnClause: ReturnClauseSyntax(type: returnType),
            statements: statementBuilder
        )
    }
}

extension ConvertBundleDescriptionMethodSnippet: Snippet {
    var syntax: some DeclSyntaxProtocol {
        FunctionDeclSyntax(
            modifiers: [
                DeclModifierSyntax(name: .keyword(.static))
            ],
            name: "from",
            signature: FunctionSignatureSyntax(
                parameterClause: FunctionParameterClauseSyntax {
                    FunctionParameterSyntax(
                        firstName: "description",
                        type: typeSyntax(from: bundleDescriptionEnum.fullyQualifiedType)
                    )
                },
                returnClause: returnClause
            )
        ) {
            SwitchExprSyntax(
                subject: DeclReferenceExprSyntax(baseName: "description")
            ) {
                for enumCase in bundleDescriptionEnum.cases {
                    Case(
                        enumCase: enumCase,
                        statements: statements(enumCase)
                    ).syntax
                }
            }
        }
    }
}

extension ConvertBundleDescriptionMethodSnippet {
    struct Case {
        let enumCase: SourceFile.StringExtension.StringsTableStruct.BundleDescriptionEnum.Case
        let statements: CodeBlockItemListSyntax

        var syntax: SwitchCaseSyntax {
            SwitchCaseSyntax(
                label: .case(
                    SwitchCaseLabelSyntax {
                        SwitchCaseItemSyntax(
                            pattern: ExpressionPatternSyntax(
                                expression: expression
                            )
                        )
                    }
                ),
                statements: statements
            )
        }

        var expression: any ExprSyntaxProtocol {
            FunctionCallExprSyntax(
                calledExpression: MemberAccessExprSyntax(name: enumCase.name),
                leftParen: enumCase.parameters.isEmpty ? nil : .leftParenToken(),
                rightParen: enumCase.parameters.isEmpty ? nil : .rightParenToken()
            ) {
                for (name, _) in enumCase.parameters {
                    LabeledExprSyntax(
                        expression: PatternExprSyntax(
                            pattern: ValueBindingPatternSyntax(
                                bindingSpecifier: .keyword(.let),
                                pattern: IdentifierPatternSyntax(
                                    identifier: name
                                )
                            )
                        )
                    )
                }
            }
        }
    }
}

// MARK: - Conversions
extension ConvertBundleDescriptionMethodSnippet {
    static func toFoundationBundle(
        from bundleDescriptionEnum: SourceFile.StringExtension.StringsTableStruct.BundleDescriptionEnum
    ) -> Self {
        ConvertBundleDescriptionMethodSnippet(
            bundleDescriptionEnum: bundleDescriptionEnum,
            returnType: OptionalTypeSyntax(wrappedType: .identifier(.Bundle))
        ) { enumCase in
            switch enumCase {
            case .main:
                // Bundle.main
                MemberAccessExprSyntax(.type(.Bundle), "main")
            case .atURL:
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
                            baseName: enumCase.parameters.first!.name
                        )
                    )
                }
            case .forClass:
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
                            baseName: enumCase.parameters.first!.name
                        )
                    )
                }
            }
        }
    }

    static func toLocalizedStringResourceBundleDescription(
        from bundleDescriptionEnum: SourceFile.StringExtension.StringsTableStruct.BundleDescriptionEnum
    ) -> Self {
        ConvertBundleDescriptionMethodSnippet(
            bundleDescriptionEnum: bundleDescriptionEnum,
            returnType: IdentifierTypeSyntax(name: .keyword(.Self))
        ) { enumCase in
            switch enumCase {
            case .main:
                // .main
                MemberAccessExprSyntax(name: "main")
            case .atURL:
                // .atURL(url)
                FunctionCallExprSyntax(
                    calledExpression: MemberAccessExprSyntax(name: "atURL"),
                    leftParen: .leftParenToken(),
                    rightParen: .rightParenToken()
                ) {
                    LabeledExprSyntax(
                        expression: DeclReferenceExprSyntax(baseName: enumCase.parameters.first!.name)
                    )
                }
            case .forClass:
                // .forClass(anyClass)
                FunctionCallExprSyntax(
                    calledExpression: MemberAccessExprSyntax(name: "forClass"),
                    leftParen: .leftParenToken(),
                    rightParen: .rightParenToken()
                ) {
                    LabeledExprSyntax(
                        expression: DeclReferenceExprSyntax(baseName: enumCase.parameters.first!.name)
                    )
                }
            }
        }
    }
}
