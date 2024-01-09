import Foundation
import SnapshotTesting
@testable import xcstrings_tool
import XCTest

final class GenerateTests: FixtureTestCase {
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
            times but with different data types. First ‘Int‘, then ‘String‘.
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
            accessLevel: "package"
        )
    }

    func testGenerateWithLegacyStrings() throws {
        try snapshot(
            for: try fixture(named: "Legacy", extension: "strings")
        )
    }
}

// MARK: - Helpers
private extension GenerateTests {
    func snapshot(
        for inputURL: URL,
        accessLevel: String? = nil,
        record: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) throws {
        assertSnapshot(
            of: try run(for: inputURL, accessLevel: accessLevel),
            as: .sourceCode,
            named: inputURL.stem,
            record: record,
            file: file,
            testName: testName,
            line: line
        )
    }

    func assertError(
        for inputURL: URL,
        localizedDescription expected: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertThrowsError(try run(for: inputURL), file: file, line: line) { error in
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
        for inputURL: URL,
        accessLevel: String? = nil
    ) throws -> String {
        // Create a temporary output file
        let fileManager = FileManager.default
        let outputURL = fileManager.temporaryDirectory
            .appending(component: "XCStringsToolTests")
            .appending(component: UUID().uuidString + ".swift")

        // Cleanup any temporary output
        addTeardownBlock {
            if fileManager.fileExists(atPath: outputURL.path()) {
                try? fileManager.removeItem(at: outputURL)
            }
        }

        // Form the arguments
        var arguments = [inputURL.absoluteURL.path(), outputURL.absoluteURL.path()]
        if let accessLevel {
            arguments += ["--access-level", accessLevel]
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
