import Foundation

public struct StringSubstitution: Codable {
    public let argNum: Int
    public let formatSpecifier: String
    public let variations: StringVariations?

    public init(argNum: Int, formatSpecifier: String, variations: StringVariations?) {
        self.argNum = argNum
        self.formatSpecifier = formatSpecifier
        self.variations = variations
    }
}
