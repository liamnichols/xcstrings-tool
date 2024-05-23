import Foundation
import StringResource
import SwiftBasicFormat
import SwiftIdentifier
import SwiftSyntax
import SwiftSyntaxBuilder

public struct StringGenerator {
    let sourceFile: SourceFile

    init(tableName: String, accessLevel: AccessLevel, resources: [Resource]) {
        self.sourceFile = SourceFile(tableName: tableName, accessLevel: accessLevel, resources: resources)
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
            ImportSnippet(module: .Foundation)

            ExtensionSnippet(extending: .type(.String)) {
                StringStringsTableStructSnippet(stringsTable: sourceFile.stringExtension.stringsTableStruct)
                StringInitializerSnippet(stringsTable: sourceFile.stringExtension.stringsTableStruct)
            }

            ExtensionSnippet(extending: sourceFile.stringExtension.stringsTableStruct.fullyQualifiedType) {
                for resource in sourceFile.stringExtension.stringsTableStruct.resources {
                    resource.declaration(
                        tableName: sourceFile.tableName,
                        variableToken: .identifier(sourceFile.tableVariableIdentifier),
                        accessLevel: sourceFile.accessLevel.token,
                        isLocalizedStringResource: false
                    )
                }
            }

            ExtensionSnippet(
                availability: .wwdc2021,
                accessLevel: .private,
                extending: sourceFile.stringExtension.stringsTableStruct.fullyQualifiedType
            ) {
                StringStringsTableDefaultValueComputedPropertySnippet()
            }
            
            ExtensionSnippet(
                extending: sourceFile.stringExtension.stringsTableStruct.argumentEnum.fullyQualifiedType
            ) {
                StringStringsTableArgumentValueComputedProperty()
            }

            ExtensionSnippet(
                accessLevel: .private,
                extending: sourceFile.stringExtension.stringsTableStruct.bundleDescriptionEnum.fullyQualifiedType
            ) {
                IfConfigDeclSyntax(
                    prefixOperator: "!",
                    reference: "SWIFT_PACKAGE",
                    elements: .decls(MemberBlockItemListSyntax {
                        StringStringsTableBundleLocatorClassSnippet()
                    })
                )

                StringStringsTableBundleDescriptionCurrentComputedPropertySnippet()
            }

            ExtensionSnippet(extending: .type(.Bundle)) {
                ConvertBundleDescriptionMethodSnippet.toFoundationBundle(
                    from: sourceFile.stringExtension.stringsTableStruct.bundleDescriptionEnum
                )
            }

            ExtensionSnippet(
                availability: .wwdc2022,
                accessLevel: .private,
                extending: [.type(.LocalizedStringResource), .type(.BundleDescription)]
            ) {
                ConvertBundleDescriptionMethodSnippet.toLocalizedStringResourceBundleDescription(
                    from: sourceFile.stringExtension.stringsTableStruct.bundleDescriptionEnum
                )
            }

            ExtensionSnippet(
                availability: .wwdc2022,
                extending: .type(.LocalizedStringResource)
            ) {
                LocalizedStringResourceStringsTableStructSnippet(
                    stringsTable: sourceFile.localizedStringResourceExtension.stringsTableStruct
                )

                LocalizedStringResourceInitializerSnippet(
                    stringsTable: sourceFile.stringExtension.stringsTableStruct
                )

                LocalizedStringResourceStringsTableComputedPropertySnippet(
                    sourceFile: sourceFile
                )
            }
        }
        .spacingStatements()
    }

//    func generateSwiftUI(
//        @CodeBlockItemListBuilder itemsBuilder: () throws -> CodeBlockItemListSyntax
//    ) rethrows -> some DeclSyntaxProtocol {
//        IfConfigDeclSyntax(
//            clauses: try IfConfigClauseListSyntax {
//                IfConfigClauseSyntax(
//                    poundKeyword: .poundIfToken(),
//                    condition: CanImportExprSyntax(importPath: .module(.SwiftUI)),
//                    elements: .statements(try itemsBuilder())
//                )
//            }
//        )
//    }
//
//    func generateSwiftUIImports() -> some DeclSyntaxProtocol {
//        ImportDeclSyntax(
//            path: [
//                ImportPathComponentSyntax(name: .module(.SwiftUI))
//            ]
//        )
//    }
//
//    func generateLocalizedStringKeyExtension() -> some DeclSyntaxProtocol {
//        ExtensionDeclSyntax(
//            availability: .wwdc2019,
//            extendedType: .identifier(.LocalizedStringKey)
//        ) {
//        }
//    }
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

extension StringResource.Argument {
    var parameter: FunctionParameterSyntax {
        FunctionParameterSyntax(
            firstName: label.flatMap { .identifier($0) } ?? .wildcardToken(),
            secondName: .identifier(name),
            type: IdentifierTypeSyntax(name: .identifier(placeholderType.identifier))
        )
    }
}

extension String.LocalizationValue.Placeholder {
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
