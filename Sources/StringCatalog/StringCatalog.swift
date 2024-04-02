import Foundation

public struct StringCatalog: Codable {
    public var sourceLanguage: StringLanguage
    public var strings: [String: StringEntry]
    public var version: String // TODO: Use a Version type?

    public init(sourceLanguage: StringLanguage, strings: [String : StringEntry], version: String) {
        self.sourceLanguage = sourceLanguage
        self.strings = strings
        self.version = version
    }
}

// MARK: - Init
extension StringCatalog {
    public init(contentsOf fileURL: URL) throws {
        let data = try Data(contentsOf: fileURL)

        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: data)
    }
}
