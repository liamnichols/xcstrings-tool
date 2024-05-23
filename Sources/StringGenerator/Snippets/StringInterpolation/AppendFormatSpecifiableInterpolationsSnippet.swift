import StringResource
import SwiftSyntax

struct AppendFormatSpecifiableInterpolationsSnippet {
    let argumentsEnum: SourceFile.StringExtension.StringsTableStruct.ArgumentEnum
    let sequenceName: TokenSyntax
    let variableName: TokenSyntax
}

extension AppendFormatSpecifiableInterpolationsSnippet: Snippet {
    var syntax: some StmtSyntaxProtocol {
        ForStmtSyntax(
            pattern: IdentifierPatternSyntax(identifier: "argument"),
            sequence: DeclReferenceExprSyntax(baseName: sequenceName),
            body: CodeBlockSyntax {
                // switch argument { ... }
                SwitchExprSyntax(subject: DeclReferenceExprSyntax(baseName: "argument")) {
                    // case object(let object):
                    //     stringInterpolation.appendInterpolation(string)
                    for enumCase in argumentsEnum.cases {
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
}
