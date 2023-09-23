import CustomDump
import Foundation
import StringCatalog
import StringResource
import StringExtractor
import XCTest

final class StringExtractorTests: FixtureTestCase {
    func testParsingOnlyParsesManualStrings() throws {
        try eachFixture { fileURL in
            let catalog = try StringCatalog(contentsOf: fileURL)
            let resources = try catalog.resources

            let expected = catalog.strings.filter { $0.value.extractionState == .manual }.count
            XCTAssertEqual(resources.count, expected)
        }
    }

    func testSimple() throws {
        let catalog = try catalog(named: "Simple")
        let resources = try catalog.resources

        XCTAssertEqual(resources.count, 1)
        XCTAssertNoDifference([
            Resource(
                key: "SimpleKey",
                comment: "This is a simple key and value",
                identifier: "simpleKey",
                arguments: [],
                defaultValue: [
                    .string("My Value")
                ]
            )
        ], resources)
    }

    func testArguments() throws {
        let catalog = try catalog(named: "Arguments")
        let resources = try catalog.resources

        XCTAssertEqual(resources.count, 2)
        XCTAssertNoDifference([
            Resource(
                key: "KeyWithIntAndDouble",
                comment: nil,
                identifier: "keyWithIntAndDouble",
                arguments: [
                    Argument(
                        label: nil,
                        name: "arg1",
                        type: "Int"
                    ),
                    Argument(
                        label: nil,
                        name: "arg2",
                        type: "Double"
                    )
                ],
                defaultValue: [
                    .string("Number "),
                    .interpolation("arg1"),
                    .string(" is "),
                    .interpolation("arg2"),
                ]
            ),
            Resource(
                key: "KeyWithString",
                comment: nil,
                identifier: "keyWithString",
                arguments: [
                    Argument(
                        label: nil,
                        name: "arg1",
                        type: "String"
                    )
                ],
                defaultValue: [
                    .string("Updated at: "),
                    .interpolation("arg1")
                ]
            )
        ], resources)
    }

    func testPluralVariation() throws {
        let catalog = try catalog(named: "PluralVariation")
        let resources = try catalog.resources

        XCTAssertEqual(resources.count, 1)
        XCTAssertNoDifference([
            Resource(
                key: "String.Plural",
                comment: nil,
                identifier: "stringPlural",
                arguments: [
                    Argument(
                        label: nil,
                        name: "arg1",
                        type: "Int"
                    ),
                ],
                defaultValue: [
                    .string("I have "),
                    .interpolation("arg1"),
                    .string(" strings")
                ]
            ),
        ], resources)
    }

    func testSubstitution() throws {
        let catalog = try catalog(named: "Substitution")
        let resources = try catalog.resources

        XCTAssertEqual(resources.count, 1)
        XCTAssertNoDifference([
            Resource(
                key: "substitutions_example.string",
                comment: nil,
                identifier: "substitutions_exampleString",
                arguments: [
                    Argument(
                        label: nil,
                        name: "arg1",
                        type: "String"
                    ),
                    Argument(
                        label: "totalStrings",
                        name: "arg2",
                        type: "Int"
                    ),
                    Argument(
                        label: "remainingStrings",
                        name: "arg3",
                        type: "Int"
                    )
                ],
                defaultValue: [
                    .interpolation("arg1"),
                    .string("! There are "),
                    .interpolation("arg2"),
                    .string(" strings and you have "),
                    .interpolation("arg3"),
                    .string(" remaining"),
                ]
            ),
        ], resources)
    }

    private func catalog(named name: String) throws -> StringCatalog {
        try StringCatalog(contentsOf: try fixture(named: name))
    }
}
