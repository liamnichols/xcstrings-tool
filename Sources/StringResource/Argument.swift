import Foundation

public struct Argument: Equatable {
    /// The external label to use
    public let label: String?

    /// The internal label to use
    public let name: String

    /// The type of the argument
    public let placeholderType: PlaceholderType

    public init(label: String?, name: String, placeholderType: PlaceholderType) {
        self.label = label
        self.name = name
        self.placeholderType = placeholderType
    }
}
