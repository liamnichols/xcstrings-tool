import SwiftSyntax
import SwiftSyntaxBuilder

extension IfExprSyntax {
    init(
        availability: AvailabilityArgumentListSyntax,
        body: CodeBlockSyntax,
        elseBody: CodeBlockSyntax? = nil
    ) {
        self.init(
            conditions: ConditionElementListSyntax {
                AvailabilityConditionSyntax(availabilityKeyword: .poundAvailableToken(), availabilityArguments: availability)
            },
            body: body,
            elseKeyword: elseBody.flatMap { _ in .keyword(.else) },
            elseBody: elseBody.flatMap { .codeBlock($0) }
        )
    }

    init(
        availability: AvailabilityArgumentListSyntax,
        @CodeBlockItemListBuilder bodyBuilder: () -> CodeBlockItemListSyntax
    ) {
        self.init(
            availability: availability,
            body: CodeBlockSyntax(statements: bodyBuilder())
        )
    }

    init(
        availability: AvailabilityArgumentListSyntax,
        @CodeBlockItemListBuilder bodyBuilder: () -> CodeBlockItemListSyntax,
        @CodeBlockItemListBuilder elseBodyBuilder: () -> CodeBlockItemListSyntax
    ) {
        self.init(
            availability: availability,
            body: CodeBlockSyntax(statements: bodyBuilder()),
            elseBody: CodeBlockSyntax(statements: elseBodyBuilder())
        )
    }
}
