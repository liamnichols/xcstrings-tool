import SwiftSyntax

extension SourceFile.StringExtension.StringsTableStruct {
    struct BundleDescriptionEnum {
        enum Case: String, CaseIterable {
            case main, atURL, forClass
        }

        let stringsTable: SourceFile.StringExtension.StringsTableStruct

        var cases: [Case] {
            Case.allCases
        }

        var type: TokenSyntax {
            .type(.BundleDescription)
        }

        var fullyQualifiedType: [TokenSyntax] {
            stringsTable.fullyQualifiedType + [type]
        }
    }
}

extension SourceFile.StringExtension.StringsTableStruct.BundleDescriptionEnum.Case {
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
