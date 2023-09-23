import CustomDump
import Foundation
@testable import StringExtractor
import XCTest

final class StringParserTests: XCTestCase {
    func testParsingComplexString() throws {
        let actual = StringParser.parse(
            "%@ - %d - %#@count@ - %f - %5$d - %04$f - %6$d - %007$@ - %8$3.2f - %11$1.2f - %9$@ - %10$d - %lld",
            expandingSubstitutions: [
                "count": "INSIDE %lld SUBSTITUTE"
            ]
        )

        let expected: [StringParser.ParsedSegment] = [
            .placeholder(.object),
            .string(contents: " - "),
            .placeholder(.int),
            .string(contents: " - INSIDE "),
            .placeholder(.int),
            .string(contents: " SUBSTITUTE - "),
            .placeholder(.float),
            .string(contents: " - "),
            .placeholder(.int),
            .string(contents: " - "),
            .placeholder(.float),
            .string(contents: " - "),
            .placeholder(.int),
            .string(contents: " - "),
            .placeholder(.object),
            .string(contents: " - "),
            .placeholder(.float),
            .string(contents: " - "),
            .placeholder(.float),
            .string(contents: " - "),
            .placeholder(.object),
            .string(contents: " - "),
            .placeholder(.int),
            .string(contents: " - "),
            .placeholder(.int)
        ]

        XCTAssertNoDifference(expected, actual)
    }
}
