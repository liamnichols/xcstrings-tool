import SwiftSyntax
import SwiftSyntaxBuilder

struct StringStringsTableArgumentEnumSnippet: Snippet {
    let argument: SourceFile.StringExtension.StringsTableStruct.ArgumentEnum

    var syntax: some DeclSyntaxProtocol {
        EnumDeclSyntax(name: argument.type, inheritanceClause: inheritanceClause) {
            MemberBlockItemListSyntax {
                for enumCase in argument.cases {
                    Case(enumCase: enumCase)
                }
            }
            .with(\.trailingTrivia, .newlines(2))

            StringStringsTableArgumentValueComputedProperty(
                argumentEnum: argument
            )
        }
    }

    var inheritanceClause: InheritanceClauseSyntax? {
        InheritanceClauseSyntax(.Sendable)
    }
}

extension StringStringsTableArgumentEnumSnippet {
    struct Case: Snippet {
        let enumCase: SourceFile.StringExtension.StringsTableStruct.ArgumentEnum.Case

        var syntax: some DeclSyntaxProtocol {
            EnumCaseDeclSyntax {
                EnumCaseElementSyntax(
                    name: enumCase.caseName,
                    parameterClause: EnumCaseParameterClauseSyntax(
                        parameters: EnumCaseParameterListSyntax {
                            EnumCaseParameterSyntax(type: IdentifierTypeSyntax(name: enumCase.typeName))
                        }
                    )
                )
            }
        }
    }
}
