import Foundation

public struct StringLocalization: Codable {
    public var stringUnit: StringUnit?
    public var substitutions: [String: StringSubstitution]?
    public var variations: StringVariations?
}
