import SwiftSyntax
import SwiftSyntaxBuilder

struct StringStringsTableComparisonFunctionSnippet: Snippet {
    let stringsTable: SourceFile.StringExtension.StringsTableStruct
    let leftArg: TokenSyntax = "lhs"
    let rightArg: TokenSyntax = "rhs"

    var syntax: some DeclSyntaxProtocol {
        FunctionDeclSyntax(
            modifiers: modifiers,
            name: .binaryOperator("=="),
            signature: FunctionSignatureSyntax(
                parameterClause: FunctionParameterClauseSyntax {
                    FunctionParameterSyntax(
                        firstName: leftArg,
                        type: IdentifierTypeSyntax(name: stringsTable.type)
                    )
                    FunctionParameterSyntax(
                        firstName: rightArg,
                        type: IdentifierTypeSyntax(name: stringsTable.type)
                    )
                },
                returnClause: ReturnClauseSyntax(type: .identifier(.Bool))
            ),
            body: CodeBlockSyntax(statements: body)
        )
    }

    @DeclModifierListBuilder
    var modifiers: DeclModifierListSyntax {
        DeclModifierSyntax(name: stringsTable.accessLevel.token)
        DeclModifierSyntax(name: .keyword(.static))
    }

    var body: CodeBlockItemListSyntax {
        // Array of `lhs.foo == rhs.foo`
        var comparisons = stringsTable.comparableProperties.map { property in
            InfixOperatorExprSyntax(
                leftOperand: MemberAccessExprSyntax(leftArg, property.name),
                operator: BinaryOperatorExprSyntax(operator: .binaryOperator("==")),
                rightOperand: MemberAccessExprSyntax(rightArg, property.name)
            )
        }

        var next = comparisons.removeLast()
        while !comparisons.isEmpty {
            let left = comparisons.removeLast()

            next = InfixOperatorExprSyntax(
                leftOperand: left,
                operator: BinaryOperatorExprSyntax(operator: .binaryOperator("&&")),
                rightOperand: next
            )
        }

        return [CodeBlockItemSyntax(item: .expr(ExprSyntax(next)))]
    }
}
