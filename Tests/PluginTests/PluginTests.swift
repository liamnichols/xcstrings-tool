import Foundation
import SwiftUI
import XCTest

// Will fail to compile if `String.Localizable` doesn't generate with xcstrings-tool-config.yml settings
public struct AccessLevelTest {
    public let testToEnsureAccessLevel: String.Localizable
}

final class PluginTests: XCTestCase {
    func testPluginGeneratedSources() {
        XCTAssertEqual(
            String(localizable: .demoBasic),
            "A basic string"
        )
        XCTAssertEqual(
            .localizable(.demoBasic),
            "A basic string"
        )

        XCTAssertEqual(
            String(localized: .localizable(.multiline(2))),
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
            .localizable(.multiline(2)),
            """
            A string that
            spans 2 lines
            """
        )

        XCTAssertEqual(
            String(localized: .featureOne(.pluralExample(1))),
            "1 string remaining"
        )
        XCTAssertEqual(
            String(featureOne: .pluralExample(1)),
            "1 string remaining"
        )
        XCTAssertEqual(
            .featureOne(.pluralExample(1)),
            "1 string remaining"
        )

        XCTAssertEqual(
            String(localized: .featureOne(.pluralExample(10))),
            "10 strings remaining"
        )
        XCTAssertEqual(
            String(featureOne: .pluralExample(10)),
            "10 strings remaining"
        )
        XCTAssertEqual(
            .featureOne(.pluralExample(10)),
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

    func testLegacyStrings() {
        XCTAssertEqual(
            String(legacy: .simpleString("foo")),
            "This simple string: foo"
        )
        XCTAssertEqual(
            .legacy(.simpleString("foo")),
            "This simple string: foo"
        )

        XCTAssertEqual(
            String(legacy: .plural("John", 1)),
            "Hello John, I have 1 plural"
        )
        XCTAssertEqual(
            .legacy(.plural("John", 1)),
            "Hello John, I have 1 plural"
        )
    }

    func testComparisons() {
        let foo1 = String.Localizable.demoBasic
        let foo2 = String.Localizable.demoBasic
        XCTAssertEqual(foo1, foo2)

        let bar1 = String.Localizable.multiline(1)
        let bar2 = String.Localizable.multiline(2)
        XCTAssertNotEqual(bar1, bar2)
    }
}
