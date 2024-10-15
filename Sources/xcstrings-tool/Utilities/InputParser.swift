import Foundation

struct InputParser {
    typealias Parsed = (tableName: String, files: [URL])

    enum Error: Swift.Error {
        case noInputs
        case multipleTablesInInputs([String])
        case duplicateFiles([String: [URL]])
        case notALocalizedResource(URL)
    }

    static func parse(from inputs: [URL], developmentLanguage: String?, logger: Logger) throws -> Parsed {
        if inputs.isEmpty { throw Error.noInputs }

        logger.debug("raw inputs:")
        logger.debug("  developmentLanguage: \(developmentLanguage ?? "nil")")
        logger.debug("  files:")
        for input in inputs {
            logger.debug("  - \(input.absoluteURL.path())")
        }

        let tableName = try tableName(from: inputs)
        let files = try filteredFiles(from: inputs, developmentLanguage: developmentLanguage)

        logger.debug("parsed inputs:")
        logger.debug("  tableName: \(tableName)")
        logger.debug("  files:")
        for file in files {
            logger.debug("  - \(file.absoluteURL.path())")
        }

        let grouped = Dictionary(grouping: files, by: \.lastPathComponent)
        let duplicates = grouped.filter { $0.value.count > 1 }
        guard duplicates.isEmpty else {
            throw Error.duplicateFiles(duplicates)
        }

        return (tableName, files)
    }

    private static func filteredFiles(from inputs: [URL], developmentLanguage: String?) throws -> [URL] {
        // If no development language is defined, assume that all inputs are correct
        guard let developmentLanguage else { return inputs }

        return try inputs.filter { fileURL in
            // Strings Catalogs do not need to be embedded within a .lproj directory
            if fileURL.pathExtension == "xcstrings" {
                return true
            }

            // Raise an error if the file is not contained within a localized .lproj directory
            guard let lprojDir = fileURL.pathComponents.first(where: { $0.lowercased().hasSuffix(".lproj") }) else {
                throw Error.notALocalizedResource(fileURL)
            }

            // Include the file if the language matches the developmentLanguage
            let language = lprojDir.replacingOccurrences(of: ".lproj", with: "", options: .caseInsensitive)
            return language.localizedCaseInsensitiveCompare(developmentLanguage) == .orderedSame
        }
    }

    private static func tableName(from inputs: [URL]) throws -> String {
        let tableNames = Set(inputs.map({ url in
            url.lastPathComponent.replacingOccurrences(of: ".\(url.pathExtension)", with: "")
        }))

        guard tableNames.count == 1, let tableName = tableNames.first else {
            throw Error.multipleTablesInInputs(tableNames.sorted())
        }

        return tableName
    }
}

extension InputParser.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInputs:
            return "You must provide at least one input file."
        case .multipleTablesInInputs(let tableNames):
            return """
            Attempting to generate for inputs that represent multiple different \
            strings tables (\(tableNames.formatted())). \
            This is not supported.
            """
        case .duplicateFiles(let duplicates):
            let duplicates = duplicates
                .sorted(by: { $0.key.localizedStandardCompare($1.key) == .orderedAscending })
                .map { filename, urls in
                    """
                    \(filename):
                    \(urls.map({ "  - \($0.absoluteURL.path())" }).joined(separator: "\n"))
                    """
                }
                .joined(separator: "\n")

            return """
            Multiple inputs point to the same file but inputs should only include \
            the development language.

            \(duplicates)
            """
        case .notALocalizedResource(let fileURL):
            return """
            A development language was specified, but the input \
            ‘\(fileURL.absoluteURL.path())‘ was not contained within \
            a localized resource (.lproj) directory.
            """
        }
    }
}
