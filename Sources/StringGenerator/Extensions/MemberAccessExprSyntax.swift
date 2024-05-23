import SwiftSyntax

extension MemberAccessExprSyntax {
    init(_ firstIdentifier: TokenSyntax, _ otherIdentifiers: TokenSyntax...) {
        var identifiers = [firstIdentifier] + otherIdentifiers
        precondition(identifiers.count >= 2)

        self.init(
            declName: DeclReferenceExprSyntax(baseName: identifiers.removeLast()),
            identifiers: identifiers
        )
    }

    private init(declName: DeclReferenceExprSyntax, identifiers: [TokenSyntax]) {
        var identifiers = identifiers

        switch identifiers.count {
        case 0:
            preconditionFailure()
        case 1:
            self.init(
                base: DeclReferenceExprSyntax(baseName: identifiers.removeLast()),
                declName: declName
            )
        default:
            self.init(
                base: MemberAccessExprSyntax(
                    declName: DeclReferenceExprSyntax(baseName: identifiers.removeLast()),
                    identifiers: identifiers
                ),
                declName: declName
            )
        }
    }
}
