import SwiftSyntax
import SwiftSyntaxBuilder

enum StringInterpolationProtocolFactory {
    static func initializedVariable(
        named variableName: TokenSyntax,
        type: MemberAccessExprSyntax,
        literalCapacity: some ExprSyntaxProtocol,
        interpolationCount: some ExprSyntaxProtocol
    ) -> VariableDeclSyntax {
        VariableDeclSyntax(bindingSpecifier: .keyword(.var)) {
            PatternBindingSyntax(
                pattern: IdentifierPatternSyntax(identifier: variableName),
                initializer: InitializerClauseSyntax(
                    value: FunctionCallExprSyntax(
                        callee: type
                    ) {
                        // literalCapacity: {something}
                        LabeledExprSyntax(
                            label: "literalCapacity",
                            expression: literalCapacity
                        )
                        // interpolationCount: {something}
                        LabeledExprSyntax(
                            label: "interpolationCount",
                            expression: interpolationCount
                        )
                    }
                )
            )
        }
    }

    static func appendFormatSpecifiableInterpolations(
        fromArguments sequenceName: TokenSyntax,
        intoVariable variableName: TokenSyntax
    ) -> ForStmtSyntax {
        ForStmtSyntax(
            pattern: IdentifierPatternSyntax(identifier: "argument"),
            sequence: DeclReferenceExprSyntax(baseName: sequenceName),
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
                                callee: MemberAccessExprSyntax(variableName, "appendInterpolation")
                            ) {
                                LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: "value"))
                            }
                        }
                    }
                }
            }
        )
    }

    // let {variableName} = {type}.init(stringInterpolation:)
    static func initializerClosure(
        bindingSpecifier: Keyword = .let,
        named variableName: TokenSyntax,
        type: MemberAccessExprSyntax
    ) -> VariableDeclSyntax {
        VariableDeclSyntax(bindingSpecifier: .keyword(bindingSpecifier)) {
            PatternBindingSyntax(
                pattern: IdentifierPatternSyntax(identifier: variableName),
                initializer: InitializerClauseSyntax(
                    value: MemberAccessExprSyntax(
                        base: type,
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
    }
}
