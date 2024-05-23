import SwiftSyntax

struct StringInterpolationVariableInitializerSnippet {
    let variableName: TokenSyntax
    let type: MemberAccessExprSyntax
    let literalCapacity: any ExprSyntaxProtocol
    let interpolationCount: any ExprSyntaxProtocol
}

extension StringInterpolationVariableInitializerSnippet: Snippet {
    var syntax: some DeclSyntaxProtocol {
        VariableDeclSyntax(bindingSpecifier: .keyword(.var)) {
            PatternBindingSyntax(
                pattern: IdentifierPatternSyntax(identifier: variableName),
                initializer: InitializerClauseSyntax(
                    value: FunctionCallExprSyntax(
                        callee: type
                    ) {
                        // literalCapacity: {something}
                        LabeledExprSyntax(
                            label: "literalCapacity",
                            expression: literalCapacity
                        )
                        // interpolationCount: {something}
                        LabeledExprSyntax(
                            label: "interpolationCount",
                            expression: interpolationCount
                        )
                    }
                )
            )
        }
    }
}
