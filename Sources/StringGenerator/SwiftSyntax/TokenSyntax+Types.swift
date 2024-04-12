import SwiftSyntax

extension TokenSyntax {
    enum MetaType: String {
        case String
        case StaticString
        case LocalizationValue
        case Locale
        case Bundle
        case AnyClass
        case BundleDescription
        case LocalizedStringResource
    }

    static func type(_ value: MetaType) -> TokenSyntax {
        .identifier(value.rawValue)
    }
}

extension TypeSyntaxProtocol where Self == IdentifierTypeSyntax {
    static func identifier(_ value: TokenSyntax.MetaType) -> IdentifierTypeSyntax {
        IdentifierTypeSyntax(name: .type(value))
    }
}
