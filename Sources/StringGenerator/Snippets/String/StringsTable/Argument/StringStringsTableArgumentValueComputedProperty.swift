import SwiftSyntax
import SwiftSyntaxBuilder

struct StringStringsTableArgumentValueComputedProperty: Snippet {
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
