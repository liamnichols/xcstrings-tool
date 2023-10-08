import Foundation

public struct Resource: Equatable {
    /// The original key defined in the String Catalog
    public let key: String

    /// The comment provided in the String Catalog, or nil if one was not set
    public let comment: String?

    /// The sanitised identifier that will be used to access the given resource in Swift code
    public let identifier: String

    /// An array of arguments to be interpolated into the resource
    public let arguments: [Argument]

    /// The string segments that make up the string literal to be used as the default value
    public let defaultValue: [StringSegment]

    public init(
        key: String,
        comment: String?,
        identifier: String,
        arguments: [Argument],
        defaultValue: [StringSegment]
    ) {
        self.key = key
        self.comment = comment
        self.identifier = identifier
        self.arguments = arguments
        self.defaultValue = defaultValue
    }
}

extension Resource: Comparable {
    public static func < (lhs: Resource, rhs: Resource) -> Bool {
        lhs.identifier.localizedStandardCompare(rhs.identifier) == .orderedAscending
    }
}
