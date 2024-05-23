import SwiftSyntax
import SwiftSyntaxBuilder

struct StringStringsTableDefaultValueComputedPropertySnippet: Snippet {
    let stringsTable: SourceFile.StringExtension.StringsTableStruct

    var syntax: some DeclSyntaxProtocol {
        // var defaultValue: String.LocalizationValue { ... }
        VariableDeclSyntax(bindingSpecifier: .keyword(.var)) {
            PatternBindingSyntax(
                pattern: IdentifierPatternSyntax(identifier: .identifier("defaultValue")),
                typeAnnotation: typeAnnotation,
                accessorBlock: AccessorBlockSyntax(accessors: .getter(body))
            )
        }
    }

    var typeAnnotation: TypeAnnotationSyntax {
        TypeAnnotationSyntax(
            type: MemberTypeSyntax(
                baseType: .identifier(.String),
                name: .type(.LocalizationValue)
            )
        )
    }

    @CodeBlockItemListBuilder
    var body: CodeBlockItemListSyntax {
        CodeBlockItemListSyntax {
            // var stringInterpolation = String.LocalizationValue.StringInterpolation(literalCapacity: 0, interpolationCount: arguments.count)
            StringInterpolationVariableInitializerSnippet(
                variableName: "stringInterpolation",
                type: MemberAccessExprSyntax(
                    .type(.String), .type(.LocalizationValue), .type(.StringInterpolation)
                ),
                literalCapacity: IntegerLiteralExprSyntax(0),
                interpolationCount: MemberAccessExprSyntax("arguments", "count")
            )

            // for argument in arguments { ... }
            AppendFormatSpecifiableInterpolationsSnippet(
                argumentsEnum: stringsTable.argumentEnum,
                sequenceName: "arguments",
                variableName: "stringInterpolation"
            )

            // let makeDefaultValue = String.LocalizationValue.init(stringInterpolation:)
            ExpressibleByStringInterplationInitializerClosureSnippet(
                variableName: "makeDefaultValue",
                type: MemberAccessExprSyntax(
                    .type(.String), .type(.LocalizationValue)
                )
            )

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
        }
    }
}
