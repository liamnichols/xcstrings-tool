import SwiftSyntax

struct LocalizedStringResourceTable {
    let stringsTable: StringsTable
}

extension LocalizedStringResourceTable {
    public static let enclosingType: TokenSyntax = .type(.LocalizedStringResource)

    public var fullyQualifiedName: [TokenSyntax] {
        [Self.enclosingType, stringsTable.name.token]
    }

    var example: (name: String, value: String, accessor: String) {
        (
            name: stringsTable.example.name,
            value: stringsTable.example.value,
            accessor: ".\(stringsTable.name.variableIdentifier).\(stringsTable.example.name)"
        )
    }

    public var headerDocumentation: String {
        return """
        Constant values for the \(stringsTable.name.rawValue) Strings Catalog

        ```swift
        // Accessing the localized value directly
        let value = String(localized: \(example.accessor))
        value // \"\(example.value)\"

        // Working with SwiftUI
        Text(\(example.accessor))
        ```

        - Note: Using ``\(fullyQualifiedName.map(\.text).joined(separator: "."))`` requires \
        iOS 16/macOS 13 or later. See ``\((stringsTable.fullyQualifiedName.map(\.text).joined(separator: ".")))`` \
        for a backwards compatible API.
        """
    }
}
