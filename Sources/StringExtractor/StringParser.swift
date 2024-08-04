import Foundation
import RegexBuilder

/// A helper for parsing a string value within a string catalog to extract placeholder and substitution markers
struct StringParser {
    enum ParsedSegment: Equatable {
        case string(contents: String)
        case placeholder(Placeholder)
    }

    struct Placeholder: Equatable {
        let rawValue: String
        let position: Int?
        let type: String?
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

        for match in input.matches(of: Self.regex) {
            // Create a segment from the previous bound to here
            if match.range.lowerBound != lastIndex {
                let string = String(input[lastIndex ..< match.range.lowerBound])
                segments.append(.string(contents: string))
            }

            // Now create a segment for the match itself
            let output: (rawValue: Substring, position: Int?, type: String?) = match.output
            segments.append(.placeholder(Placeholder(
                rawValue: String(output.rawValue),
                position: output.position,
                type: output.type
            )))

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
    static var regex: Regex<Regex<(Substring, Int?, String)>.RegexOutput> {
        Regex {
            // The start of the specifier
            "%"

            // Optional, positional information
            Optionally {
                TryCapture {
                    OneOrMore(.digit)
                } transform: { rawValue in
                    Int(rawValue)
                }
                "$"
            }

            // Optional, precision information
            Optionally(.anyOf("-+"))
            Optionally(.digit)
            Optionally {
                "."
                One(.digit)
            }

            // Required, the type (inc lengths)
            TryCapture {
                ChoiceOf {
                    "%"
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
            } transform: { rawValue in
                String(rawValue)
            }
        }
    }
}
