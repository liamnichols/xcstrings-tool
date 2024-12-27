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

    @Option(
        name: .shortAndLong,
        help: "Modify bundle expression for the generated source code"
    )
    var bundleExpression: String?

    @Option(
        name: .shortAndLong,
        help: "The development language (defaultLocalization in Package.swift) used when filtering legacy .strings and .stringsdict files from the input paths"
    )
    var developmentLanguage: String?

    @Flag(name: .shortAndLong)
    var verbose: Bool = false

    // MARK: - Program
    
    func run() throws {
        let logger = Logger(isVerboseLoggingEnabled: verbose)

        // Parse the input from the invocation arguments
        let input = try withThrownErrorsAsDiagnostics {
            try InputParser.parse(from: inputs, developmentLanguage: resolvedDevelopmentLanguage, logger: logger)
        }

        // Collect the results for each input file
        let results = try input.files.map { input in
            try withThrownErrorsAsDiagnostics(at: input) {
                logger.debug("collecting results for ‘\(input.absoluteURL.path())‘")

                // Load the source content
                logger.debug("  loading source file")
                let source = try StringSource(contentsOf: input)

                // Extract any resources from this input
                logger.debug("  extracting resources")
                let result = try StringExtractor.extractResources(from: source)

                // Validate the extraction result
                logger.debug("  validating contents")
                result.issues.forEach { logger.warning($0.description, sourceFile: input) }
                try ResourceValidator.validateResources(result.resources, in: input, logger: logger)

                // Return the resources
                return result
            }
        }

        // Merge the resources together, ensure that they are uniquely keyed and sorted
        let resources = try StringExtractor.mergeAndEnsureUnique(results, logger: logger)

        // Generate the associated Swift source
        logger.debug("generating Swift source code")
        let source = StringGenerator.generateSource(
            for: resources,
            tableName: input.tableName,
            accessLevel: resolvedAccessLevel,
            bundleExpression: bundleExpression
        )

        // Write the output and catch errors in a diagnostic format
        logger.debug("writing output")
        try withThrownErrorsAsDiagnostics {
            // Create the directory if it doesn't exist
            try createDirectoryIfNeeded(for: output)

            // Write the source to disk
            try source.write(to: output, atomically: false, encoding: .utf8)
            logger.note("Output written to ‘\(output.path(percentEncoded: false))‘")
        }
    }

    var resolvedAccessLevel: AccessLevel {
        .resolveFromEnvironment(or: accessLevel) ?? .internal
    }

    var resolvedDevelopmentLanguage: String? {
        developmentLanguage ?? ProcessInfo.processInfo.environment["DEVELOPMENT_LANGUAGE"]
    }
}
