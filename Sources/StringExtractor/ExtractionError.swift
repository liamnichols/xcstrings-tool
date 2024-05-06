import Foundation

public enum ExtractionError: Error {
    public struct Context {
        /// The key of the localization being parsed
        public let key: String

        /// A description of the issue
        public let debugDescription: String
    }

    case localizationCorrupt(Context)
    case unsupported(Context)
}

extension ExtractionError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .localizationCorrupt(let context):
            "String ‘\(context.key)‘ was corrupt: \(context.debugDescription)"
        case .unsupported(let context):
            "String ‘\(context.key)‘ is not supported: \(context.debugDescription)"
        }
    }
}
