import SwiftSyntax
import SwiftSyntaxBuilder

extension InheritanceClauseSyntax {
    init(_ types: TokenSyntax.MetaType...) {
        self.init(types)
    }

    init(_ types: [TokenSyntax.MetaType]) {
        self.init {
            for type in types {
                InheritedTypeSyntax(type: IdentifierTypeSyntax(name: .type(type)))
            }
        }
    }
}
