import Foundation

public struct StringVariationValues: RawRepresentable {
    public let rawValue: [String: StringVariation]

    public init(rawValue: [String : StringVariation]) {
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

        // Plural
        public static let zero = Self(rawValue: "zero")
        public static let one = Self(rawValue: "one")
        public static let two = Self(rawValue: "two")
        public static let few = Self(rawValue: "few")
        public static let many = Self(rawValue: "many")

        // Device
        public static let iPhone = Self(rawValue: "iphone")
        public static let iPod = Self(rawValue: "ipod")
        public static let iPad = Self(rawValue: "ipad")
        public static let appleWatch = Self(rawValue: "applewatch")
        public static let appleTV = Self(rawValue: "appletv")
        public static let appleVision = Self(rawValue: "applevision")
        public static let mac = Self(rawValue: "mac")

        // Common
        public static let other = Self(rawValue: "other")
    }

    public subscript(_ key: Key) -> StringVariation? {
        rawValue[key.rawValue]
    }
}

extension StringVariationValues: Codable {
    public init(from decoder: Decoder) throws {
        self.init(rawValue: try Dictionary<String, StringVariation>(from: decoder))
    }

    public func encode(to encoder: Encoder) throws {
        try rawValue.encode(to: encoder)
    }
}
