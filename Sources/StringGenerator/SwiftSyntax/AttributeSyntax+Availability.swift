import SwiftSyntax

extension AttributeSyntax {
    init(availability: AvailabilityArgumentListSyntax) {
        self.init(
            attributeName: IdentifierTypeSyntax(name: "available"),
            leftParen: .leftParenToken(),
            arguments: .availability(availability),
            rightParen: .rightParenToken()
        )
    }
}

extension AvailabilityArgumentListSyntax {
    static var wwdc2022: AvailabilityArgumentListSyntax {
        [
            AvailabilityArgumentSyntax(argument: .platformVersionRestriction("macOS", versionMajor: 13))
                .with(\.trailingComma, .commaToken()),

            AvailabilityArgumentSyntax(argument: .platformVersionRestriction("iOS", versionMajor: 16))
                .with(\.trailingComma, .commaToken()),

            AvailabilityArgumentSyntax(argument: .platformVersionRestriction("tvOS", versionMajor: 16))
                .with(\.trailingComma, .commaToken()),

            AvailabilityArgumentSyntax(argument: .platformVersionRestriction("watchOS", versionMajor: 9))
                .with(\.trailingComma, .commaToken()),

            AvailabilityArgumentSyntax(argument: .token(.binaryOperator("*")))
        ]
    }
}

extension PlatformVersionSyntax {
    static func platform(_ identifier: String, versionMajor: Int) -> Self {
        PlatformVersionSyntax(
            platform: .identifier(identifier),
            version: VersionTupleSyntax(
                major: .integerLiteral(versionMajor.description),
                components: []
            )
        )
    }
}

extension AvailabilityArgumentSyntax.Argument {
    static func platformVersionRestriction(_ identifier: String, versionMajor: Int) -> Self {
        .availabilityVersionRestriction(.platform(identifier, versionMajor: versionMajor))
    }
}
