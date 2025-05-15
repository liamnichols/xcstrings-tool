import CryptoKit
import Foundation
import XCStringsToolConstants

struct Cache {
    struct Key: RawRepresentable {
        let rawValue: String
    }

    let fileURL: URL
    let fileManager: FileManager

    init(
        directoryURL: URL,
        key: Key,
        fileManager: FileManager
    ) {
        self.fileURL = directoryURL.appending(component: key.rawValue, directoryHint: .notDirectory)
        self.fileManager = fileManager
    }

    var hasEntry: Bool {
        fileManager.fileExists(atPath: fileURL.path(percentEncoded: false))
    }

    func read() throws -> String {
        try String(contentsOf: fileURL, encoding: .utf8)
    }

    func write(_ source: String) throws {
        try fileManager.write(source, to: fileURL, skipIfMatches: false)
    }
}

extension Cache.Key {
    init(input: InputParser.Parsed, configuration: Configuration) throws {
        // Define an array of components that will make up the cache key
        var components = [version]

        // Include the input table name
        components.append(input.tableName.lowercased())

        // Include the access level
        components.append(configuration.accessLevel.rawValue)

        // Include a hash of each input file (in a stable order)
        for fileURL in input.files.sorted(using: KeyPathComparator(\.absoluteString)) {
            components.append(computeSHAChecksum(for: try Data(contentsOf: fileURL)))
        }

        // Compute the checksum of all components
        let data = Data(components.joined(separator: "_").utf8) // v1_localizable_internal_fffffffffff
        let rawValue = computeSHAChecksum(for: data)

        self.init(rawValue: rawValue)
    }
}

private func computeSHAChecksum(for data: Data) -> String {
    SHA256.hash(data: data)
        .compactMap { String(format: "%02x", $0) }
        .joined()
}
