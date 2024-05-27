import StringResource
import SwiftSyntax

struct AppendFormatSpecifiableInterpolationsSnippet<Sequence: ExprSyntaxProtocol> {
    let argumentsEnum: SourceFile.StringExtension.StringsTableStruct.ArgumentEnum
    let sequence: Sequence
    let variableName: TokenSyntax
}

extension AppendFormatSpecifiableInterpolationsSnippet where Sequence == DeclReferenceExprSyntax {
    init(
        argumentsEnum: SourceFile.StringExtension.StringsTableStruct.ArgumentEnum,
        sequenceName: TokenSyntax,
        variableName: TokenSyntax
    ) {
        self.init(
            argumentsEnum: argumentsEnum,
            sequence: DeclReferenceExprSyntax(baseName: sequenceName),
            variableName: variableName
        )
    }
}

extension AppendFormatSpecifiableInterpolationsSnippet: Snippet {
    var syntax: some StmtSyntaxProtocol {
        ForStmtSyntax(
            pattern: IdentifierPatternSyntax(identifier: "argument"),
            sequence: sequence,
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
