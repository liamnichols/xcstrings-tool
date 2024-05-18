import SwiftSyntax
import SwiftSyntaxBuilder

struct StringStringsTableArgumentEnumSnippet: Snippet {
    let argument: Argument

    var syntax: some DeclSyntaxProtocol {
        EnumDeclSyntax(name: argument.token) {
            for enumCase in argument.cases {
                Case(model: enumCase)
            }
        }
    }
}

extension StringStringsTableArgumentEnumSnippet {
    struct Case: Snippet {
        let model: Argument.Case

        var syntax: some DeclSyntaxProtocol {
            EnumCaseDeclSyntax {
                EnumCaseElementSyntax(
                    name: model.name,
                    parameterClause: EnumCaseParameterClauseSyntax(
                        parameters: EnumCaseParameterListSyntax {
                            for parameter in model.parameters {
                                EnumCaseParameterSyntax(type: IdentifierTypeSyntax(name: parameter))
                            }
                        }
                    )
                )
            }
        }
    }
}
