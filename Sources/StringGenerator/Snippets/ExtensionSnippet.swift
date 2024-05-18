import SwiftSyntax
import SwiftSyntaxBuilder

struct ExtensionSnippet {
    let availability: AvailabilityArgumentListSyntax?
    let accessLevel: Keyword?
    let extendedType: any TypeSyntaxProtocol
    let members: MemberBlockItemListSyntax
}

extension ExtensionSnippet {
    init(
        availability: AvailabilityArgumentListSyntax? = nil,
        accessLevel: Keyword? = nil,
        extending extendedType: TokenSyntax,
        @MemberBlockItemListBuilder memberBlockBuilder: () throws -> MemberBlockItemListSyntax
    ) rethrows {
        self.init(
            availability: availability,
            accessLevel: accessLevel,
            extendedType: IdentifierTypeSyntax(name: extendedType),
            members: try memberBlockBuilder()
        )
    }

    init(
        availability: AvailabilityArgumentListSyntax? = nil,
        accessLevel: Keyword? = nil,
        extending tokens: [TokenSyntax],
        @MemberBlockItemListBuilder memberBlockBuilder: () throws -> MemberBlockItemListSyntax
    ) rethrows {
        self.init(
            availability: availability,
            accessLevel: accessLevel,
            extendedType: typeSyntax(from: tokens),
            members: try memberBlockBuilder()
        )
    }
}

extension ExtensionSnippet: Snippet {
    var syntax: some DeclSyntaxProtocol {
        ExtensionDeclSyntax(
            attributes: attributes,
            modifiers: modifiers,
            extendedType: extendedType,
            memberBlock: MemberBlockSyntax(
                members: members
            )
        )
        .spacingMembers()
    }

    @AttributeListBuilder
    var attributes: AttributeListSyntax {
        if let availability {
            AttributeSyntax(availability: availability)
                .with(\.trailingTrivia, .newline)
        }
    }

    @DeclModifierListBuilder
    var modifiers: DeclModifierListSyntax {
        if let accessLevel {
            DeclModifierSyntax(name: .keyword(accessLevel))
        }
    }
}
