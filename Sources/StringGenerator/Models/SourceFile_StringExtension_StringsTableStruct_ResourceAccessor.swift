import StringResource
import SwiftSyntax
import SwiftIdentifier

extension SourceFile.StringExtension.StringsTableStruct {
    struct ResourceAccessor {
        let sourceFile: SourceFile
        let resource: Resource

        var hasArguments: Bool {
            !resource.arguments.isEmpty
        }

        var variableName: TokenSyntax {
            .identifier(resource.identifier
                .snakeCaseConverted(sourceFile.convertFromSnakeCase)
                .backtickedVariableNameIfNeeded
            )
        }

        var type: TokenSyntax {
            sourceFile.stringExtension.stringsTableStruct.type
        }

        var headerDocumentation: String {
            var docComponents: [String] = []

            if let comment = resource.comment {
                docComponents.append(comment)
            }

            docComponents.append("""
            ### Source Localization

            ```
            \(resource.sourceLocalization)
            ```
            """)

            return docComponents.joined(separator: "\n\n")
        }
    }
}
