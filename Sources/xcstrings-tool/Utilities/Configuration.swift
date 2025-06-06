import Foundation
import StringGenerator
import Yams

struct Configuration {
    struct File: Codable {
        var accessLevel: AccessLevel?
        var developmentLanguage: String?
        var verbose: Bool?
        var convertFromSnakeCase: Bool?
        var importsUseExplicitAccessLevel: Bool?
    }

    var accessLevel: AccessLevel
    var developmentLanguage: String?
    var verbose: Bool
    var convertFromSnakeCase: Bool
    var importsUseExplicitAccessLevel: Bool
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
        let verbose = file?.verbose ?? command.verbose
        let convertFromSnakeCase = file?.convertFromSnakeCase ?? command.convertFromSnakeCase
        let importsUseExplicitAccessLevel = file?.importsUseExplicitAccessLevel ?? command.importsUseExplicitAccessLevel

        self.init(
            accessLevel: accessLevel,
            developmentLanguage: developmentLanguage,
            verbose: verbose,
            convertFromSnakeCase: convertFromSnakeCase,
            importsUseExplicitAccessLevel: importsUseExplicitAccessLevel
        )
    }
}
