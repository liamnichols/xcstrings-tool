#if canImport(XcodeProjectPlugin)
import PackagePlugin
import XcodeProjectPlugin

extension XCStringsToolPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(
        context: XcodePluginContext,
        target: XcodeTarget
    ) throws -> [Command] {
        try InputFile
            .groupings(for: target.inputFiles)
            .map { tableName, files in
                try .xcstringstool(forTableName: tableName, files: files, using: context)
            }
    }
}
#endif
