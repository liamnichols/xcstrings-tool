import SwiftSyntax

extension TokenSyntax {
    enum Import: String {
        case Foundation = "Foundation"
    }

    static func `import`(_ value: Import) -> TokenSyntax {
        .identifier(value.rawValue)
    }
}
