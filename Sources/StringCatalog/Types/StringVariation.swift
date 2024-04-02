import Foundation

public struct StringVariation: Codable {
    public var stringUnit: StringUnit

    public init(stringUnit: StringUnit) {
        self.stringUnit = stringUnit
    }
}
