import Foundation
import RegexBuilder

/// A helper for parsing a string value within a string catalog to extract placeholder and substitution markers
struct StringParser {
    enum ParsedSegment: Equatable {
        case string(contents: String)
        case placeholder(PlaceholderType)
    }

    /// Parse the given input string including the expansion of the given substitutions
    static func parse(_ input: String, expandingSubstitutions substitutions: [String: String]) -> [ParsedSegment] {
        var input = input
        for (key, value) in substitutions {
            input = input.replacingOccurrences(of: "%#@\(key)@", with: value)
        }

        return parse(input)
    }

    /// Parses the given input string into an array of segments
    private static func parse(_ input: String) -> [ParsedSegment] {
        var segments: [ParsedSegment] = []
        var lastIndex = input.startIndex

        for match in input.matches(of: regex) {
            // Create a segment from the previous bound to here
            if match.range.lowerBound != lastIndex {
                let string = String(input[lastIndex ..< match.range.lowerBound])
                segments.append(.string(contents: string))
            }

            // Now create a segment for the match itself
            let output: (_, placeholder: PlaceholderType) = match.output
            segments.append(.placeholder(output.placeholder))

            // Update the last index for the next iteration
            lastIndex = match.range.upperBound
        }

        // If there was more content after the last match, append it to the final output
        if input.endIndex != lastIndex {
            let string = String(input[lastIndex ..< input.endIndex])
            segments.append(.string(contents: string))
        }

        return segments
    }
}

extension StringParser {
    static let regex = Regex {
        // The start of the specifier
        "%"

        // Optional, positional information
        Optionally {
            OneOrMore(.digit)
            "$"
        }

        // Optional, precision information
        Optionally(.anyOf("-+# 0"))
        Optionally(.digit)
        Optionally {
            "."
            One(.digit)
        }

        // Required, the format (inc lengths)
        TryCapture {
            ChoiceOf {
                "@"
                Regex {
                    Optionally {
                        ChoiceOf {
                            "h"
                            "hh"
                            "l"
                            "ll"
                            "q"
                            "z"
                            "t"
                            "j"
                        }
                    }
                    One(.anyOf("dioux"))
                }
                One(.anyOf("aefg"))
                One(.anyOf("csp"))
            }
        } transform: { rawValue -> PlaceholderType? in
            return PlaceholderType(formatSpecifier: rawValue)
        }
    }
}


