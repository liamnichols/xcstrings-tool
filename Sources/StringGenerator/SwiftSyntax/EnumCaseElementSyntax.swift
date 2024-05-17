import SwiftSyntax
import SwiftSyntaxBuilder

extension EnumCaseElementSyntax {
    @_disfavoredOverload
    init(name: TokenSyntax, parameters: EnumCaseParameterSyntax...) {
        self.init(
            name: name,
            parameterClause: EnumCaseParameterClauseSyntax(
                parameters: EnumCaseParameterListSyntax {
                    for parameter in parameters {
                        parameter
                    }
                }
            )
        )
    }
}
