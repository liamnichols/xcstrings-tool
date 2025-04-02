import PackagePlugin

enum PluginUtils {
    fileprivate static let configFilenames = Set(["yaml", "yml", "json"].map { "xcstrings-tool-config." + $0 })
    fileprivate static let inputFileExtensions: Set<String> = ["xcstrings", "strings", "stringsdict"]

    struct ValidatedInputs {
        struct Invocation {
            let strings: [File]
            let tableName: String
            let output: Path
        }

        let tool: PluginContext.Tool
        let config: Path?
        let invocations: [Invocation]
    }

    static func validateInputs(
        pluginWorkDirectory: Path,
        tool: (String) throws -> PluginContext.Tool,
        sourceFiles: FileList,
        targetName: String
    ) throws -> ValidatedInputs {
        let tool = try tool("xcstrings-tool")
        let config = try findConfig(inputFiles: sourceFiles, targetName: targetName)
        let invocations = sourceFiles.stringTables.map { tableName, strings in
            ValidatedInputs.Invocation(
                strings: strings,
                tableName: tableName,
                output: pluginWorkDirectory
                    .appending(subpath: "XCStringsTool")
                    .appending("\(tableName).swift")
            )
        }

        return ValidatedInputs(tool: tool, config: config, invocations: invocations)
    }

    private static func findConfig(inputFiles: FileList, targetName: String) throws -> Path? {
        let configs = inputFiles
            .filter { configFilenames.contains($0.path.lastComponent) }
            .map(\.path)

        if configs.isEmpty {
            return nil
        } else if configs.count == 1, let config = configs.first {
            return config
        } else {
            throw PluginError.multipleConfigs(targetName: targetName, files: configs)
        }
    }
}

private extension FileList {
    var stringResources: [File] {
        self.filter { PluginUtils.inputFileExtensions.contains($0.path.extension ?? "") }
    }

    var stringTables: [(tableName: String, files: [File])] {
        Dictionary(grouping: stringResources, by: \.path.stem)
            .map { ($0.key, $0.value) }
            .sorted(by: { $0.tableName.localizedStandardCompare($1.tableName) == .orderedAscending })
    }
}

extension PluginUtils.ValidatedInputs {
    func arguments(for invocation: Invocation) -> [String] {
        var arguments: [String] = invocation.strings.map(\.path.string)

        arguments.append(contentsOf: [
            "--output", invocation.output.string
        ])

        if let config {
            arguments.append(contentsOf: [
                "--config", config.string
            ])
        }

        return arguments
    }

    func inputFiles(for invocation: Invocation) -> [Path] {
        var files: [Path] = invocation.strings.map(\.path)

        if let config {
            files.append(config)
        }

        return files
    }

    func outputFiles(for invocation: Invocation) -> [Path] {
        [invocation.output]
    }
}
