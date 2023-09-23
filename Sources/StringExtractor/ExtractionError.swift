import Foundation

public enum ExtractionError: LocalizedError {
    public struct Context {
        /// The key of the localization being parsed
        public let key: String

        /// A description of the issue
        public let debugDescription: String
    }

    case localizationCorrupt(Context)
}
