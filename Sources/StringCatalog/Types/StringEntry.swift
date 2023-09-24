import Foundation

public struct StringEntry: Codable {
    public typealias Localizations = DictionaryWrapper<StringLanguage, StringLocalization>

    public var comment: String?
    public var extractionState: StringExtractionState?
    public var localizations: Localizations?
}
