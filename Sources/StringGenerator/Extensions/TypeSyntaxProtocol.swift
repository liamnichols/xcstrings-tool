import SwiftSyntax

func typeSyntax(from tokens: [TokenSyntax]) -> any TypeSyntaxProtocol {
    switch tokens.count {
    case 0:
        preconditionFailure()
    case 1:
        IdentifierTypeSyntax(name: tokens.first!)
    default:
        MemberTypeSyntax(tokens: tokens)
    }
}

extension MemberTypeSyntax {
    init(tokens: [TokenSyntax]) {
        var tokens = tokens
        precondition(tokens.count >= 2)

        self.init(name: tokens.removeLast(), remaining: tokens)
    }

    private init(name: TokenSyntax, remaining: [TokenSyntax]) {
        var tokens = remaining

        switch tokens.count {
        case 0:
            preconditionFailure()
        case 1:
            self.init(
                baseType: IdentifierTypeSyntax(name: tokens.removeLast()),
                name: name
            )
        default:
            self.init(
                baseType: MemberTypeSyntax(name: tokens.removeLast(), remaining: tokens),
                name: name
            )
        }
    }
}

