import StringResource

extension Resource {
    static func extract(
        from segments: [StringParser.ParsedSegment],
        labels: [Int: String] = [:],
        key: String
    ) throws -> (arguments: [Argument], defaultValue: [StringSegment]) {
        var defaultValue: [StringSegment] = [], arguments: [Int: Argument] = [:]
        var nextUnspecifiedPosition = 1

        // Convert the parsed string into a default value and extract the arguments
        for segment in segments {
            switch segment {
            case .string(let contents):
                defaultValue.append(.string(contents))
            case .placeholder(let placeholder, let specifiedPosition):
                // Figure out the position of the argument for this placeholder
                let position: Int
                if let specifiedPosition {
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
                    type: placeholder.type
                )

                // If the same argument is represented by many placeholders,
                // ensure that they use the same type
                if let existing = arguments[position], existing.type != argument.type {
                    throw ExtractionError.localizationCorrupt(
                        ExtractionError.Context(
                            key: key,
                            debugDescription: """
                            The argument at position \(position) was specified multiple \
                            times but with different data types. First ‘\(existing.type)‘, \
                            then ‘\(argument.type)‘.
                            """
                        )
                    )
                }

                defaultValue.append(.interpolation(name))
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

        return (arguments.sorted(by: { $0.key < $1.key }).map(\.value), defaultValue)
    }
}

