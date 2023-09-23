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
            .sourceFiles(withSuffix: "xcstrings")
            .map { try .xcstringstool(for: $0, using: context) }
    }
}
