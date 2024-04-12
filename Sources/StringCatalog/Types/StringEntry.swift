import Foundation

public struct StringEntry: Codable {
    public typealias Localizations = [StringLanguage: StringLocalization]

    public var comment: String?
    public var extractionState: StringExtractionState?
    public var localizations: Localizations?

    public init(comment: String? = nil, extractionState: StringExtractionState? = nil, localizations: Localizations? = nil) {
        self.comment = comment
        self.extractionState = extractionState
        self.localizations = localizations
    }
}
