import Foundation
import StringCatalog
import StringResource
import SwiftIdentifier

extension Resource {
    init(key: String, value: Any) throws {
        let extracted = try Self.extract(from: value, key: key)
        let identifier = SwiftIdentifier.variableIdentifier(for: key)

        self.init(
            key: key,
            comment: nil, // not supported with the legacy format
            identifier: identifier,
            arguments: extracted.arguments,
            sourceLocalization: extracted.sourceLocalization
        )
    }

    static func extract(
        from value: Any,
        key: String
    ) throws -> (arguments: [Argument], sourceLocalization: String) {
        switch value {
        case let string as String:
            try extract(from: string, key: key)
        case let dictionary as [String: Any]:
            try extract(from: dictionary, key: key)
        default:
            throw ExtractionError.localizationCorrupt(
                ExtractionError.Context(
                    key: key,
                    debugDescription: """
                    Expected either a String or a plural dictionary ([String: Any]), \
                    but got ‘\(type(of: value))‘.
                    """
                )
            )
        }
    }

    static func extract(
        from value: String,
        key: String
    ) throws -> (arguments: [Argument], sourceLocalization: String) {
        try extract(
            from: StringParser.parse(value, expandingSubstitutions: [:]),
            key: key
        )
    }

    static func extract(
        from value: [String: Any],
        key: String
    ) throws -> (arguments: [Argument], sourceLocalization: String) {
        fatalError() // TODO: Implement stringsdict support
    }
}
