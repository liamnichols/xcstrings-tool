import Foundation
@preconcurrency import SnapshotTesting
@testable import xcstrings_tool
import XCTest

final class GenerateTests: FixtureTestCase {
    override func invokeTest() {
        withSnapshotTesting(record: .missing) {
            super.invokeTest()
        }
    }

    func testGenerate() throws {
        try eachFixture { inputURL in
            if !inputURL.lastPathComponent.hasPrefix("!") {
                try snapshot(for: inputURL)
            }
        }
    }

    func testGenerateInvalid() throws {
        // Scenario where positional specifiers are repeated, but don't use the same type
        assertError(
            for: try fixture(named: "!MismatchingArgumentType"),
            localizedDescription: """
            String ‘Key‘ was corrupt: The argument at position 1 was specified multiple \
            times but with different data types. First ‘int‘, then ‘object‘.
            """
        )

        // Scenario where specifiers contain explicit positions that result in a missed argument
        assertError(
            for: try fixture(named: "!MissingArgument"),
            localizedDescription: """
            String ‘Key‘ was corrupt: The argument at position 1 was not included in the \
            source localization and it's type cannot be inferred.
            """
        )

        // Scenario where format specifiers such as %c are not supported
        assertError(
            for: try fixture(named: "!UnsupportedFormatSpecifiers"),
            localizedDescription: """
            String ‘Key‘ is not supported: The placeholder format specifier ‘%c‘ is not supported.
            """
        )

        // Scenario where yaml is malformed
        // TODO: Improve the diagnostic messages?
        assertError(
            for: try fixture(named: "Localizable"),
            config: """
            accessLevel: private
            """,
            localizedDescription: """
            Decoding error at ‘accessLevel‘ - The data couldn’t be read because it isn’t in the correct format.
            """
        )
    }

    func testGenerateWithPublicAccessLevel() throws {
        try snapshot(
            for: try fixture(named: "Localizable"),
            accessLevel: "public"
        )
    }

    func testGenerateWithPackageAccessLevel() throws {
        try snapshot(
            for: try fixture(named: "Localizable"),
            config: """
            accessLevel: package
            """
        )
    }
    
    func testGenerateWithConvertFromSnakeCase() throws {
        try snapshot(
            for: try fixture(named: "Localizable"),
            config: """
            convertFromSnakeCase: true
            """
        )
    }

    func testGenerateWithImportsUseExplicitAccessLevel() throws {
        try snapshot(
            for: try fixture(named: "Localizable"),
            config: """
            importsUseExplicitAccessLevel: true
            """
        )
    }

    func testGenerateWithLegacyStrings() throws {
        try snapshot(
            for: try fixture(named: "Legacy", extension: "strings")
        )
    }

    func testGenerateWithLegacyStringsdict() throws {
        try snapshot(
            for: try fixture(named: "Legacy", extension: "stringsdict")
        )
    }

    func testGenerateWithLegacyFilesCombined() throws {
        try snapshot(
            for: try fixture(named: "Legacy", extension: "strings"), try fixture(named: "Legacy", extension: "stringsdict")
        )
    }
}

// MARK: - Helpers
private extension GenerateTests {
    func snapshot(
        for inputURLs: URL...,
        accessLevel: String? = nil,
        config: String? = nil,
        file: StaticString = #filePath,
        testName: String = #function,
        line: UInt = #line
    ) throws {
        assertSnapshot(
            of: try run(for: inputURLs, accessLevel: accessLevel, config: config),
            as: .sourceCode,
            named: inputURLs.first!.stem,
            file: file,
            testName: testName,
            line: line
        )
    }

    func assertError(
        for inputURLs: URL...,
        accessLevel: String? = nil,
        config: String? = nil,
        localizedDescription expected: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertThrowsError(try run(for: inputURLs, accessLevel: accessLevel, config: config), file: file, line: line) { error in
            let actual = if let error = error as? Diagnostic {
                error.message
            } else {
                error.localizedDescription
            }

            XCTAssertEqual(expected, actual, file: file, line: line)
        }
    }

    // Helper for running the generate command
    func run(
        for inputURLs: [URL],
        accessLevel: String? = nil,
        config: String? = nil
    ) throws -> String {
        // Create a temporary output file
        let fileManager = FileManager.default
        let uuid = UUID().uuidString
        let directoryURL = fileManager.temporaryDirectory.appending(component: "XCStringsToolTests").appending(component: uuid)
        let outputURL = directoryURL.appending(component: "Output.swift")
        let configURL = directoryURL.appending(component: "xcstrings-tool-config.yml")

        if let config {
            if !fileManager.fileExists(atPath: directoryURL.path()) {
                try? fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            }
            try config.write(to: configURL, atomically: true, encoding: .utf8)
        }

        // Cleanup any temporary output
        addTeardownBlock {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: directoryURL.path()) {
                try? fileManager.removeItem(at: directoryURL)
            }
        }

        // Form the arguments
        var arguments = inputURLs.map { $0.absoluteURL.path() }
        arguments.append(contentsOf: ["--output", outputURL.absoluteURL.path()])
        if let accessLevel {
            arguments += ["--access-level", accessLevel]
        }
        if config != nil {
            arguments += ["--config", configURL.path()]
        }

        // Run the generator
        try Generate.parse(arguments).run()

        // Read the file back and return it
        return try String(contentsOf: outputURL)
    }
}

extension URL {
    var stem: String {
        if pathExtension.isEmpty {
            lastPathComponent
        } else {
            lastPathComponent.replacingOccurrences(of: ".\(pathExtension)", with: "")
        }
    }
}

extension Snapshotting where Value == String, Format == String {
    /// A snapshot strategy for comparing Swift Source Code based on equality.
    public static let sourceCode = Snapshotting(pathExtension: "swift", diffing: .lines)
}
