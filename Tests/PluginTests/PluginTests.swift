import Foundation
import XCTest

final class PluginTests: XCTestCase {
    func testPluginGeneratedSources() {
        XCTAssertEqual(
            String(localized: .localizable.demoBasic),
            "A basic string"
        )

        XCTAssertEqual(
            String(localized: .localizable.multiline(2)),
            """
            A string that
            spans 2 lines
            """
        )

        XCTAssertEqual(
            String(localized: .featureOne.pluralExample(1)),
            "1 string remaining"
        )

        XCTAssertEqual(
            String(localized: .featureOne.pluralExample(10)),
            "10 strings remaining"
        )
    }
}
