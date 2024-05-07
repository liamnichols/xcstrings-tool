import SwiftSyntax
import SwiftSyntaxBuilder

extension ExtensionDeclSyntax {
    init(
        availability: AvailabilityArgumentListSyntax? = nil,
        accessLevel: Keyword? = nil,
        extendedType: some TypeSyntaxProtocol,
        @MemberBlockItemListBuilder memberBlockBuilder: () -> MemberBlockItemListSyntax
    ) {
        let attributes = AttributeListSyntax {
            if let availability {
                .attribute(
                    AttributeSyntax(availability: availability)
                        .with(\.trailingTrivia, .newline)
                )
            }
        }

        self.init(
            attributes: attributes,
            modifiers: DeclModifierListSyntax {
                if let accessLevel {
                    DeclModifierSyntax(name: .keyword(accessLevel))
                }
            },
            extendedType: extendedType,
            memberBlock: MemberBlockSyntax(members: memberBlockBuilder())
        )
    }

    func spacingMembers(_ lineCount: Int = 2) -> ExtensionDeclSyntax {
        updating(\.memberBlock) { memberBlock in
            memberBlock = memberBlock.spacingMembers(lineCount)
        }
    }
}
