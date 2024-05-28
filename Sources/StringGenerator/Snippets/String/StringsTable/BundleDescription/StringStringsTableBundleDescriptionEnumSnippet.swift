import SwiftSyntax
import SwiftSyntaxBuilder

/// Generates the custom `BundleDescription` enum that is embedded within a ``StringsTableStruct``.
///
/// ```swift
/// enum BundleDescription {
///     case main
///     case forClass(AnyClass)
///     case atURL(URL)
/// }
/// ```
struct StringStringsTableBundleDescriptionEnumSnippet: Snippet {
    let bundleDescription: SourceFile.StringExtension.StringsTableStruct.BundleDescriptionEnum

    var syntax: some DeclSyntaxProtocol {
        EnumDeclSyntax(name: bundleDescription.type, inheritanceClause: inheritanceClause) {
            MemberBlockItemListSyntax {
                for enumCase in bundleDescription.cases {
                    Case(enumCase: enumCase)
                }
            }
            .with(\.trailingTrivia, .newlines(2))

            IfConfigDeclSyntax(
                prefixOperator: "!",
                reference: "SWIFT_PACKAGE",
                elements: .decls(MemberBlockItemListSyntax {
                    StringStringsTableBundleLocatorClassSnippet()
                })
            )
            .with(\.trailingTrivia, .newlines(2))

            StringStringsTableBundleDescriptionCurrentComputedPropertySnippet()
        }
    }

    var inheritanceClause: InheritanceClauseSyntax? {
        InheritanceClauseSyntax(.Sendable)
    }
}

extension StringStringsTableBundleDescriptionEnumSnippet {
    struct Case: Snippet {
        let enumCase: SourceFile.StringExtension.StringsTableStruct.BundleDescriptionEnum.Case

        var syntax: some DeclSyntaxProtocol {
            EnumCaseDeclSyntax {
                EnumCaseElementSyntax(
                    name: enumCase.name,
                    parameterClause: parameterClause
                )
            }
        }

        var parameterClause: EnumCaseParameterClauseSyntax? {
            if enumCase.parameters.isEmpty {
                nil
            } else {
                EnumCaseParameterClauseSyntax(
                    parameters: EnumCaseParameterListSyntax {
                        for (_, type) in enumCase.parameters {
                            EnumCaseParameterSyntax(type: IdentifierTypeSyntax(name: type))
                        }
                    }
                )
            }
        }
    }
}
