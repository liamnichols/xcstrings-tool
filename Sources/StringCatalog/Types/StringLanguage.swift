import Foundation

public struct StringLanguage: Sendable, Codable, Hashable, RawRepresentable, ExpressibleByStringLiteral, CodingKeyRepresentable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)
    }

    public static let english = Self(rawValue: "en")
}
