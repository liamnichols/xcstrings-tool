import Foundation

public struct StringExtractionState: Codable, Hashable, RawRepresentable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)
    }

    public static let manual = Self(rawValue: "manual")

    public static let automatic = Self(rawValue: "automatic")

    public static let migrated = Self(rawValue: "migrated")
}
