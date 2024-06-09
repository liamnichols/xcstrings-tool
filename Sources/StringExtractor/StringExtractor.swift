import StringResource
import StringSource

public struct StringExtractor {
    public typealias Result = (resources: [Resource], issues: [ExtractionIssue])

    public static func extractResources(
        from source: StringSource
    ) throws -> Result {
        switch source {
        case .catalog(let stringCatalog):
            try extractResources(from: stringCatalog)
        case .legacy(let legacyFormat):
            try extractResources(from: legacyFormat)
        }
    }
}
