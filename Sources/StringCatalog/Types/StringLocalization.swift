import Foundation

public struct StringLocalization: Codable {
    public var stringUnit: StringUnit?
    public var substitutions: [String: StringSubstitution]?
    public var variations: StringVariations?

    public init(stringUnit: StringUnit? = nil, substitutions: [String : StringSubstitution]? = nil, variations: StringVariations? = nil) {
        self.stringUnit = stringUnit
        self.substitutions = substitutions
        self.variations = variations
    }
}
