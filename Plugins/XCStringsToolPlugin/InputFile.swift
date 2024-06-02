import Foundation
import PackagePlugin

struct InputFile {
    let tableName: String
    let file: File
}

extension InputFile {
    static let supportedExtensions: Set<String> = ["xcstrings", "strings", "stringsdict"]

    init?(file: File) {
        guard let ext = file.path.extension, Self.supportedExtensions.contains(ext) else {
            return nil
        }

        self.init(tableName: file.path.stem, file: file)
    }

    static func groupings(for inputFiles: [InputFile]) -> [(tableName: String, inputFiles: [File])] {
        let grouped = Dictionary(grouping: inputFiles, by: \.tableName)
        
        return grouped
            .map({ ($0.key, $0.value.map(\.file)) })
            .sorted(by: { $0.tableName.localizedStandardCompare($1.tableName) == .orderedAscending })
    }

    static func groupings(for sourceFiles: FileList) -> [(tableName: String, inputFiles: [File])] {
        groupings(for: sourceFiles.compactMap(InputFile.init(file:)))
    }
}
