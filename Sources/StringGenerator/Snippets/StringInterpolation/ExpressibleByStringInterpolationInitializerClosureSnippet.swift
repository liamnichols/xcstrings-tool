import SwiftSyntax

struct ExpressibleByStringInterpolationInitializerClosureSnippet<T: ExprSyntaxProtocol> {
    var bindingSpecifier: Keyword = .let
    let variableName: TokenSyntax
    let type: T
}

extension ExpressibleByStringInterpolationInitializerClosureSnippet: Snippet {
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
