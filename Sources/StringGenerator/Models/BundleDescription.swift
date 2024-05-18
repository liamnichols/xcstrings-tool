import SwiftSyntax

struct BundleDescription {
    enum Case: String, CaseIterable {
        case main, atURL, forClass
    }

    let stringsTable: StringsTable
    
    var cases: [Case] {
        Case.allCases
    }

    var token: TokenSyntax {
        .type(.BundleDescription)
    }

    var fullyQualifiedName: [TokenSyntax] {
        stringsTable.fullyQualifiedName + [token]
    }
}

extension BundleDescription.Case {
    var name: TokenSyntax {
        .identifier(rawValue)
    }

    var parameters: [(name: TokenSyntax, type: TokenSyntax)] {
        switch self {
        case .main:
            []
        case .forClass:
            [(name: "anyClass", type: .type(.AnyClass))]
        case .atURL:
            [(name: "url", type: .type(.URL))]
        }
    }
}
