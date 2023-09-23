import Foundation

public struct StringUnitState: Codable, Hashable, RawRepresentable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)
    }

    public static let translated = Self(rawValue: "translated")

    public static let needsReview = Self(rawValue: "needs_review")
}
