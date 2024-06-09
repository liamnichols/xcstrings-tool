import ArgumentParser
import Foundation
import StringExtractor
import struct StringResource.Resource
import StringCatalog
import StringGenerator
import StringSource
import StringValidator

struct Generate: ParsableCommand {
    @Argument(
        help: ArgumentHelp(
            "Path to xcstrings String Catalog file",
            discussion: """
            You can also pass multiple file paths to the same Strings Table. \
            For example, a path to Localizable.strings as well as Localizable.stringsdict. \
            An error will be thrown if you pass inputs to multiple different Strings Tables.
            """
        ),
        completion: .file(extensions: ["xcstrings", "strings", "stringsdict"]),
        transform: { URL(filePath: $0, directoryHint: .notDirectory) }
    )
    var inputs: [URL]

    @Option(
        name: .shortAndLong,
        help: "Path to write generated Swift output",
        completion: .file(extensions: ["swift"]),
        transform: { URL(filePath: $0, directoryHint: .notDirectory) }
    )
    var output: URL

    @Option(
        name: .shortAndLong,
        help: "Modify the Access Control for the generated source code"
    )
    var accessLevel: AccessLevel?

    // MARK: - Program
    
    func run() throws {
        let tableName = try withThrownErrorsAsDiagnostics {
            try self.tableName
        }

        // Collect the results for each input file
        let results = try inputs.map { input in
            try withThrownErrorsAsDiagnostics(at: input) {
                // Load the source content and extract the resources
                let source = try StringSource(contentsOf: input)
                let result = try StringExtractor.extractResources(from: source)

                // Validate the extraction result
                result.issues.forEach { warning($0.description, sourceFile: input) }
                try ResourceValidator.validateResources(result.resources, in: input)

                // Return the resources
                return result
            }
        }

        // Merge the resources together, ensure that they are uniquely keyed and sorted
        let resources = try StringExtractor.mergeAndEnsureUnique(results)

        // Generate the associated Swift source
        let source = StringGenerator.generateSource(
            for: resources,
            tableName: tableName,
            accessLevel: resolvedAccessLevel
        )

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
        get throws {
            let tableNames = Set(inputs.map({ url in
                url.lastPathComponent.replacingOccurrences(of: ".\(url.pathExtension)", with: "")
            }))

            if tableNames.count == 1, let tableName = tableNames.first {
                return tableName
            } else {
                throw Diagnostic(
                    severity: .error,
                    message: """
                    Attempting to generate for inputs that represent multiple different \
                    strings tables (\(tableNames.sorted().formatted())). \
                    This is not supported.
                    """
                )
            }
        }
    }

    var resolvedAccessLevel: AccessLevel {
        .resolveFromEnvironment(or: accessLevel) ?? .internal
    }
}
