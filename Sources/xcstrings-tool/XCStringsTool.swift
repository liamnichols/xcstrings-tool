import ArgumentParser
import Version

@main
struct XCStringsTool: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "xcstrings-tool",
        abstract: "Generates Swift code from String Catalogs (.xcstrings files)",
        version: version,
        subcommands: [Generate.self],
        defaultSubcommand: Generate.self
    )
}
