import Foundation
import PackagePlugin

enum PluginError {
    case multipleConfigs(targetName: String, files: [Path])
}

extension PluginError: CustomStringConvertible, LocalizedError {
    var description: String {
        switch self {
        case .multipleConfigs(let targetName, let files):
            """
            Multiple config files found in the target named ‘\(targetName)‘, but either zero or one is expected. \
            Found \(files.map(\.description).joined(separator: ", "))
            """
        }
    }

    var errorDescription: String? { description }
}
