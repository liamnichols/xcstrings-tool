import Foundation

private extension String {
    func lowercaseFirst(_ n: Int) -> String {
        guard unicodeScalars.count >= n else { return self }
        return String(unicodeScalars.prefix(n)).lowercased() + String(unicodeScalars.dropFirst(n))
    }
}

extension SwiftIdentifier {
    public static func variableIdentifier(for string: String) -> String {
        let identifier = identifier(from: string)
        let uppercasedPrefix = identifier.prefix(while: \.isUppercase)

        if uppercasedPrefix.isEmpty {
            return identifier
        } else if uppercasedPrefix.unicodeScalars.count == 1 {
            // i.e "Localizable" >> "localizable" or "MyStrings" >> "myStrings"
            return identifier.lowercaseFirst(1)
        } else if uppercasedPrefix.count == identifier.count {
            // i.e "LOCALIZABLE" >> "localizable"
            return identifier.lowercased()
        } else {
            // i.e "URLStrings" >> "urlStrings" or "URLStringCollection" >> "urlStringCollection"
            return identifier.lowercaseFirst(uppercasedPrefix.unicodeScalars.count - 1)
        }
    }
}
