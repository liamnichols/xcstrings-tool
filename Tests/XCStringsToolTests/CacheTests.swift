import Foundation
@preconcurrency import SnapshotTesting
@testable import xcstrings_tool
import XCTest

final class CacheTests: FixtureTestCase {
    let fileManager: FileManager = .default
    var directoryURL: URL!

    override func setUpWithError() throws {
        try super.setUpWithError()

        directoryURL = fileManager.temporaryDirectory
            .appending(component: "XCStringsToolTests")
            .appending(component: UUID().uuidString)

        try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        try fileManager.removeItem(atPath: directoryURL.path(percentEncoded: false))
    }

    func testCaching() throws {
        // Create a directory for the cache
        let cacheURL = directoryURL.appending(component: "Cache", directoryHint: .isDirectory)
        try fileManager.createDirectory(at: cacheURL, withIntermediateDirectories: true)

        // Find an input
        let inputURL = try fixture(named: "Localizable")

        // Define the output
        let outputURL = directoryURL.appending(component: "Output.swift", directoryHint: .notDirectory)

        // Create the invocation arguments
        let arguments = [
            inputURL.path(),
            "--cache", cacheURL.path(),
            "--output", outputURL.path()
        ]

        // Generate the output without cache
        try Generate.parse(arguments).run()
        XCTAssertTrue(fileManager.fileExists(atPath: outputURL.path()))
        XCTAssertNotEqual(try String(contentsOf: outputURL), "cache hit")

        // Ensure that a cache entry was written
        // Overwrite the cache data so that we can check to see if it was used on the second invocation
        let cacheEntry = try XCTUnwrap(fileManager.contentsOfDirectory(atPath: cacheURL.path()).first)
        try "cache hit".write(to: cacheURL.appending(component: cacheEntry), atomically: true, encoding: .utf8)

        // Run the generator again and assert that the output file contains the data from the cache
        try Generate.parse(arguments).run()
        XCTAssertEqual(try String(contentsOf: outputURL), "cache hit")

        // Generate again, but with different arguments
        try Generate.parse(arguments + ["--access-level", "public"]).run()
        XCTAssertNotEqual(try String(contentsOf: outputURL), "cache hit")
    }
}
