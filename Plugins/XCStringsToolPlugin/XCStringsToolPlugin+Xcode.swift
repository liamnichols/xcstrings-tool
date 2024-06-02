#if canImport(XcodeProjectPlugin)
import PackagePlugin
import XcodeProjectPlugin

extension XCStringsToolPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(
        context: XcodePluginContext,
        target: XcodeTarget
    ) throws -> [Command] {
        try target
            .inputFiles
            .stringTables
            .map { tableName, files in
                try .xcstringstool(forTableName: tableName, files: files, using: context)
            }
    }
}
#endif
