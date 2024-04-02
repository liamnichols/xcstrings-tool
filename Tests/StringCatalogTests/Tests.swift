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
}
