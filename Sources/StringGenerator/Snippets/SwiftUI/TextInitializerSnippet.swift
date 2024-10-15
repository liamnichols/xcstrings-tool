import SwiftSyntax
import SwiftSyntaxBuilder

struct TextInitializerSnippet {
    let stringsTable: SourceFile.StringExtension.StringsTableStruct

    var variableToken: TokenSyntax {
        .identifier(stringsTable.sourceFile.tableVariableIdentifier)
    }
}

extension TextInitializerSnippet: Snippet {
    var syntax: some DeclSyntaxProtocol {
        InitializerDeclSyntax(
            leadingTrivia: leadingTrivia,
            modifiers: modifiers,
            signature: signature,
            body: body
        )
    }

    var leadingTrivia: Trivia? {
        Trivia(docComment: """
        Creates a text view that displays a localized string defined in the ‘\(stringsTable.sourceFile.tableName)‘ strings table.
        """)
    }

    @DeclModifierListBuilder
    var modifiers: DeclModifierListSyntax {
        DeclModifierSyntax(name: stringsTable.accessLevel.token)
    }

    var signature: FunctionSignatureSyntax {
        FunctionSignatureSyntax(
            parameterClause: FunctionParameterClauseSyntax(
                leftParen: .leftParenToken(),
                rightParen: .rightParenToken()
            ) {
                FunctionParameterSyntax(
                    firstName: variableToken,
                    type: typeSyntax(from: stringsTable.fullyQualifiedType)
                )
            }
        )
    }

    var body: CodeBlockSyntax {
        CodeBlockSyntax {
            // if #available(macOS 13, iOS 16, tvOS 16, watchOS 9, *) { ... }
            ifAvailableUseLocalizedStringResource
                .with(\.trailingTrivia, .newlines(2))

            StringInterpolationVariableInitializerSnippet(
                variableName: "stringInterpolation",
                type: MemberAccessExprSyntax(.type(.LocalizedStringKey), .type(.StringInterpolation)),
                literalCapacity: IntegerLiteralExprSyntax(0),
                interpolationCount: MemberAccessExprSyntax(variableToken, stringsTable.argumentsProperty.name, "count")
            )

            AppendFormatSpecifiableInterpolationsSnippet(
                argumentsEnum: stringsTable.argumentEnum,
                sequence: MemberAccessExprSyntax(variableToken, stringsTable.argumentsProperty.name),
                variableName: "stringInterpolation"
            )

            ExpressibleByStringInterpolationInitializerClosureSnippet(
                variableName: "makeKey",
                type: DeclReferenceExprSyntax(baseName: .type(.LocalizedStringKey))
            )
            .syntax
            .with(\.trailingTrivia, .newlines(2))

            VariableDeclSyntax(
                .var,
                name: "key",
                initializer: InitializerClauseSyntax(
                    value: FunctionCallExprSyntax(
                        callee: DeclReferenceExprSyntax(baseName: "makeKey")
                    ) {
                        LabeledExprSyntax(
                            expression: DeclReferenceExprSyntax(baseName: "stringInterpolation")
                        )
                    }
                )
            )
            FunctionCallExprSyntax(
                callee: MemberAccessExprSyntax(
                    base: DeclReferenceExprSyntax(baseName: "key"),
                    name: "overrideKeyForLookup"
                )
            ) {
                LabeledExprSyntax(
                    label: "using",
                    expression: MemberAccessExprSyntax(variableToken, stringsTable._keyProperty.name)
                )
            }
            .with(\.trailingTrivia, .newlines(2))

            // self.init(key, tableName: localizable.table, bundle: .from(description: localizable.bundle)
            initWithKeyTableAndBundle
        }
    }

    var ifAvailableUseLocalizedStringResource: some ExprSyntaxProtocol {
        IfExprSyntax(availability: .wwdc2022) {
            // self.init(LocalizedStringResource(localizable: localizable))
            FunctionCallExprSyntax(
                callee: MemberAccessExprSyntax("self", "init")
            ) {
                // LocalizedStringResource(localizable: localizable)
                LabeledExprSyntax(
                    expression: FunctionCallExprSyntax(
                        callee: DeclReferenceExprSyntax(baseName: .type(.LocalizedStringResource))
                    ) {
                        LabeledExprSyntax(
                            label: variableToken.text,
                            expression: DeclReferenceExprSyntax(baseName: variableToken)
                        )
                    }
                )
            }

            // return
            ReturnStmtSyntax()
        }
    }

    var initWithKeyTableAndBundle: some ExprSyntaxProtocol {
        // self.init(key, table: localizable.table, bundle: .from(description: localizable.bundle)
        FunctionCallExprSyntax(
            callee: MemberAccessExprSyntax("self", "init")
        ) {
            // key,
            LabeledExprSyntax(
                expression: DeclReferenceExprSyntax(baseName: "key")
            )

            // tableName: localizable.table,
            LabeledExprSyntax(
                label: "tableName",
                expression: MemberAccessExprSyntax(variableToken, stringsTable.tableProperty.name)
            )

            // bundle: .from(description: localizable.bundle)
            LabeledExprSyntax(
                label: "bundle",
                expression: MemberAccessExprSyntax(variableToken, stringsTable.bundleProperty.name)
            )
        }
    }
}
