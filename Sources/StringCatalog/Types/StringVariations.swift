import Foundation

public struct StringVariations: Codable {
    public let device: DictionaryWrapper<DeviceKey, StringVariation>?
    public let plural: DictionaryWrapper<PluralKey, StringVariation>?
}

extension StringVariations {
    public struct DeviceKey: Codable, Hashable, RawRepresentable, ExpressibleByStringLiteral {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(stringLiteral value: StringLiteralType) {
            self.init(rawValue: value)
        }

        public static let iPhone = Self(rawValue: "iphone")
        public static let iPod = Self(rawValue: "ipod")
        public static let iPad = Self(rawValue: "ipad")
        public static let appleWatch = Self(rawValue: "applewatch")
        public static let appleTV = Self(rawValue: "appletv")
        public static let appleVision = Self(rawValue: "applevision")
        public static let mac = Self(rawValue: "mac")
        public static let other = Self(rawValue: "other")
    }

    public struct PluralKey: Codable, Hashable, RawRepresentable, ExpressibleByStringLiteral {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(stringLiteral value: StringLiteralType) {
            self.init(rawValue: value)
        }

        public static let zero = Self(rawValue: "zero")
        public static let one = Self(rawValue: "one")
        public static let two = Self(rawValue: "two")
        public static let few = Self(rawValue: "few")
        public static let many = Self(rawValue: "many")
        public static let other = Self(rawValue: "other")
    }
}
