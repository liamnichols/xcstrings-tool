import Foundation

extension FileManager {
    func createDirectoryIfNeeded(for inputURL: URL) throws {
        let directoryURL = if inputURL.isFileURL && inputURL.hasDirectoryPath {
            inputURL
        } else {
            inputURL.deletingLastPathComponent()
        }

        if !fileExists(atPath: directoryURL.path(percentEncoded: false)) {
            try createDirectory(at: directoryURL, withIntermediateDirectories: true)
        }
    }

    func write(_ contents: String, to fileURL: URL, skipIfMatches: Bool) throws {
        // Ensure that the parent directory exists before anything
        try createDirectoryIfNeeded(for: fileURL)

        // If the file itself already exists, and compare the contents before writing
        if skipIfMatches, fileExists(atPath: fileURL.path(percentEncoded: false)) {
            let onDisk = try String(contentsOf: fileURL, encoding: .utf8)

            if onDisk == contents {
                return
            }
        }

        // Write the contents to file
        try contents.write(to: fileURL, atomically: false, encoding: .utf8)
    }
}
