import Foundation
import StringResource
import SwiftBasicFormat
import SwiftIdentifier
import SwiftSyntax
import SwiftSyntaxBuilder

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
    }
}
