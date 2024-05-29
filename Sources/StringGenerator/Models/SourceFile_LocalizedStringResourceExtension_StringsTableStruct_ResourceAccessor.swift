import StringResource
import SwiftSyntax

extension SourceFile.LocalizedStringResourceExtension.StringsTableStruct {
    struct ResourceAccessor {
        let sourceFile: SourceFile
        let resource: Resource

        var hasArguments: Bool {
            !resource.arguments.isEmpty
        }

        var variableName: TokenSyntax {
            .identifier(resource.identifier.backtickedVariableNameIfNeeded)
        }

        var nameForMemberAccess: TokenSyntax {
            .identifier(resource.identifier)
        }

        var type: some TypeSyntaxProtocol {
            IdentifierTypeSyntax(name: .type(.LocalizedStringResource))
        }

        var alternativeSignature: String {
            let type = sourceFile.stringExtension.stringsTableStruct.fullyQualifiedType.map(\.text).joined(separator: ".")
            let name = resource.identifier

            if hasArguments {
                let arguments = resource.arguments.map({ "\($0.label ?? "_"):" }).joined()
                return "\(type).\(name)(\(arguments))"
            } else {
                return "\(type).\(name)"
            }
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
