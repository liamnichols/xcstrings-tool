import SwiftSyntax

extension TokenSyntax {
    enum MetaType: String {
        case String
        case Int
        case UInt
        case Float
        case Double
        case StaticString
        case LocalizationValue
        case StringInterpolation
        case Locale
        case Bundle
        case BundleLocator
        case BundleDescription
        case AnyClass
        case URL
        case LocalizedStringResource
        case Argument
        case CVarArg
        case LocalizedStringKey
        case Text
        case Sendable
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
