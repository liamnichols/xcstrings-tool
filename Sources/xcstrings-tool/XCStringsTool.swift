import ArgumentParser
import XCStringsToolConstants

@main
struct XCStringsTool: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "xcstrings-tool",
        abstract: "Generates Swift code from String Catalogs (.xcstrings files)",
        version: version,
        subcommands: [Generate.self],
        defaultSubcommand: Generate.self
    )

    @Flag var verbose = false

    func run() throws {
        isVerboseLoggingEnabled = verbose
    }
}
