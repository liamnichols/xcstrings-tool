import Foundation
@testable import xcstrings_tool
import XCTest

final class InputParserTests: XCTestCase {
    func testParse_noInputs() {
        let inputs: [URL] = []

        XCTAssertThrowsError(try InputParser.parse(from: inputs, developmentLanguage: nil)) { error in
            XCTAssertEqual(error.localizedDescription, "You must provide at least one input file.")
        }
    }

    func testParse_multipleStringsTablesNotSupported() {
        let inputs: [URL] = [
            URL(filePath: "/Source/Foo.strings"),
            URL(filePath: "/Source/Bar.strings")
        ]

        XCTAssertThrowsError(try InputParser.parse(from: inputs, developmentLanguage: nil)) { error in
            XCTAssertEqual(error.localizedDescription, """
            Attempting to generate for inputs that represent multiple different \
            strings tables (Bar and Foo). This is not supported.
            """)
        }
    }

    func testParse_singleLegacyResource() throws {
        let inputs: [URL] = [
            URL(filePath: "/Source/Localizable.strings")
        ]

        let result = try InputParser.parse(from: inputs, developmentLanguage: nil)

        XCTAssertEqual(result.tableName, "Localizable")
        XCTAssertEqual(result.files, inputs)
    }

    func testParse_multipleLegacyResources() throws {
        let inputs: [URL] = [
            URL(filePath: "/Source/Localizable.strings"),
            URL(filePath: "/Source/Localizable.stringsdict")
        ]

        let result = try InputParser.parse(from: inputs, developmentLanguage: nil)

        XCTAssertEqual(result.tableName, "Localizable")
        XCTAssertEqual(result.files, inputs)
    }

    func testParse_stringsCatalog() throws {
        let inputs: [URL] = [
            URL(filePath: "/Source/Localizable.xcstrings")
        ]

        let result = try InputParser.parse(from: inputs, developmentLanguage: nil)

        XCTAssertEqual(result.tableName, "Localizable")
        XCTAssertEqual(result.files, inputs)
    }

    func testParse_legacyFilesInLocalizedResourceDirectoryWithoutDevelopmentLanguage() throws {
        let inputs: [URL] = [
            URL(filePath: "/Source/en.lproj/Localizable.strings"),
            URL(filePath: "/Source/fr.lproj/Localizable.strings"),
            URL(filePath: "/Source/en.lproj/Localizable.stringsdict"),
            URL(filePath: "/Source/fr.lproj/Localizable.stringsdict"),
        ]

        XCTAssertThrowsError(try InputParser.parse(from: inputs, developmentLanguage: nil)) { error in
            XCTAssertEqual(error.localizedDescription, """
            Multiple inputs point to the same file but inputs should only include the development language.

            Localizable.strings:
              - /Source/en.lproj/Localizable.strings
              - /Source/fr.lproj/Localizable.strings
            Localizable.stringsdict:
              - /Source/en.lproj/Localizable.stringsdict
              - /Source/fr.lproj/Localizable.stringsdict
            """)
        }
    }

    func testParse_legacyFilesInLocalizedResourceDirectoryWithDevelopmentLanguage() throws {
        let inputs: [URL] = [
            URL(filePath: "/Source/en.lproj/Localizable.strings"),
            URL(filePath: "/Source/fr.lproj/Localizable.strings"),
            URL(filePath: "/Source/en.lproj/Localizable.stringsdict"),
            URL(filePath: "/Source/fr.lproj/Localizable.stringsdict"),
        ]

        let result = try InputParser.parse(from: inputs, developmentLanguage: "en")

        XCTAssertEqual(result.tableName, "Localizable")
        XCTAssertEqual(result.files, [
            URL(filePath: "/Source/en.lproj/Localizable.strings"),
            URL(filePath: "/Source/en.lproj/Localizable.stringsdict")
        ])
    }

    func testParse_developmentLanguageWithInvalidDirectoryStructure() {
        let inputs: [URL] = [
            URL(filePath: "/Source/Foo.strings")
        ]

        XCTAssertThrowsError(try InputParser.parse(from: inputs, developmentLanguage: "en")) { error in
            XCTAssertEqual(error.localizedDescription, """
            A development language was specified, but the input ‘/Source/Foo.strings‘ \
            was not contained within a localized resource (.lproj) directory.
            """)
        }
    }

    func testParse_developmentLanguageWithInvalidDirectoryStructure_fineForStringsCatalog() throws {
        let inputs: [URL] = [
            URL(filePath: "/Source/Foo.xcstrings")
        ]

        let result = try InputParser.parse(from: inputs, developmentLanguage: "en")

        XCTAssertEqual(result.tableName, "Foo")
        XCTAssertEqual(result.files, inputs)
    }
}
