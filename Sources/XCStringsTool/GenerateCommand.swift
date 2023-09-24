import ArgumentParser
import Foundation
import StringExtractor
import struct StringResource.Resource
import StringCatalog
import StringGenerator
import StringValidator

struct GenerateCommand: ParsableCommand {
    @Argument(
        help: "Path to xcstrings String Catalog file",
        completion: .file(extensions: ["xcstrings"]),
        transform: { URL(filePath: $0, directoryHint: .notDirectory) }
    )
    var input

    @Argument(
        help: "Path to write generated Swift output",
        completion: .file(extensions: ["swift"]),
        transform: { URL(filePath: $0, directoryHint: .notDirectory) }
    )
    var output

    @Option(
        name: [.customShort("p"), .customLong("public")],
        help: "Uses the ‘public‘ access level for generated constants"
    )
    var `public`: Bool?

    // MARK: - Program
    
    func run() throws {
        // Load the source ensuring that errors are thrown in a diagnostic format for the input
        let source = try withThrownErrorsAsDiagnostics(at: input) {
            // Load the String Catalog file
            let catalog = try StringCatalog(contentsOf: input)

            // Extract resources from it
            let resources = try catalog.resources
            try ResourceValidator.validateResources(resources, in: input)

            // Generate the associated Swift source
            return StringGenerator.generateSource(
                for: resources,
                tableName: tableName,
                accessLevel: accessLevel
            )
        }

        // Write the output and catch errors in a diagnostic format
        try withThrownErrorsAsDiagnostics {
            // Create the directory if it doesn't exist
            try createOutputDirectoryIfNeeded()

            // Write the source to disk
            try source.write(to: output, atomically: true, encoding: .utf8)
            note("Output written to ‘\(output.path(percentEncoded: false))‘")
        }
    }

    var tableName: String {
        input.lastPathComponent.replacingOccurrences(of: ".\(input.pathExtension)", with: "")
    }

    var accessLevel: StringGenerator.AccessLevel {
        let argValue = self.public
        if argValue == true {
            return .public
        }

        let environment = ProcessInfo.processInfo.environment
        if environment["XCSTRINGS_ACCESS_LEVEL_PUBLIC"]?.isTruthy == true {
            return .public
        }

        if let swiftSettings = environment["SWIFT_ACTIVE_COMPILATION_CONDITIONS"],
           swiftSettings.contains("XCSTRINGS_ACCESS_LEVEL_PUBLIC") {
            return .public
        }

        return .internal
    }

    func createOutputDirectoryIfNeeded() throws {
        let outputDirectory = output.deletingLastPathComponent()

        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: outputDirectory.path(percentEncoded: false)) {
            try fileManager.createDirectory(at: outputDirectory, withIntermediateDirectories: true)
        }
    }
}

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
