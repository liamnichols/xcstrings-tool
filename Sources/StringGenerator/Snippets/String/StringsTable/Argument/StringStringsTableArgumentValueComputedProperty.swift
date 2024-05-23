import StringResource
import SwiftSyntax
import SwiftSyntaxBuilder

struct StringStringsTableArgumentValueComputedProperty: Snippet {
    let argumentEnum: SourceFile.StringExtension.StringsTableStruct.ArgumentEnum

    var syntax: some DeclSyntaxProtocol {
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
                            for enumCase in argumentEnum.cases {
                                // case object(let value):
                                SwitchCaseSyntax(
                                    singleCasePattern: ExpressionPatternSyntax(
                                        expression: FunctionCallExprSyntax(
                                            callee: MemberAccessExprSyntax(name: enumCase.caseName)
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
