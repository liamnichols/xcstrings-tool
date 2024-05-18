import SwiftSyntax
import SwiftSyntaxBuilder

extension FunctionCallExprSyntax {
    func multiline() -> FunctionCallExprSyntax {
        self
            .updating(\.arguments) { arguments in
                arguments = LabeledExprListSyntax {
                    for (idx, argument) in zip(1..., arguments) {
                        if idx == arguments.count {
                            argument.with(\.leadingTrivia, .newline)
                        } else {
                            argument
                                .with(\.trailingComma, .commaToken())
                                .with(\.leadingTrivia, .newline)
                        }
                    }
                }
            }
            .with(\.rightParen, .rightParenToken(leadingTrivia: .newline))
    }
}
