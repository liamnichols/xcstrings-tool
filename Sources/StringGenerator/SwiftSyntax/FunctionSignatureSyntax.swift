import SwiftSyntax
import SwiftSyntaxBuilder

extension FunctionSignatureSyntax {
    func multiline() -> FunctionSignatureSyntax {
        self
            .updating(\.parameterClause) { $0 = $0.multiline() }
    }
}

extension FunctionParameterClauseSyntax {
    func multiline() -> FunctionParameterClauseSyntax {
        self
            .updating(\.parameters) { parameters in
                parameters = FunctionParameterListSyntax {
                    for parameter in parameters {
                        parameter.with(\.leadingTrivia, .newline)
                    }
                }
            }
            .with(\.rightParen, .rightParenToken(leadingTrivia: .newline))
    }

    func commaSeparated() -> FunctionParameterClauseSyntax {
        self.updating(\.parameters) { parameters in
            parameters = FunctionParameterListSyntax {
                for (idx, parameter) in zip(1..., parameters) {
                    if idx == parameters.count {
                        parameter
                    } else {
                        parameter
                            .with(\.trailingComma, .commaToken())
                    }
                }
            }
        }
    }
}
