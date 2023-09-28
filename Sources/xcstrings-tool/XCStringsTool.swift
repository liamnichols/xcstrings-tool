import ArgumentParser

@main
struct XCStringsTool: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "xcstrings-tool",
        abstract: "Generates Swift code from String Catalogs (.xcstrings files)",
        version: "0.0.2",
        subcommands: [GenerateCommand.self],
        defaultSubcommand: GenerateCommand.self
    )
}
