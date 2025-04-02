import Foundation
import PackagePlugin

@main
struct XCStringsToolPlugin {
    func createBuildCommands(
        pluginWorkDirectory: Path,
        tool: (String) throws -> PluginContext.Tool,
        sourceFiles: FileList,
        targetName: String
    ) throws -> [Command] {
        let inputs = try PluginUtils.validateInputs(
            pluginWorkDirectory: pluginWorkDirectory,
            tool: tool,
            sourceFiles: sourceFiles,
            targetName: targetName
        )

        return inputs.invocations.map { invocation in
            .buildCommand(
                displayName: "XCStringsTool: Generate Swift code for ‘\(invocation.tableName)‘",
                executable: inputs.tool.path,
                arguments: inputs.arguments(for: invocation),
                inputFiles: inputs.inputFiles(for: invocation),
                outputFiles: inputs.outputFiles(for: invocation)
            )
        }
    }
}

extension XCStringsToolPlugin: BuildToolPlugin {
    func createBuildCommands(
        context: PluginContext,
        target: Target
    ) async throws -> [Command] {
        guard let sourceModule = target.sourceModule else {
            Diagnostics.warning("XCStringsToolPlugin does not support non-source targets")
            return []
        }

        return try createBuildCommands(
            pluginWorkDirectory: context.pluginWorkDirectory,
            tool: context.tool(named:),
            sourceFiles: sourceModule.sourceFiles,
            targetName: target.name
        )
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension XCStringsToolPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(
        context: XcodePluginContext,
        target: XcodeTarget
    ) throws -> [Command] {
        try createBuildCommands(
            pluginWorkDirectory: context.pluginWorkDirectory,
            tool: context.tool(named:),
            sourceFiles: target.inputFiles,
            targetName: target.displayName
        )
    }
}
#endif
