import StringResource

extension Resource {
    static func extract(
        from segments: [StringParser.ParsedSegment],
        labels: [Int: String] = [:],
        key: String
    ) throws -> (arguments: [Argument], sourceLocalization: String) {
        var sourceLocalization: String = "", arguments: [Int: Argument] = [:]
        var nextUnspecifiedPosition = 1

        // Convert the parsed string into a default value and extract the arguments
        for segment in segments {
            switch segment {
            case .string(let contents):
                sourceLocalization.append(contents)
            case .placeholder(let placeholder) where placeholder.rawValue == "%" || placeholder.rawValue == "%%":
                sourceLocalization.append(placeholder.rawValue)
            case .placeholder(let placeholder):
                // If the placeholder is an unsupported type, raise an error about the invalid string
                guard let _type = placeholder.type, let type = PlaceholderType(_type) else {
                    throw ExtractionError.unsupported(
                        ExtractionError.Context(
                            key: key,
                            debugDescription: """
                            The placeholder format specifier ‘\(placeholder.rawValue)‘ is not supported.
                            """
                        )
                    )
                }

                // Figure out the position of the argument for this placeholder
                let position: Int
                if let specifiedPosition = placeholder.position {
                    position = specifiedPosition
                } else {
                    position = nextUnspecifiedPosition
                    nextUnspecifiedPosition += 1
                }

                // Create the argument for this placeholder
                let name = "arg\(position)"
                let argument = Argument(
                    label: labels[position],
                    name: name,
                    placeholderType: type
                )

                // If the same argument is represented by many placeholders,
                // ensure that they use the same type
                if let existing = arguments[position], existing.placeholderType != argument.placeholderType {
                    throw ExtractionError.localizationCorrupt(
                        ExtractionError.Context(
                            key: key,
                            debugDescription: """
                            The argument at position \(position) was specified multiple \
                            times but with different data types. First ‘\(existing.placeholderType)‘, \
                            then ‘\(argument.placeholderType)‘.
                            """
                        )
                    )
                }

                sourceLocalization.append(placeholder.rawValue)
                arguments[position] = argument
            }
        }

        // Ensure that all arguments are accounted for
        if !arguments.isEmpty {
            for argNum in 1 ... arguments.count where !arguments.keys.contains(argNum) {
                throw ExtractionError.localizationCorrupt(
                    ExtractionError.Context(
                        key: key,
                        debugDescription: """
                        The argument at position \(argNum) was not included in the \
                        source localization and it's type cannot be inferred.
                        """
                    )
                )
            }
        }

        return (arguments.sorted(by: { $0.key < $1.key }).map(\.value), sourceLocalization)
    }
}

private extension PlaceholderType {
    init?(_ formatSpecifier: String) {
        // TODO: Be more strict about lengths
        // By using `.last`, we are dropping any potential length info
        switch formatSpecifier.last {
        case "@":
            self = .object
        case "a", "e", "f", "g":
            self = .double
        case "d", "i":
            self = .int
        case "u", "x", "X", "o":
            self = .uint
        default:
            return nil
        }
    }
}
