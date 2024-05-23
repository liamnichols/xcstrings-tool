import StringResource
import SwiftSyntax

extension SourceFile.LocalizedStringResourceExtension {
    struct StringsTableStruct {
        let sourceFile: SourceFile

        var type: TokenSyntax {
            .identifier(sourceFile.tableTypeIdentifier)
        }

        var fullyQualifiedType: [TokenSyntax] {
            [.type(.LocalizedStringResource), type]
        }

        var accessors: [ResourceAccessor] {
            sourceFile.resources.map { resource in
                ResourceAccessor(sourceFile: sourceFile, resource: resource)
            }
        }

        var accessLevel: AccessLevel {
            sourceFile.accessLevel
        }

        var example: (name: String, value: String, accessor: String) {
            (
                name: sourceFile.stringExtension.stringsTableStruct.example.name,
                value: sourceFile.stringExtension.stringsTableStruct.example.value,
                accessor: ".\(sourceFile.tableVariableIdentifier).\(sourceFile.stringExtension.stringsTableStruct.example.name)"
            )
        }

        public var headerDocumentation: String {
            return """
            Constant values for the \(sourceFile.tableName) Strings Catalog

            ```swift
            // Accessing the localized value directly
            let value = String(localized: \(example.accessor))
            value // \"\(example.value)\"

            // Working with SwiftUI
            Text(\(example.accessor))
            ```

            - Note: Using ``\(fullyQualifiedType.map(\.text).joined(separator: "."))`` requires \
            iOS 16/macOS 13 or later. See ``\((sourceFile.stringExtension.stringsTableStruct.fullyQualifiedType.map(\.text).joined(separator: ".")))`` \
            for a backwards compatible API.
            """
        }
    }
}
