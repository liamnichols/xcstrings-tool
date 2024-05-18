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
    let bundleDescription: BundleDescription

    var syntax: some DeclSyntaxProtocol {
        EnumDeclSyntax(name: bundleDescription.token) {
            for enumCase in bundleDescription.cases {
                Case(model: enumCase)
            }
        }
    }
}

extension StringStringsTableBundleDescriptionEnumSnippet {
    struct Case: Snippet {
        let model: BundleDescription.Case

        var syntax: some DeclSyntaxProtocol {
            EnumCaseDeclSyntax {
                EnumCaseElementSyntax(
                    name: model.name,
                    parameterClause: parameterClause
                )
            }
        }

        var parameterClause: EnumCaseParameterClauseSyntax? {
            if model.parameters.isEmpty {
                nil
            } else {
                EnumCaseParameterClauseSyntax(
                    parameters: EnumCaseParameterListSyntax {
                        for (_, type) in model.parameters {
                            EnumCaseParameterSyntax(type: IdentifierTypeSyntax(name: type))
                        }
                    }
                )
            }
        }
    }
}
