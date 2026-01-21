import ArgumentParser
import Foundation
import StringGenerator

extension AccessLevel {
    /// Resolves the appropriate value either from the command line input or from the environment
    static func resolveFromEnvironment(
        _ environment: [String: String] = ProcessInfo.processInfo.environment,
        or argument: Self?
    ) -> Self? {
        if let accessLevel = argument {
            return accessLevel
        }

        let buildSetting = environment["XCSTRINGS_TOOL_ACCESS_LEVEL"]?.lowercased()
        if let accessLevel = buildSetting.flatMap(AccessLevel.init(rawValue:)) {
            return accessLevel
        }

        if let swiftSettings = environment["SWIFT_ACTIVE_COMPILATION_CONDITIONS"] {
            if swiftSettings.contains("XCSTRINGS_TOOL_ACCESS_LEVEL_INTERNAL") {
                return .internal
            } else if swiftSettings.contains("XCSTRINGS_TOOL_ACCESS_LEVEL_PUBLIC") {
                return .public
            } else if swiftSettings.contains("XCSTRINGS_TOOL_ACCESS_LEVEL_PACKAGE") {
                return .package
            }
        }

        return nil
    }
}

#if compiler(>=6.0)
extension AccessLevel: ArgumentParser.ExpressibleByArgument {}
#else
extension AccessLevel: ExpressibleByArgument {}
#endif
