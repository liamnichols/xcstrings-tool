import Foundation

private extension String {
    var lowercaseFirst: String {
        guard let first = unicodeScalars.first else { return self }
        return String(first).lowercased() + String(unicodeScalars.dropFirst())
    }
}

extension SwiftIdentifier {
    public static func variableIdentifier(for string: String) -> String {
        identifier(from: string).lowercaseFirst
    }
}
