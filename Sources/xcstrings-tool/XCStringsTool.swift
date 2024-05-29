import ArgumentParser
import XCStringsToolConstants

@main
struct XCStringsTool: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "xcstrings-tool",
        abstract: "Generates Swift code from String Catalogs (.xcstrings files)",
        version: version,
        subcommands: [Generate.self],
        defaultSubcommand: Generate.self
    )
}
