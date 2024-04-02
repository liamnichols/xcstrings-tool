import Foundation

public struct StringSubstitution: Codable {
    public let argNum: Int
    public let formatSpecifier: String
    public let variations: StringVariations?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.argNum = try container.decode(Int.self, forKey: .argNum)
        self.formatSpecifier = try container.decode(String.self, forKey: .formatSpecifier)
        self.variations = try container.decodeIfPresent(StringVariations.self, forKey: .variations)
    }
}
