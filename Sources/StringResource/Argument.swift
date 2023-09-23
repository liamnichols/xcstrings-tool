import Foundation

public struct Argument: Equatable {
    /// The external label to use
    public let label: String?

    /// The internal label to use
    public let name: String

    /// The type of the argument
    public let type: String

    public init(label: String?, name: String, type: String) {
        self.label = label
        self.name = name
        self.type = type
    }
}
