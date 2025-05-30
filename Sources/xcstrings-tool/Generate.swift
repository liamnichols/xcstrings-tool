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
        help: "File path to a xcstrings-tool-config.yml configuration file",
        completion: .file(extensions: ["yml", "yaml", "json"]),
        transform: { URL(filePath: $0, directoryHint: .notDirectory) }
    )
    var config: URL?

    @Option(
        name: [.customShort("C"), .long],
        help: "Path to a directory used for storing cached outputs",
        completion: .directory,
        transform: { URL(filePath: $0, directoryHint: .isDirectory) }
    )
    var cache: URL?

    @Option(
        name: .shortAndLong,
        help: "Modify the Access Control for the generated source code"
    )
    var accessLevel: AccessLevel?
    
    @Flag(
        name: .long,
        help: "Treat underscores the same as other separators when converting keys to camel case."
    )
    var convertFromSnakeCase: Bool = false

    @Flag(name: .long)
    var importsUseExplicitAccessLevel: Bool = false

    @Option(
        name: .shortAndLong,
        help: "The development language (defaultLocalization in Package.swift) used when filtering legacy .strings and .stringsdict files from the input paths"
    )
    var developmentLanguage: String?

    @Flag(name: .shortAndLong)
    var verbose: Bool = false

    // MARK: - Program
    
    func run() throws {
        let configuration = try withThrownErrorsAsDiagnostics(at: config) {
            try Configuration(command: self, environment: ProcessInfo.processInfo.environment)
        }
        let logger = Logger(isVerboseLoggingEnabled: configuration.verbose)
        let fileManager = FileManager.default

        // Parse the input from the invocation arguments
        let input = try withThrownErrorsAsDiagnostics {
            try InputParser.parse(from: inputs, developmentLanguage: configuration.developmentLanguage, logger: logger)
        }

        // If a cache dir was specified, compute the cache key and init the cache
        let cache = try cache.flatMap { directoryURL in
            let key = try withThrownErrorsAsDiagnostics {
                try logger.measure("computing cache key") {
                    try Cache.Key(input: input, configuration: configuration)
                }
            }
            return Cache(directoryURL: directoryURL, key: key, fileManager: fileManager)
        }

        // Either read the source from the cache, or generate it from the inputs/configuration
        let (cacheHit, source) = if let cache, cache.hasEntry {
            try read(from: cache, logger: logger)
        } else {
            try generate(from: input, configuration: configuration, logger: logger)
        }

        try withThrownErrorsAsDiagnostics {
            // Write the generated (or cached) source to the output file, but only if the contents has changed
            // This is done to avoid 'touching' the output file and causing Xcode to mark the source code as dirty
            try logger.measure("writing output") {
                try fileManager.write(source, to: output, skipIfMatches: true)
            }

            // If the source was generated without a cache hit, cache the source file as well
            if let cache, !cacheHit {
                try logger.measure("caching output") {
                    try cache.write(source)
                }
            }

            logger.note("Output written to ‘\(output.path(percentEncoded: false))‘")
        }
    }

    private func read(
        from cache: Cache,
        logger: Logger
    ) throws -> (cacheHit: Bool, source: String) {
        let source = try logger.measure("reading from cache") {
            try cache.read()
        }

        return (true, source)
    }

    private func generate(
        from input: InputParser.Parsed,
        configuration: Configuration,
        logger: Logger
    ) throws -> (cacheHit: Bool, source: String) {
        // Collect the results for each input file
        let results = try input.files.map { input in
            try withThrownErrorsAsDiagnostics(at: input) {
                logger.debug("collecting results for ‘\(input.absoluteURL.path())‘")

                // Load the source content
                let source = try logger.measure("  loading source file") {
                    try StringSource(contentsOf: input)
                }

                // Extract any resources from this input
                let result = try logger.measure("  extracting resources") {
                    try StringExtractor.extractResources(from: source)
                }

                // Validate the extraction result
                try logger.measure("  validating contents") {
                    result.issues.forEach { logger.warning($0.description, sourceFile: input) }
                    try ResourceValidator.validateResources(result.resources, in: input, logger: logger)
                }

                // Return the resources
                return result
            }
        }

        // Merge the resources together, ensure that they are uniquely keyed and sorted
        let resources = try StringExtractor.mergeAndEnsureUnique(results, logger: logger)

        // Generate the associated Swift source
        let source = try logger.measure("generating Swift source code") {
            StringGenerator.generateSource(
                for: resources,
                tableName: input.tableName,
                accessLevel: configuration.accessLevel,
                convertFromSnakeCase: configuration.convertFromSnakeCase,
                importsUseExplicitAccessLevel: configuration.importsUseExplicitAccessLevel
            )
        }

        return (false, source)
    }
}
