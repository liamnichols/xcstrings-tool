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
        from values: [String: Any],
        key: String
    ) throws -> (arguments: [Argument], sourceLocalization: String) {
        var values = values

        guard let value = values.removeValue(forKey: "NSStringLocalizedFormatKey") as? String else {
            throw ExtractionError.localizationCorrupt(
                ExtractionError.Context(
                    key: key,
                    debugDescription: "Legacy stringsdict entry is missing ‘NSStringLocalizedFormatKey‘."
                )
            )
        }

        var substitutions: [String: String] = [:]
        var labels: [String] = []
        for (name, value) in values {
            guard var dict = value as? [String: String] else {
                throw ExtractionError.localizationCorrupt(
                    ExtractionError.Context(
                        key: key,
                        debugDescription: "Nested object ‘\(name)‘ in ‘\(key)‘ is invalid type ‘\(type(of: value))‘."
                    )
                )
            }

            guard let specType = dict.removeValue(forKey: "NSStringFormatSpecTypeKey") else {
                throw ExtractionError.localizationCorrupt(
                    ExtractionError.Context(
                        key: key,
                        debugDescription: "Nested object ‘\(name)‘ in ‘\(key)‘ has not specified the ‘NSStringFormatSpecTypeKey‘ key."
                    )
                )
            }

            guard specType == "NSStringPluralRuleType" else {
                throw ExtractionError.localizationCorrupt(
                    ExtractionError.Context(
                        key: key,
                        debugDescription: "Nested object ‘\(name)‘ in ‘\(key)‘ is not a ‘NSStringPluralRuleType‘."
                    )
                )
            }

            // TODO: Figure out if we actually need this ever?
            let _ = dict.removeValue(forKey: "NSStringFormatValueTypeKey")

            guard let value = dict["other"] ?? dict["one"] ?? dict.values.first else {
                throw ExtractionError.localizationCorrupt(
                    ExtractionError.Context(
                        key: key,
                        debugDescription: "Plural substitution ‘\(name)‘ in ‘\(key)‘ does not define any variations."
                    )
                )
            }

            substitutions[name] = value
            labels.append(name)
        }

        // Parse the raw segments
        let segments = StringParser.parse(value, expandingSubstitutions: substitutions)

        // Convert the parsed arguments and labels into the correct data
        return try extract(from: segments, labels: [:], key: key)
    }
}
