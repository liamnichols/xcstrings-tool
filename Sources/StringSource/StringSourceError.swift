import Foundation

public enum StringSourceError: LocalizedError {
    case invalidFileFormat(String)
    case invalidPropertyListContents

    public var errorDescription: String? {
        switch self {
        case .invalidFileFormat(let format):
            "The file format ‘\(format)‘ is not supported."
        case .invalidPropertyListContents:
            "The root object of the property list was not a dictionary."
        }
    }
}
