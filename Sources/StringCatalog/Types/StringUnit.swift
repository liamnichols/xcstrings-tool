import Foundation

public struct StringUnit: Codable {
    public var state: StringUnitState
    public var value: String

    public init(state: StringUnitState, value: String) {
        self.state = state
        self.value = value
    }
}
