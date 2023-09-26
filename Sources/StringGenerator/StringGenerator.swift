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

            generateBundleAccessor()
                .with(\.trailingTrivia, .newlines(2))

            generateExtension()
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

    func generateBundleAccessor() -> IfConfigDeclSyntax {
        IfConfigDeclSyntax(
            clauses: [
                IfConfigClauseSyntax(
                    poundKeyword: .poundIfToken(),
                    condition: DeclReferenceExprSyntax(baseName: .identifier("SWIFT_PACKAGE")),
                    elements: .statements(CodeBlockItemListSyntax {
                        bundleDecl(".atURL(Bundle.module.bundleURL)")
                    })
                ),
                IfConfigClauseSyntax(
                    poundKeyword: .poundElseToken(),
                    elements: .statements(CodeBlockItemListSyntax {
                        ClassDeclSyntax(
                            modifiers: [
                                DeclModifierSyntax(name: .keyword(.private))
                            ],
                            name: .identifier("BundleLocator"),
                            memberBlock: MemberBlockSyntax(members: [])
                        )

                        bundleDecl(".forClass(BundleLocator.self)")
                    })
                )
            ],
            trailingTrivia: .newlines(2)
        )

    }

    func generateExtension() -> ExtensionDeclSyntax {
        ExtensionDeclSyntax(
            extendedType: IdentifierTypeSyntax(name: "LocalizedStringResource"),
            memberBlock: MemberBlockSyntax {
                // Table struct
                StructDeclSyntax(
                    leadingTrivia: typeDocumentation,
                    modifiers: [
                        DeclModifierSyntax(name: accessLevel.token)
                    ],
                    name: structToken,
                    memberBlockBuilder: {
                        for resource in resources {
                            resource.declaration(tableName: tableName, bundle: bundleToken, accessLevel: accessLevel.token)
                        }
                    },
                    trailingTrivia: .newlines(2)
                )

                // Table accessor
                VariableDeclSyntax(
                    leadingTrivia: typeDocumentation,
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
        )
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
            .docLineComment("/// value // \"\(exampleValue)\""),
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

    var structToken: TokenSyntax {
        .identifier(SwiftIdentifier.identifier(from: tableName))
    }

    var variableToken: TokenSyntax {
        .identifier(SwiftIdentifier.variableIdentifier(for: tableName))
    }

    var bundleToken: TokenSyntax {
        .identifier("bundleDescription")
    }

    func bundleDecl(_ expr: ExprSyntax) -> VariableDeclSyntax {
        VariableDeclSyntax(
            modifiers: [DeclModifierSyntax(name: .keyword(.private))],
            .let,
            name: PatternSyntax(IdentifierPatternSyntax(identifier: bundleToken)),
            type: TypeAnnotationSyntax(
                type: MemberTypeSyntax(
                    baseType: IdentifierTypeSyntax(name: .identifier("LocalizedStringResource")),
                    name: .identifier("BundleDescription")
                )
            ),
            initializer: InitializerClauseSyntax(value: expr)
        )
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
        bundle: TokenSyntax,
        accessLevel: TokenSyntax
    ) -> DeclSyntaxProtocol {
        if arguments.isEmpty {
            VariableDeclSyntax(
                leadingTrivia: leadingTrivia,
                modifiers: [
                    DeclModifierSyntax(name: accessLevel)
                ],
                bindingSpecifier: .keyword(.var),
                bindings: [
                    PatternBindingSyntax(
                        pattern: IdentifierPatternSyntax(identifier: name),
                        typeAnnotation: TypeAnnotationSyntax(type: type),
                        accessorBlock: AccessorBlockSyntax(
                            accessors: .getter(statements(table: tableName, bundle: bundle))
                        )
                    )
                ]
            )
        } else {
            FunctionDeclSyntax(
                leadingTrivia: leadingTrivia,
                modifiers: [
                    DeclModifierSyntax(name: accessLevel)
                ],
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
                body: CodeBlockSyntax(statements: statements(table: tableName, bundle: bundle))
            )
        }
    }

    var name: TokenSyntax {
        .identifier(identifier)
    }

    var type: IdentifierTypeSyntax {
        IdentifierTypeSyntax(name: .identifier("LocalizedStringResource"))
    }

    var leadingTrivia: Trivia {
        let commentTrivia: [TriviaPiece] = if let comment {
            comment
                .components(separatedBy: .newlines)
                .map { TriviaPiece.docLineComment("/// \($0)") }
        } else {
            []
        }

        return .newlines(2)
            .merging(Trivia(pieces: commentTrivia))
            .merging(.newline)
    }

    func statements(table: String, bundle: TokenSyntax) -> CodeBlockItemListSyntax {
        CodeBlockItemListSyntax {
            CodeBlockItemSyntax(
                item: .expr(
                    ExprSyntax(
                        FunctionCallExprSyntax(
                            calledExpression: DeclReferenceExprSyntax(
                                baseName: .identifier("LocalizedStringResource")
                            ),
                            leftParen: .leftParenToken(),
                            arguments: [
                                LabeledExprSyntax(label: nil, expression: keyExpr)
                                    .with(\.trailingComma, .commaToken())
                                    .with(\.leadingTrivia, .newline),
                                
                                LabeledExprSyntax(label: "defaultValue", expression: defaultValueExpr)
                                    .with(\.trailingComma, .commaToken())
                                    .with(\.leadingTrivia, .newline),
                                
                                LabeledExprSyntax(
                                    label: "table",
                                    expression: StringLiteralExprSyntax(content: table)
                                )
                                .with(\.trailingComma, .commaToken())
                                .with(\.leadingTrivia, .newline),

                                LabeledExprSyntax(
                                    label: "bundle",
                                    expression: DeclReferenceExprSyntax(baseName: bundle)
                                )
                                .with(\.leadingTrivia, .newline)
                            ],
                            rightParen: .rightParenToken(leadingTrivia: .newline)
                        )
                    )
                )
            )
        }
    }

    var keyExpr: StringLiteralExprSyntax {
        StringLiteralExprSyntax(content: key)
    }

    // TODO: Support strings with quotes...
    var defaultValueExpr: StringLiteralExprSyntax {
        StringLiteralExprSyntax(
            openingQuote: .stringQuoteToken(),
            segments: StringLiteralSegmentListSyntax(defaultValue.map(\.element)),
            closingQuote: .stringQuoteToken()
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
            return .stringSegment(StringSegmentSyntax(content: .stringSegment(content)))
        case .interpolation(let identifier):
            return .expressionSegment(
                ExpressionSegmentSyntax(
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
