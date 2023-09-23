import Foundation

public struct StringEntry: Codable {
    public var comment: String?
    
    public var extractionState: StringExtractionState

    @StringKey
    public var localizations: [StringLanguage: StringLocalization]
}
