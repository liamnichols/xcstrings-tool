import Foundation
import PackagePlugin

protocol PluginContextProtocol {
    var pluginWorkDirectory: PackagePlugin.Path { get }
    func tool(named name: String) throws -> PluginContext.Tool
}

extension PluginContext: PluginContextProtocol { }

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin
extension XcodePluginContext: PluginContextProtocol {}
#endif

extension Command {
    static func xcstringstool(
        forTableName tableName: String,
        files: [File],
        using context: PluginContextProtocol
    ) throws -> Command {
        .buildCommand(
            displayName: "XCStringsTool: Generate Swift code for ‘\(tableName)‘",
            executable: try context.tool(named: "xcstrings-tool").path,
            arguments: files.map(\.path.string) + [
                "--output", context.outputPath(for: tableName)
            ],
            inputFiles: files.map(\.path),
            outputFiles: [
                context.outputPath(for: tableName)
            ]
        )
    }
}

private extension PluginContextProtocol {
    var outputDirectory: Path {
        pluginWorkDirectory.appending(subpath: "XCStringsTool")
    }

    func outputPath(for tableName: String) -> Path {
        outputDirectory.appending("\(tableName).swift")
    }
}

