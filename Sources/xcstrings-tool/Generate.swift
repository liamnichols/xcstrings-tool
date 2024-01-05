import ArgumentParser
import Foundation
import StringExtractor
import struct StringResource.Resource
import StringCatalog
import StringGenerator
import StringValidator

struct Generate: ParsableCommand {
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
        name: .shortAndLong,
        help: "Modify the Access Control for the generated source code"
    )
    var accessLevel: StringGenerator.AccessLevel?

    // MARK: - Program
    
    func run() throws {
        // Load the source ensuring that errors are thrown in a diagnostic format for the input
        let source = try withThrownErrorsAsDiagnostics(at: input) {
            // Load the String Catalog file
            let catalog = try StringCatalog(contentsOf: input)

            // Extract resources from it
            let result = try StringExtractor.extractResources(from: catalog)

            // Validate the extraction result
            result.issues.forEach { warning($0.description, sourceFile: input) }
            try ResourceValidator.validateResources(result.resources, in: input)

            // Generate the associated Swift source
            return StringGenerator.generateSource(
                for: result.resources,
                tableName: tableName,
                accessLevel: resolvedAccessLevel
            )
        }

        // Write the output and catch errors in a diagnostic format
        try withThrownErrorsAsDiagnostics {
            // Create the directory if it doesn't exist
            try createDirectoryIfNeeded(for: output)

            // Write the source to disk
            try source.write(to: output, atomically: false, encoding: .utf8)
            note("Output written to ‘\(output.path(percentEncoded: false))‘")
        }
    }

    var tableName: String {
        input.lastPathComponent.replacingOccurrences(of: ".\(input.pathExtension)", with: "")
    }

    var resolvedAccessLevel: StringGenerator.AccessLevel {
        .resolveFromEnvironment(or: accessLevel) ?? .internal
    }
}
