import SwiftIdentifier
import XCTest

final class SwiftIdentifierTests: XCTestCase {
    func testSwiftIdentifier() {
        assert(value: "Localizable", escapesTo: "Localizable", "localizable")
        assert(value: "localizable", escapesTo: "Localizable", "localizable")
        assert(value: "LOCALIZABLE", escapesTo: "LOCALIZABLE", "localizable")

        assert(value: "URL Strings", escapesTo: "URLStrings", "urlStrings")
        assert(value: "URLStrings", escapesTo: "URLStrings", "urlStrings")

        assert(value: "FeatureFoo", escapesTo: "FeatureFoo", "featureFoo")
        assert(value: "Feature Foo", escapesTo: "FeatureFoo", "featureFoo")
        assert(value: "Feature URL", escapesTo: "FeatureURL", "featureURL")
    }

    private func assert(
        value: String,
        escapesTo expectedIdentifier: String,
        _ expectedVariableIdentifier: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertEqual(
            SwiftIdentifier.identifier(from: value),
            expectedIdentifier,
            "identifier",
            file: file,
            line: line
        )

        XCTAssertEqual(
            SwiftIdentifier.variableIdentifier(for: value),
            expectedVariableIdentifier,
            "variableIdentifier",
            file: file,
            line: line
        )
    }
}
