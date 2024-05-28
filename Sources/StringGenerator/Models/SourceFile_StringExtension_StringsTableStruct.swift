import StringResource
import SwiftSyntax
import XCStringsToolConstants

extension SourceFile.StringExtension {
    struct StringsTableStruct {
        let sourceFile: SourceFile

        var type: TokenSyntax {
            .identifier(sourceFile.tableTypeIdentifier)
        }

        var fullyQualifiedType: [TokenSyntax] {
            [.type(.String), type]
        }

        var accessors: [ResourceAccessor] {
            sourceFile.resources.map { resource in
                ResourceAccessor(sourceFile: sourceFile, resource: resource)
            }
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
            if let resource = sourceFile.resources.first(where: { $0.arguments.isEmpty }){
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
        A type that represents localized strings from the ‘\(sourceFile.tableName)‘
        strings table.

        Do not initialize instances of this type yourself, instead use one of the static
        methods or properties that have been generated automatically.

        ## Usage

        ### Foundation

        In Foundation, you can resolve the localized string using the system language
        with the `String`.``Swift/String/init(\(sourceFile.tableVariableIdentifier):locale:)``
        intializer:

        ```swift
        // Accessing the localized value directly
        let value = String(\(sourceFile.tableVariableIdentifier): .\(example.name))
        value // \"\(example.value)\"
        ```

        Starting in iOS 16/macOS 13/tvOS 16/watchOS 9, `LocalizedStringResource` can also
        be used:

        ```swift
        var resource = LocalizedStringResource(\(sourceFile.tableVariableIdentifier): .\(example.name))
        resource.locale = Locale(identifier: "fr") // customise language
        let value = String(localized: resource)    // defer lookup
        ```

        ### SwiftUI

        In SwiftUI, it is recommended to use `Text`.``SwiftUI/Text/init(\(sourceFile.tableVariableIdentifier):)``
        or `LocalizedStringKey`.``SwiftUI/LocalizedStringKey/\(sourceFile.tableVariableIdentifier)(_:)``
        in order for localized values to be resolved within the SwiftUI environment:

        ```swift
        var body: some View {
            List {
                Text(\(sourceFile.tableVariableIdentifier): .listContent)
            }
            .navigationTitle(.\(sourceFile.tableVariableIdentifier)(.navigationTitle))
            .environment(\\.locale, Locale(identifier: "fr"))
        }
        ```

        - SeeAlso: [XCStrings Tool Documentation - Using the generated source code](https://swiftpackageindex.com/liamnichols/xcstrings-tool/\(version)/documentation/documentation/using-the-generated-source-code)
        """
        }
    }
}
