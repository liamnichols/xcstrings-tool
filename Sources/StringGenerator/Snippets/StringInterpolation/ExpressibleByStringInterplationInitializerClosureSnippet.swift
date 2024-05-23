import SwiftSyntax

struct ExpressibleByStringInterplationInitializerClosureSnippet {
    var bindingSpecifier: Keyword = .let
    let variableName: TokenSyntax
    let type: MemberAccessExprSyntax
}

extension ExpressibleByStringInterplationInitializerClosureSnippet: Snippet {
    var syntax: some DeclSyntaxProtocol {
        // let {variableName} = {type}.init(stringInterpolation:)
        VariableDeclSyntax(bindingSpecifier: .keyword(bindingSpecifier)) {
            PatternBindingSyntax(
                pattern: IdentifierPatternSyntax(identifier: variableName),
                initializer: InitializerClauseSyntax(
                    value: MemberAccessExprSyntax(
                        base: type,
                        declName: DeclReferenceExprSyntax(
                            baseName: .keyword(.`init`),
                            argumentNames: DeclNameArgumentsSyntax(
                                arguments: DeclNameArgumentListSyntax {
                                    DeclNameArgumentSyntax(name: "stringInterpolation")
                                }
                            )
                        )
                    )
                )
            )
        }
    }
}
