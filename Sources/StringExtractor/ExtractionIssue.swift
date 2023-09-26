import StringCatalog

public struct ExtractionIssue {
    public enum Reason {
        case wrongExtractionState(StringExtractionState?)
        case missingSourceLocalization(StringLanguage)
    }

    public let key: String
    public let reason: Reason

    public var description: String {
        switch reason {
        case .wrongExtractionState(let state):
            "String ‘\(key)‘ was ignored because it is not managed manually (\(state?.rawValue ?? "nil"))"
        case .missingSourceLocalization(let language):
            "String ‘\(key)‘ was ignored because it does not have a translation for source language (\(language.rawValue))"
        }
    }
}
