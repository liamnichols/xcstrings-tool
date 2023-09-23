// https://github.com/SwiftGen/SwiftGen/blob/stable/Sources/SwiftGenKit/Parsers/Strings/PlaceholderType.swift
enum PlaceholderType {
    case object, float, int, char, cString, pointer

    /// Create an instance using a formatSpecifier 
    init?(formatSpecifier: some StringProtocol) {
        // By using `.last`, we are dropping any potential length info
        switch formatSpecifier.last {
        case "@":
            self = .object
        case "a", "e", "f", "g":
            self = .float
        case "d", "i", "o", "u", "x":
            self = .int
        case "c":
            self = .char
        case "s":
            self = .cString
        case "p":
            self = .pointer
        default:
            return nil
        }
    }

    var type: String {
        switch self {
        case .object: "String"
        case .float: "Double"
        case .int: "Int"
        case .char: "CChar"
        case .cString: "UnsafePointer<CChar>"
        case .pointer: "UnsafeRawPointer"
        }
    }
}
