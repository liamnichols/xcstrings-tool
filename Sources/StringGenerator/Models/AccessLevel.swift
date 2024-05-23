import SwiftSyntax

public enum AccessLevel: String, CaseIterable {
    case `internal`, `public`, `package`
}

extension AccessLevel {
    public var keyword: Keyword {
        switch self {
        case .internal: .internal
        case .public: .public
        case .package: .package
        }
    }

    public var token: TokenSyntax {
        .keyword(keyword)
    }
}
