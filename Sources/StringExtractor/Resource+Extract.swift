import StringResource

extension Resource {
    static func extract(
        from segments: [StringParser.ParsedSegment],
        labels: [Int: String] = [:]
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
                    // TODO: Raise error.
                    assertionFailure("Repeated argument has mismatching placeholder types")
                }

                defaultValue.append(.interpolation(name))
                arguments[position] = argument
            }
        }

        // TODO: Raise error for missing arguments

        return (arguments.sorted(by: { $0.key < $1.key }).map(\.value), defaultValue)
    }
}

