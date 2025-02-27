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
        using context: PluginContextProtocol,
        config: Path?
    ) throws -> Command {
        var inputFiles: [Path] = files.map(\.path)
        var arguments: [any CustomStringConvertible] = files.map(\.path.string)
        arguments.append(contentsOf: ["--output", context.outputPath(for: tableName)])

        if let config {
            arguments.append(contentsOf: ["--config", config])
            inputFiles.append(config)
        }

        return .buildCommand(
            displayName: "XCStringsTool: Generate Swift code for ‘\(tableName)‘",
            executable: try context.tool(named: "xcstrings-tool").path,
            arguments: arguments,
            inputFiles: inputFiles,
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

