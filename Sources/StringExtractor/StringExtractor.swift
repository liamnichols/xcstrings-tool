import StringCatalog
import StringResource

public struct StringExtractor {
    public typealias Result = (resources: [Resource], issues: [ExtractionIssue])

    public static func extractResources(
        from catalog: StringCatalog
    ) throws -> Result {
        var resources: [Resource] = [], issues: [ExtractionIssue] = []

        for (key, value) in catalog.strings {
            // Retrieve the source localization for the given key. If it's missing, we skip it
            guard let localization = value.localizations?[catalog.sourceLanguage] else {
                issues.append(ExtractionIssue(key: key, reason: .missingSourceLocalization(catalog.sourceLanguage)))
                continue
            }

            // Only process manual strings
            guard value.extractionState == .manual else {
                issues.append(ExtractionIssue(key: key, reason: .wrongExtractionState(value.extractionState)))
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

        return (
            resources: resources.sorted { $0.identifier.localizedStandardCompare($1.identifier) == .orderedAscending },
            issues: issues
        )
    }
}
