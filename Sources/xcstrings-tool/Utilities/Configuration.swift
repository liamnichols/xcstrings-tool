import Foundation
import StringGenerator
import Yams

struct Configuration {
    struct File: Codable {
        enum CodingKeys: String, CodingKey {
            case accessLevel = "access_level"
            case developmentLanguage = "development_language"
            case bundleOverride = "bundle_override"
        }

        var accessLevel: AccessLevel?
        var developmentLanguage: String?
        var bundleOverride: String?
    }

    var accessLevel: AccessLevel
    var developmentLanguage: String?
    var bundleOverride: String?
}

extension Configuration {
    init(
        command: Generate,
        environment: [String: String]
    ) throws {
        // If present, load options from file
        let file: File? = if let fileURL = command.config {
            try YAMLDecoder().decode(File.self, from: try Data(contentsOf: fileURL))
        } else {
            nil
        }

        // Resolve values from either the config file, environment, or arguments
        let accessLevel = file?.accessLevel ?? .resolveFromEnvironment(environment, or: command.accessLevel) ?? .internal
        let developmentLanguage = file?.developmentLanguage ?? command.developmentLanguage ?? environment["DEVELOPMENT_LANGUAGE"]
        let bundleOverride = file?.bundleOverride ?? command.bundleOverride
        self.init(
            accessLevel: accessLevel,
            developmentLanguage: developmentLanguage,
            bundleOverride: bundleOverride
        )
    }
}
