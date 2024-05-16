import SwiftSyntax

extension TokenSyntax {
    enum MetaType: String {
        case String
        case StaticString
        case LocalizationValue
        case StringInterpolation
        case Locale
        case Bundle
        case AnyClass
        case BundleDescription
        case LocalizedStringResource
        case Argument
        case CVarArg
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
