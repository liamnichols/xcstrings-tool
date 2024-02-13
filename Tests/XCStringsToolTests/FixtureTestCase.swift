import Foundation
import XCTest

class FixtureTestCase: XCTestCase {
    let bundle: Bundle = .module

    func eachFixture(
        withExtension ext: String = "xcstrings",
        test: (URL) throws -> Void
    ) throws {
        for fileURL in try fixtures(withExtension: ext) {
            try XCTContext.runActivity(named: fileURL.lastPathComponent) { activity in
                do {
                    try test(fileURL)
                } catch {
                    throw error
                }
            }
        }
    }

    func fixtures(withExtension ext: String) throws -> [URL] {
        try XCTUnwrap(
            bundle.urls(forResourcesWithExtension: ext, subdirectory: "__Fixtures__")
        )
    }

    func fixture(named name: String, extension ext: String = "xcstrings") throws -> URL {
        try XCTUnwrap(
            bundle.url(forResource: name, withExtension: ext, subdirectory: "__Fixtures__")
        )
    }
}
