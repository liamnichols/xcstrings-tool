import Foundation
import XCTest
import StringCatalog

class StringCatalogTests: XCTestCase {
    func testCreateCatalog() {
        let stringUnit = StringUnit(state: .translated, value: "Example value")
        let variations = StringVariations(device: [.iPad: StringVariation(stringUnit: stringUnit)], plural: [:])
        let substitutions = ["substitution": StringSubstitution(argNum: 0, formatSpecifier: "%lld", variations: variations)]
        let localization = StringLocalization(stringUnit: stringUnit, substitutions: substitutions, variations: variations)
        let entry = StringEntry(comment: "A comment", extractionState: "manual", localizations: [ "en": localization ])
        _ = StringCatalog(sourceLanguage: "en", strings: ["ExampleKey": entry], version: "1.0")
    }

    func testParseCatalog() throws {
        let fixtureUrl = try fixture(named: "Localizable")
        let catalog = try StringCatalog(contentsOf: fixtureUrl)
        print(String(describing: catalog))
    }

    func fixture(named name: String) throws -> URL {
        let bundle = Bundle.module
        return try XCTUnwrap(
            bundle.url(forResource: name, withExtension: "xcstrings", subdirectory: "__Fixtures__")
        )
    }
}
