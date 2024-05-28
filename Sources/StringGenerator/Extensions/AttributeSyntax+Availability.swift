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

    init(
        _ platform: TokenSyntax,
        deprecated version: Int?,
        message: String
    ) {
        self.init(TypeSyntax(IdentifierTypeSyntax(name: .keyword(.available)))) {
            LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: platform))

            if let version {
                LabeledExprSyntax(
                    label: "deprecated",
                    expression: IntegerLiteralExprSyntax(version)
                )
            } else {
                LabeledExprSyntax(
                    expression: DeclReferenceExprSyntax(baseName: .identifier("deprecated"))
                )
            }

            LabeledExprSyntax(
                label: "message",
                expression: StringLiteralExprSyntax(content: message)
            )
        }
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

    static var wwdc2021: AvailabilityArgumentListSyntax {
        [
            AvailabilityArgumentSyntax(argument: .platformVersionRestriction("macOS", versionMajor: 12))
                .with(\.trailingComma, .commaToken()),

            AvailabilityArgumentSyntax(argument: .platformVersionRestriction("iOS", versionMajor: 15))
                .with(\.trailingComma, .commaToken()),

            AvailabilityArgumentSyntax(argument: .platformVersionRestriction("tvOS", versionMajor: 15))
                .with(\.trailingComma, .commaToken()),

            AvailabilityArgumentSyntax(argument: .platformVersionRestriction("watchOS", versionMajor: 8))
                .with(\.trailingComma, .commaToken()),

            AvailabilityArgumentSyntax(argument: .token(.binaryOperator("*")))
        ]
    }

    static var wwdc2019: AvailabilityArgumentListSyntax {
        [
            AvailabilityArgumentSyntax(argument: .platformVersionRestriction("macOS", versionMajor: 10, versionMinor: 5))
                .with(\.trailingComma, .commaToken()),

            AvailabilityArgumentSyntax(argument: .platformVersionRestriction("iOS", versionMajor: 13))
                .with(\.trailingComma, .commaToken()),

            AvailabilityArgumentSyntax(argument: .platformVersionRestriction("tvOS", versionMajor: 13))
                .with(\.trailingComma, .commaToken()),

            AvailabilityArgumentSyntax(argument: .platformVersionRestriction("watchOS", versionMajor: 6))
                .with(\.trailingComma, .commaToken()),

            AvailabilityArgumentSyntax(argument: .token(.binaryOperator("*")))
        ]
    }
}

extension PlatformVersionSyntax {
    static func platform(_ identifier: String, versionMajor: Int, versionMinor: Int? = nil) -> Self {
        PlatformVersionSyntax(
            platform: .identifier(identifier),
            version: VersionTupleSyntax(
                major: .integerLiteral(versionMajor.description),
                components: versionMinor.flatMap({ [VersionComponentSyntax(number: .integerLiteral($0.description))] }) ?? []
            )
        )
    }
}

extension AvailabilityArgumentSyntax.Argument {
    static func platformVersionRestriction(_ identifier: String, versionMajor: Int, versionMinor: Int? = nil) -> Self {
        .availabilityVersionRestriction(.platform(identifier, versionMajor: versionMajor, versionMinor: versionMinor))
    }
}
