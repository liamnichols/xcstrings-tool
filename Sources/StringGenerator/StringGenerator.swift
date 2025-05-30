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
        accessLevel: AccessLevel,
        convertFromSnakeCase: Bool,
        importsUseExplicitAccessLevel: Bool
    ) -> String {
        generateSource(
            for: SourceFile(
                tableName: tableName,
                accessLevel: accessLevel,
                convertFromSnakeCase: convertFromSnakeCase,
                importsUseExplicitAccessLevel: importsUseExplicitAccessLevel,
                resources: resources
            )
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
    // https://github.com/liamnichols/xcstrings-tool/issues/97
    func patchingSwift6CompatibilityIssuesIfNeeded() -> String {
        #if !canImport(SwiftSyntax600)
        replacing(#/(?:[#@]available|==)\s\(/#, with: { match in
            match.output.filter { !$0.isWhitespace }
        })
        #else
        self
        #endif
    }
}
