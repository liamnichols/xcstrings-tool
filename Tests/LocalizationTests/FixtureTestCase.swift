import Foundation
import XCTest

class FixtureTestCase: XCTestCase {
    var fixtures: [URL]!

    override func setUpWithError() throws {
        try super.setUpWithError()

        let bundle = Bundle.module
        fixtures = try XCTUnwrap(bundle.urls(forResourcesWithExtension: "xcstrings", subdirectory: "Fixtures"))
    }

    func eachFixture(_ test: (URL) throws -> Void) throws {
        for fileURL in fixtures {
            try XCTContext.runActivity(named: fileURL.lastPathComponent) { activity in
                try test(fileURL)
            }
        }
    }

    func fixture(named name: String) throws -> URL {
        let bundle = Bundle.module
        return try XCTUnwrap(
            bundle.url(forResource: name, withExtension: "xcstrings", subdirectory: "Fixtures")
        )
    }
}
