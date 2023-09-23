import ArgumentParser
import Foundation
import StringExtractor
import struct StringResource.Resource
import StringCatalog
import StringGenerator

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
        // Load the String Catalog file
        let catalog = try StringCatalog(contentsOf: input)
        
        // Extract resources from it
        let resources = try catalog.resources
        try validateResources(resources)

        // Generate the associated Swift source
        let source = StringGenerator.generateSource(for: resources, tableName: tableName, accessLevel: accessLevel)

        // Create the directory if it doesn't exist
        try createOutputDirectoryIfNeeded()

        // Write the source to disk
        try source.write(to: output, atomically: true, encoding: .utf8)
        print("note: Successfully written output to ‘\(output.path(percentEncoded: false))‘")
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

    // MARK: - Validation

    struct ValidationError: LocalizedError {
        var errorDescription: String? {
            "Conflicting keys need to be corrected"
        }
    }

    func validateResources(_ resources: [Resource]) throws {
        let conflictingResources = Dictionary(grouping: resources, by: \.identifier)
            .filter { $0.value.count > 1 }

        for (id, resources) in conflictingResources {
            let keys = resources
                .map { "‘\($0.key)‘" }
                .formatted(.list(type: .and))

            print("error: The keys \(keys) from ‘\(input.lastPathComponent)‘ produce the same identifier ‘\(id)‘ which is not supported with generated constants.")
        }

        if !conflictingResources.isEmpty {
            throw ValidationError()
        }
    }
}
