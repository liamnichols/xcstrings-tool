import Foundation
import StringResource

extension StringExtractor {
    static func collect(
        collector: (inout [Resource], inout [ExtractionIssue]) throws -> Void
    ) rethrows -> Result {
        var resources: [Resource] = [], issues: [ExtractionIssue] = []
        
        try collector(&resources, &issues)
        
        return (resources: resources.sorted(), issues: issues)
    }
}
