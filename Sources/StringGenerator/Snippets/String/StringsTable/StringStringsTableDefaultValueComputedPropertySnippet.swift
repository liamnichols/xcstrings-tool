import SwiftSyntax
import SwiftSyntaxBuilder

struct StringStringsTableDefaultValueComputedPropertySnippet: Snippet {
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
            StringInterpolationProtocolFactory.initializedVariable(
                named: "stringInterpolation",
                type: MemberAccessExprSyntax(
                    .type(.String), .type(.LocalizationValue), .type(.StringInterpolation)
                ),
                literalCapacity: IntegerLiteralExprSyntax(0),
                interpolationCount: MemberAccessExprSyntax("arguments", "count")
            )

            // for argument in arguments { ... }
            StringInterpolationProtocolFactory.appendFormatSpecifiableInterpolations(
                fromArguments: "arguments",
                intoVariable: "stringInterpolation"
            )

            // let makeDefaultValue = String.LocalizationValue.init(stringInterpolation:)
            StringInterpolationProtocolFactory.initializerClosure(
                named: "makeDefaultValue",
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
