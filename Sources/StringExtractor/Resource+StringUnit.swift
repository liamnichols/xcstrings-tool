import Foundation
import StringCatalog
import StringResource
import SwiftIdentifier

extension Resource {
    init(key: String, comment: String?, sourceLocalization: StringLocalization) throws {
        let extracted = try Self.extract(from: sourceLocalization, key: key)
        let identifier = SwiftIdentifier.variableIdentifier(for: key)

        self.init(
            key: key,
            comment: comment,
            identifier: identifier,
            arguments: extracted.arguments,
            sourceLocalization: extracted.sourceLocalization
        )
    }

    static func extract(
        from localization: StringLocalization,
        key: String
    ) throws -> (arguments: [Argument], sourceLocalization: String) {
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

        // Calculate labels from substitutions
        let labelSequence = localization.substitutions?.map {
            ($0.value.argNum, SwiftIdentifier.variableIdentifier(for: $0.key))
        }
        let labels = Dictionary(uniqueKeysWithValues: labelSequence ?? [])

        // Convert the parsed arguments and labels into the correct data
        return try extract(from: segments, labels: labels, key: key)
    }

    private static func preferredStringUnit(
        from stringUnit: StringUnit?,
        variations: StringVariations?
    ) -> StringUnit? {
        if let stringUnit {
            return stringUnit
        }

        if let deviceVariation = variations?.device?.preferredDeviceVariation {
            return deviceVariation.stringUnit
        }

        if let pluralVariation = variations?.plural?.preferredPluralVariation {
            return pluralVariation.stringUnit
        }

        return nil
    }
}

private extension Dictionary where Key == StringVariations.DeviceKey, Value == StringVariation {
    var preferredDeviceVariation: StringVariation? {
        self[.other] ?? self.values.first
    }
}

private extension Dictionary where Key == StringVariations.PluralKey, Value == StringVariation {
    var preferredPluralVariation: StringVariation? {
        self[.other] ?? self[.one] ?? self.values.first
    }
}
