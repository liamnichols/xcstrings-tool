import Foundation
import StringResource

public struct ResourceValidator {
    public struct Issue {
        public let description: String
    }

    let resources: [Resource]

    public static func validateResources(_ resources: [Resource]) -> [Issue] {
        ResourceValidator(resources: resources).discoverIssues()
    }

    func discoverIssues() -> [Issue] {
        [
            conflictingIdentifierIssues(),
            emptyIdentifierIssues()
        ]
        .flatMap({ $0 })
    }

    func conflictingIdentifierIssues() -> [Issue] {
        Dictionary(grouping: resources, by: \.identifier)
            .filter { $0.value.count > 1 }
            .mapValues { resources in
                resources
                    .map { "‘\($0.key)‘" }
                    .formatted(.list(type: .and))
            }
            .map { id, keys in
                Issue(
                    description: "The keys \(keys) produce the same identifier ‘\(id)‘."
                )
            }
    }

    func emptyIdentifierIssues() -> [Issue] {
        resources
            .filter { $0.identifier.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .map { resource in
                Issue(
                    description: "The key ‘\(resource.key)‘ is not supported for generating Swift constants."
                )
            }
    }
}
