import Foundation
import StringResource
import StringValidator

extension ResourceValidator {
    static func validateResources(_ resources: [Resource], in fileURL: URL) throws {
        let issues: [ResourceValidator.Issue] = validateResources(resources)

        if issues.isEmpty {
            return
        }

        for issue in issues {
            warning(issue.description, sourceFile: fileURL)
        }

        throw Diagnostic(
            severity: .error,
            sourceFile: fileURL,
            message: String(
                AttributedString(
                    localized: "^[\(issues.count) issues](inflect: true) found while processing ‘\(fileURL.lastPathComponent)‘"
                ).characters
            )
        )
    }
}
