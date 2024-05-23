import StringResource
import SwiftSyntax

extension SourceFile.StringExtension {
    struct StringsTableStruct {
        let sourceFile: SourceFile

        var type: TokenSyntax {
            .identifier(sourceFile.tableTypeIdentifier)
        }

        var fullyQualifiedType: [TokenSyntax] {
            [.type(.String), type]
        }

        var resources: [Resource] {
            sourceFile.resources
        }

        var accessLevel: AccessLevel {
            sourceFile.accessLevel
        }

        var argumentEnum: ArgumentEnum {
            ArgumentEnum(stringsTable: self)
        }

        var bundleDescriptionEnum: BundleDescriptionEnum {
            BundleDescriptionEnum(stringsTable: self)
        }

        // MARK: Properites

        var storedProperties: [Property] {
            [keyProperty, argumentsProperty, tableProperty, bundleProperty]
        }

        let keyProperty = Property(name: "key", type: .identifier(.StaticString))

        let argumentsProperty = Property(name: "arguments", type: ArrayTypeSyntax(element: .identifier(.Argument)))

        let tableProperty = Property(name: "table", type: OptionalTypeSyntax(wrappedType: .identifier(.String)))

        let bundleProperty = Property(name: "bundle", type: .identifier(.BundleDescription))

        let defaultValueProperty = Property(
            name: "defaultValue",
            type: MemberTypeSyntax(
                baseType: .identifier(.String),
                name: .type(.LocalizationValue)
            )
        )

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

        var headerDocumentation: String {
        """
        Constant values for the \(sourceFile.tableName) Strings Catalog

        ```swift
        // Accessing the localized value directly
        let value = String(\(sourceFile.tableVariableIdentifier): .\(example.name))
        value // \"\(example.value)\"
        ```
        """
        }
    }
}
