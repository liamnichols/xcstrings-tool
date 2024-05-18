import SwiftSyntax

struct Argument {
    enum Case: String, CaseIterable {
        case object, int, uint, double, float
    }

    let stringsTable: StringsTable

    var cases: [Case] {
        Case.allCases
    }

    var token: TokenSyntax {
        .type(.Argument)
    }

    var fullyQualifiedName: [TokenSyntax] {
        stringsTable.fullyQualifiedName + [token]
    }
}

extension Argument.Case {
    var name: TokenSyntax {
        .identifier(rawValue)
    }

    var parameters: [TokenSyntax] {
        switch self {
        case .object:
            [.type(.String)]
        case .int:
            [.type(.Int)]
        case .uint:
            [.type(.UInt)]
        case .float:
            [.type(.Float)]
        case .double:
            [.type(.Double)]
        }
    }
}
