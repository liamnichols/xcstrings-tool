import CustomDump
import Foundation
import StringGenerator
import StringResource
import XCTest

final class StringGeneratorTests: XCTestCase {
    func testGenerateMultilineString() {
        let output = generate([
            Resource(key: "foo", comment: nil, identifier: "foo", arguments: [], defaultValue: [
                .string("The answer is:\n- "),
                .interpolation("arg1"),
                .string("!")
            ])
        ])

        XCTAssertNotNil(output)
    }

    private func generate(
        _ resources: [Resource],
        tableName: String = "Localizable",
        accessLevel: StringGenerator.AccessLevel = .internal
    )  -> String {
        StringGenerator.generateSource(for: resources, tableName: tableName, accessLevel: accessLevel)
    }
}
