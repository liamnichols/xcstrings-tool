import StringResource
import SwiftSyntax
import SwiftIdentifier

public struct StringsTable {
    public struct Name: RawRepresentable {
        public var rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }

    public let name: Name
    public let accessLevel: AccessLevel
    public let resources: [Resource]
}

extension StringsTable.Name {
    public var variableIdentifier: String {
        SwiftIdentifier.variableIdentifier(for: rawValue)
    }

    public var identifier: String {
        SwiftIdentifier.identifier(from: rawValue)
    }

    public var token: TokenSyntax {
        .identifier(identifier)
    }
}

extension StringsTable {
    public static let enclosingType: TokenSyntax = .type(.String)
    
    public var fullyQualifiedName: [TokenSyntax] {
        [Self.enclosingType, name.token]
    }

    public var example: (name: String, value: String) {
        if let resource = resources.first(where: { $0.arguments.isEmpty }){
            (
                name: resource.identifier,
                value: resource.sourceLocalization.replacingOccurrences(of: "\n", with: "\\n")
            )
        } else {
            (name: "foo", value: "bar")
        }
    }
}

extension StringsTable {
    var storedProperties: [(name: TokenSyntax, type: any TypeSyntaxProtocol)] {
        [
            ("key", .identifier(.StaticString)),
            ("arguments", ArrayTypeSyntax(element: .identifier(.Argument))),
            ("table", OptionalTypeSyntax(wrappedType: .identifier(.String))),
            ("bundle", .identifier(.BundleDescription))
        ]
    }

    var headerDocumentation: String {
        """
        Constant values for the \(name.rawValue) Strings Catalog

        ```swift
        // Accessing the localized value directly
        let value = String(\(name.variableIdentifier): .\(example.name))
        value // \"\(example.value)\"
        ```
        """
    }
}
