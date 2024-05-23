import StringResource
import SwiftSyntax

extension PlaceholderType {
    var typeName: TokenSyntax {
        switch self {
        case .int: .type(.Int)
        case .uint: .type(.UInt)
        case .float: .type(.Float)
        case .double: .type(.Double)
        case .object: .type(.String)
        }
    }

    var caseName: TokenSyntax {
        .identifier(rawValue)
    }
}
