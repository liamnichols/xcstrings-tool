import Foundation
import StringCatalog
import XCTest

final class StringCatalogTests: FixtureTestCase {
    func testParsing() throws {
        try eachFixture { fileURL in
            let catalog = try StringCatalog(contentsOf: fileURL)
            XCTAssertNotNil(catalog)
        }
    }
}
