import Foundation
import StringCatalog
import StringResource
import SwiftIdentifier

extension StringCatalog {
    /// A sorted array of resources that can be extracted from the given catalog
    public var resources: [Resource] {
        get throws {
            var resources: [Resource] = []

            for (key, value) in strings {
                // Only process manual strings
                guard case .manual = value.extractionState else {
                    continue
                }

                // Retrieve the source localization for the given key. If it's missing, we skip it
                guard let localization = value.localizations[sourceLanguage] else {
                    continue
                }

                // Attempt to process the resource from the catalog data
                resources.append(
                    try Resource(
                        key: key,
                        comment: value.comment,
                        sourceLocalization: localization
                    )
                )
            }
            
            return resources.sorted {
                $0.identifier.localizedStandardCompare($1.identifier) == .orderedAscending
            }
        }
    }
}

extension Resource {
    init(key: String, comment: String?, sourceLocalization: StringLocalization) throws {
        let extracted = try Self.extract(from: sourceLocalization, key: key)
        let identifier = SwiftIdentifier.variableIdentifier(for: key)

        self.init(
            key: key,
            comment: comment,
            identifier: identifier,
            arguments: extracted.arguments,
            defaultValue: extracted.defaultValue
        )
    }

    // TODO: Improve this a lot.
    static func sanitize(key: String) -> String {
        if let firstChar = key.first, firstChar.isUppercase {
            return firstChar.lowercased() + String(key.dropFirst())
        } else {
            return key
        }
    }

    static func extract(
        from localization: StringLocalization,
        key: String
    ) throws -> (arguments: [Argument], defaultValue: [StringSegment]) {
        guard let stringUnit = preferredStringUnit(from: localization.stringUnit, variations: localization.variations) else {
            throw ExtractionError.localizationCorrupt(
                ExtractionError.Context(
                    key: key,
                    debugDescription: "A base string unit could not be found."
                )
            )
        }

        let substitutions = try localization.substitutions?.mapValues { substitution in
            guard let stringUnit = preferredStringUnit(from: nil, variations: substitution.variations) else {
                throw ExtractionError.localizationCorrupt(
                    ExtractionError.Context(
                        key: key,
                        debugDescription: "A base string unit could not be found for the substitution."
                    )
                )
            }

            return stringUnit.value.replacingOccurrences(of: "%arg", with: "%\(substitution.formatSpecifier)")
        }

        // Parse the raw segments
        let segments = StringParser.parse(stringUnit.value, expandingSubstitutions: substitutions ?? [:])

        // Populate the default values using the raw parser result
        var arguments: [Argument] = []
        var defaultValue: [StringSegment] = []

        // Calculate labels from substitutions
        let labelSequence = localization.substitutions?.map {
            ($0.value.argNum, SwiftIdentifier.variableIdentifier(for: $0.key))
        } ?? []
        let labels = Dictionary(uniqueKeysWithValues: labelSequence)

        // Convert the parsed string into a default value and extract the arguments
        for segment in segments {
            let argNum = arguments.count + 1
            let argName = "arg\(argNum)"

            switch segment {
            case .string(let contents):
                defaultValue.append(.string(contents))
            case .placeholder(let placeholder):
                defaultValue.append(.interpolation(argName))
                arguments.append(
                    Argument(
                        label: labels[argNum],
                        name: argName,
                        type: placeholder.type
                    )
                )
            }
        }

        return (arguments, defaultValue)
    }

    private static func preferredStringUnit(
        from stringUnit: StringUnit?,
        variations: StringVariations?
    ) -> StringUnit? {
        // If there was a StringUnit, use that
        if let stringUnit {
            return stringUnit
        }

        if let variations {
            // For either devices or plurals
            for values in variations.rawValue.values {
                // First try using the 'other' variation as this is most common
                if let other = values[.other] {
                    return other.stringUnit
                }

                // Otherwise try the 'one' assuming that this might be plural variations
                if let one = values[.one] {
                    return one.stringUnit
                }

                // Failing that, just return any value in this set if there are any
                if let first = values.rawValue.values.first {
                    return first.stringUnit
                }
            }
        }

        // No appropriate variation found
        return nil
    }
}
