import Foundation

public struct StringVariations: RawRepresentable {
    public let rawValue: [String: StringVariationValues]

    public init(rawValue: [String: StringVariationValues]) {
        self.rawValue = rawValue
    }

    public struct Key: Codable, Hashable, RawRepresentable, ExpressibleByStringLiteral {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(stringLiteral value: StringLiteralType) {
            self.init(rawValue: value)
        }

        /// A key for device variations
        public static let device = Self(rawValue: "device")

        /// A key for plural rule variations
        public static let plural = Self(rawValue: "plural")
    }

    /// Returns variation values based on the underlying raw data for a given key
    public subscript(_ key: Key) -> StringVariationValues {
        rawValue[key.rawValue] ?? StringVariationValues(rawValue: [:])
    }
}

extension StringVariations: Codable {
    public init(from decoder: Decoder) throws {
        self.init(rawValue: try Dictionary<String, StringVariationValues>(from: decoder))
    }

    public func encode(to encoder: Encoder) throws {
        try rawValue.encode(to: encoder)
    }
}
