import Foundation
import SwiftUI
import XCTest

final class PluginTests: XCTestCase {
    func testPluginGeneratedSources() {
        XCTAssertEqual(
            String(localized: .localizable.demoBasic),
            "A basic string"
        )
        XCTAssertEqual(
            String(localizable: .demoBasic),
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
            String(localizable: .multiline(2)),
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
            String(featureOne: .pluralExample(1)),
            "1 string remaining"
        )

        XCTAssertEqual(
            String(localized: .featureOne.pluralExample(10)),
            "10 strings remaining"
        )
        XCTAssertEqual(
            String(featureOne: .pluralExample(10)),
            "10 strings remaining"
        )
    }

    func testSwiftUI() {
        var environment = EnvironmentValues()
        environment.locale = Locale(identifier: "en")

        let key = LocalizedStringKey(featureOne: .pluralExample(3))
        let text = Text(key)
        let resolved = text._resolveText(in: environment)

        XCTAssertEqual(resolved, "3 strings remaining")
    }
}
