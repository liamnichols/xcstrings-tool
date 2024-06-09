import StringExtractor
import StringResource

extension StringExtractor {
    static func mergeAndEnsureUnique(_ results: [Result]) throws -> [Resource] {
        if results.isEmpty { return [] }
        if results.count == 1 { return results[0].resources }

        let resources = results.flatMap { $0.resources }

        let keyed = Dictionary(grouping: resources, by: \.key)
        let conflicts = keyed.filter { $0.value.count > 1 }

        guard conflicts.isEmpty else {
            let conflicts = Array(conflicts.map(\.key)).formatted()
            throw Diagnostic(
                severity: .error,
                message: """
                Conflicting keys were found within the inputs: \(conflicts)
                """
            )
        }

        return resources.sorted()
    }
}
