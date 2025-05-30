import Benchmark
import Foundation
import StringGenerator
import StringResource

let benchmarks = {
    Benchmark("StringGenerator.generateSource(for:tableName:accessLevel:convertFromSnakeCase:importsUseExplicitAccessLevel:)", configuration: .custom) { _, resources in
        blackHole(
            StringGenerator.generateSource(
                for: resources,
                tableName: "Localizable",
                accessLevel: .internal,
                convertFromSnakeCase: false,
                importsUseExplicitAccessLevel: false
            )
        )
    } setup: {
        (1...1000).map({ Resource.mock(id: $0, includeArguments: $0 % 5 == 0) })
    }
}

extension Resource {
    static func mock(id: Int, includeArguments: Bool = false) -> Resource {
        Resource(
            key: "String\(id)",
            comment: "Resource for string \(id)",
            identifier: "string\(id)",
            arguments: id % 5 == 0 ? [.init(label: nil, name: "arg1", placeholderType: .object)] : [],
            sourceLocalization: "String \(id): %@"
        )
    }
}

extension Benchmark.Configuration {
    static var custom: Benchmark.Configuration {
        Benchmark.Configuration(
            metrics: [.cpuTotal],
            thresholds: [
                .cpuTotal: .relaxed
            ]
        )
    }
}
