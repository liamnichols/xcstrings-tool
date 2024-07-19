import SwiftSyntax
import SwiftSyntaxBuilder

struct StringStringsTableBundleLocatorClassSnippet: Snippet {
    var syntax: some DeclSyntaxProtocol {
        ClassDeclSyntax(
            modifiers: modifiers,
            name: .type(.BundleLocator),
            memberBlock: MemberBlockSyntax(
                members: []
            )
        )
    }

    @DeclModifierListBuilder
    var modifiers: DeclModifierListSyntax {
        DeclModifierSyntax(name: .keyword(.private))
    }
}
