import Foundation
import StringCatalog

/// A representation of a raw .strings or .stringsdict file
public typealias LegacyFormat = [String: Any]

/// Various sources of localized strings
public enum StringSource {
    case catalog(StringCatalog)
    case legacy(LegacyFormat)
}

// MARK: - Loading
extension StringSource {
    public init(contentsOf fileURL: URL) throws {
        switch fileURL.pathExtension {
        case "xcstrings":
            self = .catalog(try StringCatalog(contentsOf: fileURL))
        case "stringsdict", "strings":
            self = .legacy(try LegacyFormat(contentsOf: fileURL))
        default:
            throw StringSourceError.invalidFileFormat(fileURL.pathExtension)
        }
    }
}

// MARK: - Legacy Format
extension LegacyFormat {
    init(contentsOf fileURL: URL) throws {
        let data = try Data(contentsOf: fileURL)
        let plist = try PropertyListSerialization.propertyList(from: data, format: nil)
        
        if let dictionary = plist as? LegacyFormat {
            self = dictionary
        } else {
            throw StringSourceError.invalidPropertyListContents
        }
    }
}
