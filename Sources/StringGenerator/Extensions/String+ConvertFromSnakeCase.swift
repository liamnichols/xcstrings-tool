extension String {
    /// Converts snake case joins to camel case joins
    func snakeCaseConverted(_ convert: Bool) -> String {
        convert ? convertFromSnakeCase(self) : self
    }
}

// From: https://github.com/swiftlang/swift-foundation/blob/4d74f7a425b3edb48ebec04105a06eb99771a519/Sources/FoundationEssentials/JSON/JSONDecoder.swift#L121-L165
// Modified to assume components separated by underscore is already camel case
fileprivate func convertFromSnakeCase(_ stringKey: String) -> String {
    guard !stringKey.isEmpty else { return stringKey }

    // Find the first non-underscore character
    guard let firstNonUnderscore = stringKey.firstIndex(where: { $0 != "_" }) else {
        // Reached the end without finding an _
        return stringKey
    }

    // Find the last non-underscore character
    var lastNonUnderscore = stringKey.index(before: stringKey.endIndex)
    while lastNonUnderscore > firstNonUnderscore && stringKey[lastNonUnderscore] == "_" {
        stringKey.formIndex(before: &lastNonUnderscore)
    }

    let keyRange = firstNonUnderscore...lastNonUnderscore
    let leadingUnderscoreRange = stringKey.startIndex..<firstNonUnderscore
    let trailingUnderscoreRange = stringKey.index(after: lastNonUnderscore)..<stringKey.endIndex

    let components = stringKey[keyRange].split(separator: "_")
    let joinedString: String
    if components.count == 1 {
        // No underscores in key, leave the word as is - maybe already camel cased
        joinedString = String(stringKey[keyRange])
    } else {
        // Create a camel cased join with components as-is, i.e. don't lowercase them before joining
        joinedString = ([String(components[0])] + components[1...].map {
            guard let first = $0.unicodeScalars.first else { return String($0) }
            return String(first).uppercased() + String($0.unicodeScalars.dropFirst())
        }).joined()
    }

    // Do a cheap isEmpty check before creating and appending potentially empty strings
    let result: String
    if (leadingUnderscoreRange.isEmpty && trailingUnderscoreRange.isEmpty) {
        result = joinedString
    } else if (!leadingUnderscoreRange.isEmpty && !trailingUnderscoreRange.isEmpty) {
        // Both leading and trailing underscores
        result = String(stringKey[leadingUnderscoreRange]) + joinedString + String(stringKey[trailingUnderscoreRange])
    } else if (!leadingUnderscoreRange.isEmpty) {
        // Just leading
        result = String(stringKey[leadingUnderscoreRange]) + joinedString
    } else {
        // Just trailing
        result = joinedString + String(stringKey[trailingUnderscoreRange])
    }
    return result
}
