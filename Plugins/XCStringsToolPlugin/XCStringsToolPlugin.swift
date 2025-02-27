import Foundation
import PackagePlugin

@main
struct XCStringsToolPlugin: BuildToolPlugin {
    func createBuildCommands(
        context: PluginContext,
        target: Target
    ) async throws -> [Command] {
        guard let sourceModule = target.sourceModule else {
            Diagnostics.warning("XcodestringsGenPlugin does not support non-source targets")
            return []
        }

        return try sourceModule
            .sourceFiles
            .stringTables
            .map { tableName, files in
                try .xcstringstool(
                    forTableName: tableName,
                    files: files,
                    using: context,
                    config: findConfig(in: target.directory, context.package.directory)
                )
            }
    }

    func findConfig(in directories: Path..., using fileManager: FileManager = .default) -> Path? {
        let filenames = ["xcstrings-tool.yml", "xcstrings-tool.yaml", "xcstrings-tool.json", ".xcstrings-tool.yml", ".xcstrings-tool.yaml", ".xcstrings-tool.json"]
        for directory in directories {
            for filename in filenames {
                let path = directory.appending(filename)
                if fileManager.fileExists(atPath: path.string) {
                    return path
                }
            }
        }
        return nil
    }
}
