import Foundation
import XCTest
import StringCatalog

class FixtureTestCase: XCTestCase {
    func testCreateCatalog() {
        _ = StringCatalog(sourceLanguage: "en", strings: [
            "ExampleKey": StringEntry(comment: "A comment", extractionState: "manual", localizations: StringEntry.Localizations(wrappedValue: [
                "en": StringLocalization(stringUnit: StringUnit(state: .translated, value: "Example value"))
            ])),
        ], version: "1.0")
    }

    func testParseCatalogz() throws {
        let fixtureUrl = try fixture(named: "Localizable")
        _ = try StringCatalog(contentsOf: fixtureUrl)
    }

    func fixture(named name: String) throws -> URL {
        let bundle = Bundle.module
        return try XCTUnwrap(
            bundle.url(forResource: name, withExtension: "xcstrings", subdirectory: "__Fixtures__")
        )
    }
}
