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
    static func xcstringstool(for file: File, using context: PluginContextProtocol) throws -> Command {
        .buildCommand(
            displayName: "XCStringsTool: Generate Swift code for ‘\(file.path.lastComponent)‘",
            executable: try context.tool(named: "xcstrings-tool").path,
            arguments: [
                file.path,
                context.outputPath(for: file)
            ],
            inputFiles: [
                file.path
            ],
            outputFiles: [
                context.outputPath(for: file)
            ]
        )
    }
}

private extension PluginContextProtocol {
    var outputDirectory: Path {
        pluginWorkDirectory.appending(subpath: "XCStringsTool")
    }

    func outputPath(for file: File) -> Path {
        outputDirectory.appending("\(file.path.stem).swift")
    }
}

