import StringResource
import typealias StringSource.LegacyFormat

extension StringExtractor {
    public static func extractResources(
        from legacyFormat: LegacyFormat
    ) throws -> Result {
        try collect { resources, _ in
            for (key, value) in legacyFormat {
                resources.append(try Resource(key: key, value: value))
            }
        }
    }
}
