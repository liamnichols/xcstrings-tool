import SwiftSyntax

extension TokenSyntax {
    enum Module: String {
        case Foundation = "Foundation"
        case SwiftUI = "SwiftUI"
    }

    static func module(_ value: Module) -> TokenSyntax {
        .identifier(value.rawValue)
    }
}
