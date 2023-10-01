import Foundation
import SnapshotTesting
@testable import xcstrings_tool
import XCTest

final class GenerateTests: FixtureTestCase {
    func testGenerate() throws {
        try eachFixture { inputURL in
            try snapshot(for: inputURL)
        }
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
        try GenerateCommand.parse(arguments).run()

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
