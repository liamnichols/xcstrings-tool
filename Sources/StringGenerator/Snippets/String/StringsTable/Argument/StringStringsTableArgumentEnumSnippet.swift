import SwiftSyntax
import SwiftSyntaxBuilder

struct StringStringsTableArgumentEnumSnippet: Snippet {
    let argument: SourceFile.StringExtension.StringsTableStruct.ArgumentEnum

    var syntax: some DeclSyntaxProtocol {
        EnumDeclSyntax(name: argument.type) {
            for enumCase in argument.cases {
                Case(enumCase: enumCase)
            }
        }
    }
}

extension StringStringsTableArgumentEnumSnippet {
    struct Case: Snippet {
        let enumCase: SourceFile.StringExtension.StringsTableStruct.ArgumentEnum.Case

        var syntax: some DeclSyntaxProtocol {
            EnumCaseDeclSyntax {
                EnumCaseElementSyntax(
                    name: enumCase.name,
                    parameterClause: EnumCaseParameterClauseSyntax(
                        parameters: EnumCaseParameterListSyntax {
                            for parameter in enumCase.parameters {
                                EnumCaseParameterSyntax(type: IdentifierTypeSyntax(name: parameter))
                            }
                        }
                    )
                )
            }
        }
    }
}
