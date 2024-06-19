import Foundation
import StringResource
import SwiftBasicFormat
import SwiftIdentifier
import SwiftSyntax
import SwiftSyntaxBuilder
import RegexBuilder

public struct StringGenerator {
    public static func generateSource(
        for resources: [Resource],
        tableName: String,
        accessLevel: AccessLevel
    ) -> String {
        generateSource(
            for: SourceFile(tableName: tableName, accessLevel: accessLevel, resources: resources)
        )
    }

    static func generateSource(
        for sourceFile: SourceFile
    ) -> String {
        SourceFileSnippet(sourceFile: sourceFile)
            .syntax
            .formatted()
            .description
            .patchingSwift6CompatibilityIssuesIfNeeded()
    }
}

private extension String {
    #if !canImport(SwiftSyntax600)
    static let prefix = Reference<Substring>()
    static let suffix = Reference<Substring>()

    static let regex = Regex {
        Capture(as: prefix) {
            ChoiceOf {
                Regex {
                    One(.anyOf("#@"))
                    "available"
                }
                "#if canImport"
            }
        }
        One(.whitespace)
        Capture(as: suffix) {
            "("
        }
    }
    #endif

    // https://github.com/liamnichols/xcstrings-tool/issues/97
    func patchingSwift6CompatibilityIssuesIfNeeded() -> String {
        #if !canImport(SwiftSyntax600)
        replacing(Self.regex, with: { match in
            match[Self.prefix] + match[Self.suffix]
        })
        #else
        self
        #endif
    }
}
