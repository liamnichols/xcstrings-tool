import Foundation

public enum StringSegment: Equatable {
    case string(String)
    case interpolation(String)

    public var content: String {
        switch self {
        case .string(let string): string
        case .interpolation(let string): string
        }
    }
}
